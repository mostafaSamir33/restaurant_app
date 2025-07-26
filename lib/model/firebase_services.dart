import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app/model/user_model.dart';

import 'food_data_model.dart';

class FirebaseServices {
  //firebase authentication
  static CollectionReference<UserModel> getUsersCollection() {
    CollectionReference<UserModel> usersCollection = FirebaseFirestore.instance
        .collection('Users')
        .withConverter<UserModel>(
          fromFirestore:
              (snapshot, options) => UserModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toJson(),
        );
    return usersCollection;
  }

  static Future<void> addNewUser(UserModel user) async {
    CollectionReference<UserModel> usersCollection = getUsersCollection();
    DocumentReference<UserModel> document = usersCollection.doc(user.uId);
    await document.set(user);
  }

  static Future<UserModel?> getUserInfo(String uid) async {
    CollectionReference<UserModel> usersCollection = getUsersCollection();
    DocumentSnapshot<UserModel> document = await usersCollection.doc(uid).get();
    return document.data();
  }

  static Future<UserModel> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    UserModel userModel = UserModel(
      email: email,
      name: name,
      uId: userCredential.user!.uid,
    );
    await addNewUser(userModel);
    return userModel;
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user?.uid != null) {
      UserModel? userModel = await getUserInfo(userCredential.user!.uid);
      return userModel;
    }
    return null;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //menu firebase firestore
  static CollectionReference<FoodDataModel> getMenuCollection() {
    CollectionReference<FoodDataModel> menuCollection = FirebaseFirestore
        .instance
        .collection('Menu')
        .withConverter<FoodDataModel>(
          fromFirestore:
              (snapshot, options) =>
                  FoodDataModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toJson(),
        );
    return menuCollection;
  }

  static Future<void> addFoodToMenu(FoodDataModel foodDataModel) async {
    CollectionReference<FoodDataModel> menuCollection = getMenuCollection();
    DocumentReference<FoodDataModel> document = menuCollection.doc(
      foodDataModel.id,
    );
    await document.set(foodDataModel);
  }

  static Stream<List<FoodDataModel>> getAllMenuStream() {
    CollectionReference<FoodDataModel> menuCollection = getMenuCollection();
    Stream<QuerySnapshot<FoodDataModel>> querySnapshot =
        menuCollection.snapshots();
    var streamData = querySnapshot.map(
      (food) => food.docs.map((e) => e.data()).toList(),
    );
    return streamData;
  }

  //cart firebase firestore
  static CollectionReference<FoodDataModel> getCartCollection() {
    CollectionReference<FoodDataModel> cartCollection = getUsersCollection()
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('User Cart')
        .withConverter<FoodDataModel>(
          fromFirestore:
              (snapshot, options) =>
                  FoodDataModel.fromJson(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toJson(),
        );
    return cartCollection;
  }

  static Future<void> addFoodToCart(FoodDataModel foodDataModel) async {
    CollectionReference<FoodDataModel> cartCollection = getCartCollection();
    DocumentReference<FoodDataModel> document = cartCollection.doc(
      foodDataModel.id,
    );
    foodDataModel.createdAt = DateTime.now();
    await document.set(foodDataModel);
  }

  static Stream<List<FoodDataModel>> getAllCartStream() {
    CollectionReference<FoodDataModel> cartCollection = getCartCollection();
    Stream<QuerySnapshot<FoodDataModel>> querySnapshot =
        cartCollection.orderBy('createdAt', descending: true).snapshots();
    var streamData = querySnapshot.map(
      (food) => food.docs.map((e) => e.data()).toList(),
    );
    return streamData;
  }

  static Future<void> deleteFood(FoodDataModel foodDataModel) async {
    CollectionReference<FoodDataModel> cartCollection = getCartCollection();
    await cartCollection.doc(foodDataModel.id).delete();
  }
}
