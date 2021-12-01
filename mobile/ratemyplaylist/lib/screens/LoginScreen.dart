import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ratemyplaylist/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:ratemyplaylist/utils/reuse.dart';
import 'package:ratemyplaylist/screens/MainScreen.dart';

final page = MainScreen();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    home: container:
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in.'),
        backgroundColor: RMPBlack,
        automaticallyImplyLeading: false,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: RMPGreen,
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),

      backgroundColor: RMPBlack,

      body: Center(
          child: Column(
            children: [
              LoginForm(),
            ],
          ),
       ),
      );
   }
 }

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();
  Future<User>? _futureUser;

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("built");
    return Container(
        width: MediaQuery.of(context).size.width * .95,
        margin: const EdgeInsets.only(top: 200.0),
        padding: const EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          color: RMPBlack,
        ),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  cursorColor: RMPGreen,
                  controller: userController,
                  style: TextStyle(color: RMPGreen),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: RMPGreen, width: 5.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: RMPGreen, width: 5.0),
                    ),
                      fillColor: RMPBlack,
                      labelText: 'Username',
                      filled: true,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: RMPGreen,
                      ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can not be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  cursorColor: RMPGreen,
                  controller: passController,
                  obscureText: true,
                  style: TextStyle(color: RMPGreen),
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: RMPGreen, width: 2.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: RMPGreen, width: 2.0),
                    ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: RMPGreen,
                      ),
                      filled: true,
                      fillColor: RMPBlack,
                      labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field can not be empty';
                    }
                    return null;
                  },
                ),
                Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: RMPGreen,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _futureUser = loginUser(
                                userController.text, passController.text);
                          });
                        } else {
                          print(_formKey.currentState!.validate());
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: RMPBlack, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    )),
                Container(
                  child: (_futureUser == null) ? null : userFutureBuilder(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Need an account?",
                        style: TextStyle(color: RMPWhite, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      child: Text(
                        " Register",
                        style: TextStyle(color: RMPGreen),
                      ),
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.REGISTERSCREEN),
                    )
                  ],
                ),
              ],
            )));
  }

  Future<User> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Err');
    }
  }

  FutureBuilder<User> userFutureBuilder() {
    return FutureBuilder<User>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.error != null) {
            if (snapshot.data!.error == '') {
              user = new User(
                  id: snapshot.data!.id,
                  name: snapshot.data!.name,
                  email: snapshot.data!.email,
                  token: snapshot.data!.token,
                  error: snapshot.data!.error,
                  spotifyUserID: snapshot.data!.spotifyUserID);
              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                Navigator.push(context,MaterialPageRoute(builder: (context) => page));
              });
            } else {
              print('Err');
              return Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text("${snapshot.data!.error}", style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center),
              );
            }
          }
          return const CircularProgressIndicator();
        });
  }
}
