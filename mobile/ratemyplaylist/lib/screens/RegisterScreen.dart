import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ratemyplaylist/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:ratemyplaylist/utils/reuse.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register.'),
          backgroundColor: RMPGreen,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: RMPBlack,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      backgroundColor: RMPGreen,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(),
              RegisterForm(),
            ],
          ),
        ),
      )
    );
  }
}

class RegisterForm extends StatefulWidget{
  const RegisterForm({Key? key}) : super(key:key);
  @override
  _RegisterFormState createState() {
    return _RegisterFormState();
  }
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();
  final passControllerCheck = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  
  Future<Registration>? _futureRegistration;

  @override
  void dispose(){
    userController.dispose();
    passController.dispose();
    passControllerCheck.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width *.95,
      margin: const EdgeInsets.only(top: 50.0),
      padding: const EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
        color: RMPGreen,
        border: Border.all(
          color: Colors.transparent,
          width: 0.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: userController,

              cursorColor: RMPBlack,
              style: TextStyle(color: RMPBlack),

              decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: RMPBlack, width: 6.0),
                     ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: RMPBlack, width: 6.0),
                      ),

                fillColor: RMPGreen,
                labelText: 'Username',
                filled: true,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: RMPBlack,
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty){
                  return 'This field can not be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: nameController,
              cursorColor: RMPBlack,
              style: TextStyle(color: RMPBlack),

              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 6.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 6.0),
                ),

                fillColor: RMPGreen,
                labelText: 'Name',
                filled: true,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: RMPBlack,
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty){
                  return 'This field can not be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              cursorColor: RMPBlack,
              style: TextStyle(color: RMPBlack),

              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 6.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 6.0),
                ),

                fillColor: RMPGreen,
                labelText: 'Email',
                filled: true,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: RMPBlack,
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty){
                  return 'This field can not be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passController,
              obscureText: true,
              cursorColor: RMPBlack,
              style: TextStyle(color: RMPBlack),

              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 6.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 6.0),
                ),

                fillColor: RMPGreen,
                labelText: 'Password',
                filled: true,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: RMPBlack,
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty){
                  return 'This field can not be empty';
                }
                return null;
              },
            ),
            TextFormField(
              controller: passControllerCheck,
              obscureText: true,

              cursorColor: RMPBlack,
              style: TextStyle(color: RMPBlack),

              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 3.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: RMPBlack, width: 3.0),
                ),

                fillColor: RMPGreen,
                labelText: 'Confirm Password',
                filled: true,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: RMPBlack,
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty){
                  return 'This field can not be empty';
                }
                if(value != passController.text){
                  return 'Your passwords must match';
                }
                return null;
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom:10.0),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: RMPBlack,
                ),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      _futureRegistration = registerUser(userController.text, passController.text, nameController.text, emailController.text);        
                    });
                  } else {
                    print(_formKey.currentState!.validate());
                  }
                },
                child: const Text('Register', style: TextStyle(color: RMPGreen, fontWeight: FontWeight.bold, fontSize: 14),),
              )
            ),
            Container(
              child: (_futureRegistration == null) ? null : registrationFutureBuilder(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?", style: TextStyle(color: RMPWhite, fontWeight: FontWeight.bold),),
                InkWell(
                  child: Text(" Login", style: TextStyle(color: RMPBlack),),
                  onTap:() => Navigator.pushNamed(context, Routes.LOGINSCREEN),
                )
              ],
            ),
          ],
        )
      )
    );
  }

  FutureBuilder<Registration> registrationFutureBuilder(){
    return FutureBuilder<Registration>(
      future: _futureRegistration,
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data!.error == ""){
          return Container(
            margin: EdgeInsets.only(bottom:10.0),
            child:Text(snapshot.data!.msg),
          );
        }else if (snapshot.hasData){
          return Container(
            margin: EdgeInsets.only(bottom:10.0),
            child:Text(snapshot.data!.error),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<Registration> registerUser(String username, String password, String name, String email) async{
    final response = await http.post(
      Uri.parse('https://ratemyplaylist0.herokuapp.com/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'name': name,
        'email': email,
      }),
    );
    if(response.statusCode == 200){
      return Registration.fromJson(jsonDecode(response.body));
    }else{
      throw Exception('Err');
    }
  }
}

class Registration{
  final String error;
  final String msg;

  Registration({
    required this.error,
    required this.msg,
    });

  factory Registration.fromJson(Map<String, dynamic> json){
    return Registration(
      error:json['error'], 
      msg: json['msg'],
    );
  }

}
