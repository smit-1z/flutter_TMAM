import 'package:authentification/Controllers/firestore_controller.dart';
import 'package:authentification/Controllers/providers/user_provider.dart';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/utils/constants.dart';
import 'package:authentification/utils/my_print.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserController {

  Future<bool> isUserExist(BuildContext context, String uid) async {
    if (uid == null || uid.isEmpty) return false;

    DocumentSnapshot<
        Map<String, dynamic>> documentSnapshot = await FirestoreController()
        .firestore.collection(USERS_COLLECTION).doc(uid)
        .get();
    if (documentSnapshot.exists) {
      UserProvider userProvider = Provider.of<UserProvider>(
          context, listen: false);
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data != null && data.isNotEmpty) {
        if (userProvider.userModel == null)
          userProvider.userModel = UserModel.fromMap(data);
        else{

        }
          // userProvider.userModel?.updateFromMap(data);
        //await SembastManager().set(SEMBAST_USERDATA, userProvider.userModel!.sembastToMap());
        //await SembastManager().set(SEMBAST_USERID, userProvider.userModel!.id);
      }
    }

    return documentSnapshot.exists;
  }

  Future<void> createNewUser(BuildContext context, {String? loginType}) async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      User user = userProvider.firebaseUser!;

      if(loginType == null || loginType.isEmpty) {
        loginType = user.email != null && user.email!.isNotEmpty
            ? (user.displayName != null && user.displayName!.isNotEmpty ? LOGIN_TYPE_GOOGLE : LOGIN_TYPE_EMAIL):LOGIN_TYPE_EMAIL;

      }

      if(user != null) {
        UserModel userModel = UserModel(
          id: user.uid,
          name: user.displayName,
          email: user.email

        );

        Map<String, dynamic> data = userModel.toMap();
        data["createdtime"] = FieldValue.serverTimestamp();

        WriteBatch batch = FirestoreController().firestore.batch();

        batch.set(FirestoreController().firestore.collection(USERS_COLLECTION).doc(user.uid), data);
        await batch.commit().whenComplete(() async {
          FirestoreController().firestore.collection(USERS_COLLECTION).doc(user.uid).get().then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
            UserModel userModel = UserModel.fromMap(documentSnapshot.data() ?? {});
          });
        });

        //MyPrint.logOnConsole("User:${userProvider.userModel}");

        MyPrint.printOnConsole("Create User Completed");
      }
    }
    catch(e) {
      MyPrint.printOnConsole("Error in UserController().createUser():${e}");
    }
  }

}
