import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tour_app/auth/firebase_authentication.dart';
import 'package:tour_app/pages/home_page.dart';
class LoginPage extends StatefulWidget {
  static final routName= '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}





class _LoginPageState extends State<LoginPage> {
  FirebaseAuthenticationService authenticationService;
  final _formKey=GlobalKey<FormState>();

  String email;
  String password;
  bool isLogin=true;
  String errMsg='';
  String uid;
  @override
  void initState() {
    authenticationService=FirebaseAuthenticationService();
    super.initState();
  }
  void _authenticate() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
          if(isLogin){
        uid= await authenticationService.login(email, password);
          }
          else{
            uid= await authenticationService.register(email, password);
          }
          if(uid !=null){
            Navigator.pushReplacementNamed(context, HomePage.routName);
          }
      } catch(error){
        setState(() {
          errMsg=error.message;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Name',
                      border: OutlineInputBorder()
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'This Field is not must be Empty';
                      }
                      else {
                        return null;
                      }


                    },
                    onSaved: (value){
                      email=value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Password must not be Empty';
                      }
                      else{
                        return null;
                      }
                    },
                    onSaved: (value){
                      password=value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Text('Sign Up ',style: TextStyle(color: Colors.black),),
                      onPressed: (){
                          setState(() {
                            isLogin=false;
                          });

                          _authenticate();
                      },
                      ),

                      RaisedButton(
                        child: Text('Sign In ',style: TextStyle(color: Colors.amber),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                        onPressed:
                          _authenticate,

                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(errMsg,style: TextStyle(fontSize: 20.0,color: Colors.red),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
