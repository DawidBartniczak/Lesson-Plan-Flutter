import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleAuth = GoogleSignIn(scopes: ['email']);
final FacebookLogin _facebookAuth = FacebookLogin();
final Firestore _firestore = Firestore.instance;

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text('Wystąpił problem!'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('ZAMKNIJ'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );
}

Future<void> createUserInDatabase(FirebaseUser user) async {
  Map<String, Object> userData = {
    'email': user.email,
    'haveRemoteClass': false,
    'remoteClassID': '',
    'timestamp': FieldValue.serverTimestamp(),
  };

  try {
    await _firestore.collection('user').document(user.uid)
      .setData(userData);
  } catch (error) {
    await user.delete();
    throw error;
  }
}

Future<void> registerWithPassword(BuildContext context, String email, String password) async {
  try {
    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: email,password: password)).user;

    await createUserInDatabase(user);
  } catch (error) {
    String errorMessage;

    if (error.code == 'ERROR_EMAIL_ALREADY_IN_USE')
      errorMessage = 'Istnieje już konto zarejestrowane na ten adres E-Mail!';
    else if (error.code == "ERROR_NETWORK_REQUEST_FAILED")
      errorMessage = 'Nie można było połączyć z serwerem!';
    else 
      errorMessage = "Nieznany problem!";
    
    showErrorDialog(context, errorMessage);
  }
}

Future<void> loginWithPassword(BuildContext context, String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);

    Navigator.of(context).pop();
  } catch(error) {
    print(error.code);
    String errorMessage;

    if (error.code == 'ERROR_USER_NOT_FOUND')
      errorMessage = 'Takie konto nie istnieje!';
    else if (error.code == 'ERROR_WRONG_PASSWORD')
      errorMessage = 'Błędne hasło!';
    else if (error.code == 'ERROR_NETWORK_REQUEST_FAILED')
      errorMessage = 'Nie można było połączyć z serwerem!';
    else 
      errorMessage = "Nieznany problem!";
    
    showErrorDialog(context, errorMessage);
  }
}

Future<void> handleCredential(AuthCredential credential) async {
  AuthResult result = await _auth.signInWithCredential(credential);

  if (result.additionalUserInfo.isNewUser)
    await createUserInDatabase(result.user);
}

Future<void> authenticateWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount googleUser = await _googleAuth.signIn();
    final GoogleSignInAuthentication googleAuthentication = await googleUser.authentication;

    final AuthCredential credential =  GoogleAuthProvider.getCredential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken
    );

    await handleCredential(credential);
  } catch(error) {
    String errorMessage;

      if (error.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL')
        errorMessage = 'Istnieje już konto zarejestrowane na ten adres E-Mail!';
      else
        errorMessage = 'Nieznany problem!';
      
      showErrorDialog(context, errorMessage);
  }
}

Future<void> authenticateWithFacebook(BuildContext context) async {
  final FacebookLoginResult result = await _facebookAuth.logInWithReadPermissions(['email']);

  if (result.status == FacebookLoginStatus.loggedIn) {
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token
    );

    try {
      await handleCredential(credential);
    } catch (error) {
      String errorMessage;

      if (error.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL')
        errorMessage = 'Istnieje już konto zarejestrowane na ten adres E-Mail!';
      else
        errorMessage = 'Nieznany problem!';
      
      showErrorDialog(context, errorMessage);
    }
  } else if (result.status == FacebookLoginStatus.error)
    showErrorDialog(context, "Nieznany problem!");
}

Future<void> updatePassword(BuildContext context, FirebaseUser user, String oldPassword, String newPassword, String newPasswordConfirm) async {
  try {
    if (newPassword != newPasswordConfirm)
      throw AuthException('ERROR_PASSWORDS_DONT_MATCH', '');

    AuthCredential credential = EmailAuthProvider.getCredential(
      email: user.email,
      password: oldPassword
    );
    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
  } catch(error) {
    String errorMessage;

    print(error);

    if (error.code == 'ERROR_PASSWORDS_DONT_MATCH')
      errorMessage = 'Hasła się nie zgadzają!';
    else if (error.code == 'ERROR_WRONG_PASSWORD')
      errorMessage = 'Błędne hasło!';
    else if (error.code == 'ERROR_NETWORK_REQUEST_FAILED')
      errorMessage = 'Nie można było połączyć z serwerem!';
    else 
      errorMessage = "Nieznany problem!";

    showErrorDialog(context, errorMessage);
  }
}