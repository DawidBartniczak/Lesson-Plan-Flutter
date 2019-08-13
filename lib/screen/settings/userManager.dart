import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:validators/validators.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../../widget/progressIndicator.dart';
import '../../model/userAuth.dart';
import '../../widget/changePasswordBottomSheet.dart';
import '../../widget/changeEmailBottomSheet.dart';

class UserManager extends StatefulWidget {
  @override
  _UserManagerState createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager> {
  bool _isLoading = false;
  FirebaseUser _user;

  void _updatePasswordTapped(String oldPassword, String newPassword, String newPasswordConfirm) {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      updatePassword(context, _user, oldPassword, newPassword, newPasswordConfirm)
        .then((_) => setState(() => _isLoading = false));
    }
  }

  void _updateEmailTapped(String password, String newEmail) {
    if (!_isLoading) {
      setState(() => _isLoading = true);
    }
  }

  void showChangePasswordBottomSheet(BuildContext context) {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return ChangePasswordBottomSheet(_updatePasswordTapped);
      }
    );
  }

  void showChangeEmailBottomSheet(BuildContext context) {
    showRoundedModalBottomSheet(
      context: context,
      dismissOnTap: false,
      builder: (_) {
        return ChangeEmailBottomSheet(_updateEmailTapped);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opcje Konta'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AnimatedProgressIndicator(_isLoading),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (_, AsyncSnapshot<FirebaseUser> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.done) {
            _user = userSnapshot.data;
            String userProvider;
            bool isEmail;

            for (UserInfo provider in _user.providerData) {
              switch (provider.providerId) {
                case 'google.com':
                  userProvider = 'Google';
                  isEmail = false;
                  break;
                case 'facebook.com':
                  userProvider = 'Facebook';
                  isEmail = false;
                  break;
                default:
                  userProvider = 'E-Mail';
                  isEmail = true;
                  break;
              }
            }

            return ListView(
              children: <Widget>[
                SizedBox(height: 8.0,),
                ListTile(
                  title: Text(_user.email),
                  subtitle: Text(userProvider),
                  leading: CircleAvatar(
                    radius: 25,
                    child: Text(
                      _user.email[0].toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                Divider(),
                if (isEmail) Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('Dane', style: Theme.of(context).textTheme.subtitle),
                ),
                if (isEmail) InkWell(
                  onTap: () => showChangeEmailBottomSheet(context),
                  child: ListTile(
                    title: Text('Zmiana E-Mail\'a'),
                    subtitle: Text('Uaktualnij adres E-Mail.'),
                  ),
                ),
                if (isEmail) InkWell(
                  onTap: () => showChangePasswordBottomSheet(context),
                  child: ListTile(
                    title: Text('Zmiana Hasła'),
                    subtitle: Text('Uaktualnij hasło.'),
                  ),
                ),
                if (isEmail) Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('Zerowanie', style: Theme.of(context).textTheme.subtitle),
                ),
                InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut()
                      .then((_) {
                        Navigator.of(context).pop();
                      });
                  },
                  child: ListTile(
                    title: Text('Usuń konto', style: TextStyle(color: Colors.red),),
                    subtitle: Text('Usuń konto z serwera.'),
                  ),
                ),
                Divider()
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
