import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c)=>CartItemCounter()),
          ChangeNotifierProvider(create: (c)=>ItemQuantity()),
          ChangeNotifierProvider(create: (c)=>AddressChanger()),
          ChangeNotifierProvider(create: (c)=>TotalAmount()),
        ],
        child : MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.blue[900],
            ),
            home: SplashScreen()
        ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    displaySplash();
  }


  displaySplash(){
    /*Durante la ejecución del SplashScreen, de manera asincrona verificamos si ya existe una sesión inciada
    * dependiendo del resultado dirigimos al usuario al panel de inicio o al Login*/
    Timer(Duration(seconds: 3), () async{
      if(await EcommerceApp.auth.currentUser() != null){
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      }else{
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }



  /*Diseño del widget principal del splashScreen*/
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors:
                [ Colors.blue[900],
                  Colors.blue[900]
                ],
              begin: Alignment.bottomCenter,
              end:   Alignment.topCenter,
             /* stops: [0.0,1.0],
              tileMode: TileMode.clamp,*/
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/k.png",width: 200.0, height: 200.0,),
              SizedBox(height: 1.0, width: 1.0,),
              Text(
                "Kodera",
                style: TextStyle(color: Colors.white, fontSize: 20.0,fontFamily: "Urbanist"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
