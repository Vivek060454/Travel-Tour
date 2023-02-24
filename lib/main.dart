import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'list.dart';
import 'login.dart';
import 'mapoi.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //await NotificationService.initialize();
  runApp( MyApp());}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.white,
        errorColor: Colors.red,
        colorScheme: ThemeData().colorScheme.copyWith(primary:  Color.fromRGBO(246, 99, 9, 100),),
      ),
      initialRoute:'home',
      routes: {
        'home': (context)=>Home(),
        'drawer':(context)=>Draweer(),





      },

    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}
class SplashScreenState extends State<MyHomePage> {
  final _auth =FirebaseAuth.instance;
  final storage=new FlutterSecureStorage();
  Future<bool>checkLogin()async{
    String? value = await storage.read(key: "uid") ;
    if(value==null){
      return false;
    }
    return true;
  }
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
          () =>
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
                  FutureBuilder(
                    future: checkLogin(),
                    builder:(BuildContext context,AsyncSnapshot<bool> snapshot){
                      if(snapshot.data==false){
                        return Login();
                      }
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Draweer();
                    } ,
                  )
              )
          ),
// if (_auth==null)
//             {
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder:
//                     (context) =>  Login(),
//
//                 )
//             );}
// else{
//   Navigator.pushReplacement(context,
//       MaterialPageRoute(builder:
//       (context) =>  Draweer()));
// }

    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 100, top: 100, right: 100,),
      decoration: const BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/Frame Tritan.jpg'), fit: BoxFit.cover,

          )
      ),
    );

  }
}
