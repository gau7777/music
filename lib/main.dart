import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'song.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  Widget abc;
  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    final FirebaseUser firebaseUser =
        await firebaseAuth.signInWithCredential(credential);
    print("signed in " + firebaseUser.displayName);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Song(
                  firebaseUser: firebaseUser,
                  googleSignIn: googleSignIn,
                )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (googleSignIn.isSignedIn() == true) {
      abc = Song();
    } else {
      abc = Scaffold(
          appBar: AppBar(
            title: Text('Sign In'),
          ),
          body: Center(
            child: Container(
                margin: EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: Image.asset('assets/googlesignin.png'),
                  onTap: () {
                    _signIn();
                  },
                )),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return abc;
  }
}
