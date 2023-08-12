import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:video_app/admin/admin_home.dart';
import 'package:video_app/constant/widget/loading.dart';
import 'package:video_app/model/user_model.dart';
import 'package:video_app/screen/bottom_nav/bottom_nav.dart';

class Authentication {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _firebaseAuth = FirebaseAuth.instance;

  userRegister(
    email,
    password,
    context,
    image,
  ) async {
    SmartDialog.showLoading(
      animationBuilder: (controller, child, animationParam) {
        return Loading(
          text: 'Please wait...',
        );
      },
    );

    try {
      // OSDeviceState? status = await OneSignal.shared.getDeviceState();

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
        name: '',
        token: '',
        email: email,
        password: password,
        profilePic: image,
        uid: userCredential.user!.uid,
        // token: status!.userId,
      );

      if (userCredential.user!.uid.isNotEmpty) {
        users
            .doc(userCredential.user!.uid)
            .set(userModel.toMap())
            .then((value) => {
                  SmartDialog.dismiss(),
                  Get.snackbar('Success !', 'Account Created Successfully',
                      backgroundColor: Colors.white54),
                  Get.offAll(() => const BottomBars()),
                });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Error !',
          'The account already exists for that email.',
        );
        SmartDialog.dismiss();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.toString()} '),
        ),
      );
      SmartDialog.dismiss();
    }
  }

  adminLogin(
    email,
    password,
    context,
  ) async {
    SmartDialog.showLoading(
      animationBuilder: (controller, child, animationParam) {
        return Loading(text: 'Please wait...');
      },
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.uid.isNotEmpty) {
        Get.snackbar('Login !', 'Successfully Login !',
            backgroundColor: Colors.white54);
        Get.offAll(() => const AdminHome());
        SmartDialog.dismiss();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Login !', 'This email is not registor as user.',
            backgroundColor: Colors.white54);
        SmartDialog.dismiss();
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Password !', 'Wrong Password!',
            backgroundColor: Colors.white54);
        SmartDialog.dismiss();
      }
    }
  }

  userLogin(
    email,
    password,
    context,
  ) async {
    SmartDialog.showLoading(
      animationBuilder: (controller, child, animationParam) {
        return Loading(text: 'Please wait...');
      },
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user!.uid.isNotEmpty) {
        Get.snackbar('Login !', 'Successfully Login !',
            backgroundColor: Colors.white54);
        Get.offAll(() => const BottomBars());
        SmartDialog.dismiss();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Login !', 'This email is not registor as user.',
            backgroundColor: Colors.white54);
        SmartDialog.dismiss();
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Password !', 'Wrong Password!',
            backgroundColor: Colors.white54);
        SmartDialog.dismiss();
      }
    }
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    try {
      SmartDialog.showLoading(
        animationBuilder: (controller, child, animationParam) {
          return Loading(
            text: 'Please wait...',
          );
        },
      );
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final User? user =
          (await _auth.signInWithCredential(authCredential)).user;
      UserModel userModel = UserModel(
        uid: user!.uid,
        name: user.displayName,
        email: user.email,
        profilePic: user.photoURL,
        password: '',
      );
      // ignore: unnecessary_null_comparison
      if (user != null) {
        users.doc(user.uid).get().then((doc) {
          if (doc.exists) {
            users.doc(user.uid).update(userModel.toMap());
            Get.to(() => const BottomBars());
          } else {
            users.doc(user.uid).set(userModel.toMap());
            Get.to(() => const BottomBars());
          }
        });
      }
      SmartDialog.dismiss();
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(content: 'Login Cancelled'),
      );
      SmartDialog.dismiss();
      rethrow;
    }
  }

  loginWithFacebook() async {
    try {
      User? user;

      SmartDialog.showLoading(msg: "Please wait...");
      final facebook = FacebookLogin();
      FacebookLoginResult facebookLoginResult =
          await facebook.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
        FacebookPermission.userPhotos
      ]);
      // ignore: unused_local_variable
      FacebookUserProfile? facebookUserProfile =
          await facebook.getUserProfile();
      String? facebookEmail = await facebook.getUserEmail();
      String? imageurl = await facebook.getProfileImageUrl(width: 400);
      OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      user = userCredential.user;
      // OSDeviceState? status = await OneSignal.shared.getDeviceState();
      // String token = status!.userId!;
      UserModel userModel = UserModel(
        uid: user!.uid,
        name: user.displayName,
        email: facebookEmail,
        profilePic: imageurl,
        password: '',
      );
      users.doc(user.uid).get().then((doc) {
        if (doc.exists) {
          users.doc(user!.uid).update(userModel.toMap());
          Get.offAll(() => const BottomBars());
        } else {
          users.doc(user!.uid).set(userModel.toMap());
          Get.offAll(() => const BottomBars());
        }
      });

      SmartDialog.dismiss();
    } catch (e) {
      e.toString();
      print("error here: " + e.toString());
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    SmartDialog.showLoading(
      animationBuilder: (controller, child, animationParam) {
        return Loading(
          text: 'Please wait...',
        );
      },
    );
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (firebaseUser.uid.isNotEmpty) {
          final fullName = appleIdCredential.fullName;
          UserModel userModel = UserModel(
            uid: firebaseUser.uid,
            name: fullName!.givenName,
            email: firebaseUser.email,
            profilePic: firebaseUser.photoURL,
            password: '',
          );
          await users.doc(firebaseUser.uid).set(userModel.toMap());
          Get.offAll(() => const BottomBars());
          SmartDialog.dismiss();
        }

        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }
}
