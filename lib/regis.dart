import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapt/usermodel.dart';


import 'login.dart';

class Regis extends StatefulWidget {
  const Regis({Key? key}) : super(key: key);
  @override
  State<Regis> createState() => _RegisState();
}
class _RegisState extends State<Regis> {
  bool value=false;
  final _formKey =GlobalKey<FormState>();
  final TextEditingController emailEController = new TextEditingController();

  final TextEditingController phoneEController = new TextEditingController();
  final TextEditingController passwordEController = new TextEditingController();
  final TextEditingController checkController = new TextEditingController();
  final TextEditingController cpasswordEController = new TextEditingController();
  final _auth =FirebaseAuth.instance;
  void register(String email ,String password)  async{

    if(_formKey.currentState!.validate()){
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) => {
        postDetailsToFirestore()
      }).catchError((e)
      {
        Fluttertoast.showToast(msg: e!.message);
      }
      );

    }
  }

  postDetailsToFirestore()async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user =_auth.currentUser;
    UserModel userModel=UserModel(eamil: null,phone: null);
    userModel.email=user !.email;
    userModel.uid=user .uid;
    userModel.phone=phoneEController.text;



    await firebaseFirestore
        .collection('usersell')
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created:)");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Login()), (route) => false);

  }


  @override
  Widget build(BuildContext context) {

    final emailEFeild= TextFormField(
      autofocus: false,
      controller: emailEController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value){
        emailEController.text=value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )

      ),
      validator: (value){
        if(value==null||value.isEmpty)
        {
          return "Enter your email";
        }
        return null;
      },



    );
    final phoneEFeild= TextFormField(
      autofocus: false,
      controller: phoneEController,
      keyboardType: TextInputType.phone,
      onSaved: (value){
        phoneEController.text=value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.call),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
      validator: (value){
        if(value==null||value.isEmpty)
        {
          return "Enter your phone number";
        }
        if(value.length>10||value.length<10)
        {
          return "Enter your valid phone number";
        }

        return null;
      },

    );
    final passwordEFeild= TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordEController,
      onSaved: (value){
        passwordEController.text=value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
      validator: (value){
        if(value==null||value.isEmpty)
        {
          return "Enter your password";
        }
        return null;
      },

    );
    final cpasswordEFeild= TextFormField(
      autofocus: false,
      obscureText: true,
      controller: cpasswordEController,
      onSaved: (value){
        cpasswordEController.text=value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
      validator: (value){
        if(cpasswordEController.text.length>6 && passwordEController.text!=value){
          return ("password not match");
        }
        return null;
      },
    );
    final signup =Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
          if(value==true) {
            register(emailEController.text, passwordEController.text);
          }
          else{
            Fluttertoast.showToast(msg: "Agree Terms and Condition");
          }
        },
        child: const Text('Sign Up',textAlign: TextAlign.center,style: const TextStyle(fontSize: 20),),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 156,
                        width: 150,
                        child: Image.asset("assets/Tritan-removebg-preview (1).png")),
                    const SizedBox(
                      height: 16,
                    ),
                    emailEFeild,
                    const SizedBox(
                      height: 30,
                    ),
                    phoneEFeild,
                    const SizedBox(
                      height: 30,
                    ),
                    passwordEFeild,
                    const SizedBox(
                      height: 30,
                    ),
                    cpasswordEFeild,
                    const SizedBox(
                      height: 30,
                    ),
                    signup,
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Color.fromARGB(255,0 , 18, 50),
                          value: value,
                          onChanged: (value) => setState(() {
                            this.value = value!;
                          }),
                        ),
                        Row(
                          children: [
                            Text('I agree to the'),
                            TextButton(
                              onPressed: () {
                                //  Navigator.push(context, MaterialPageRoute(
                                //   builder: (context) =>Terms()));
                              }, child: Text( 'Terms & Condition',style:TextStyle(color: Colors.blue),),
                            ),
                          ],
                        )
                      ],
                    ),
                    //Checkbox
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}
