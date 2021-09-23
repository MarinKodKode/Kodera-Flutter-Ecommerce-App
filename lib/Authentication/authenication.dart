import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.0,
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blue[900],Colors.blue[900]],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
          bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock, color: Colors.white),
                  text: "Iniciar sesión",
                ),
                Tab(
                  icon: Icon(Icons.perm_contact_cal_outlined, color: Colors.white),
                  text: "Registro",
                ),
              ],
            indicatorColor: Colors.white24,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blue[900],Colors.blue[900]],
              )
          ),
          child: TabBarView(
              children: [
                Login(),
                Register(),
              ]),
        ),
      ),
    );
  }
}
