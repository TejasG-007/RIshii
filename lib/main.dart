import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pockettouristguide/HomeScreen/Home.dart';
import 'package:pockettouristguide/Service/Authentication.dart';
import 'package:provider/provider.dart';
import 'LoginScreens/LoginModel.dart';
import 'LoginScreens/LoginView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>Handler()),
      ChangeNotifierProvider(create: (_)=>Authentication(),),

    ],child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        accentColor: Colors.teal,
        textTheme: TextTheme(
            headline1: TextStyle(color:Colors.black,fontSize: 35,fontFamily: "Nunito"),
            headline2: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color:Colors.black,fontFamily: "Body")
        )
      ),
          home:StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (builder,snapshot){
              if(snapshot.hasData){
                  return Home();
              }else{
                  return LoginView();
              }
            },
          ),
        ),);
  }
}
