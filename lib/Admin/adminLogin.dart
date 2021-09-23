import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';



/*MainClass*/
class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          "Kodera.com",
          style: TextStyle(fontSize: 18.0, color: Colors.white,fontFamily: "Urbanist"),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}


/*Diseño principal de la interfaz de LoginAdmin*/
class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _adminIdTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width ,_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors:
              [ Colors.blue[900],
                Colors.blue[900]
              ],
              begin: Alignment.bottomCenter,
              end:   Alignment.topCenter,
              stops: [0.0,1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "images/admino.png",
                height: 230.0,
                width: 140.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Administrador",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Urbanist", fontSize: 16.0
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIdTextEditingController,
                    data: Icons.person,
                    hintText: "Token",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController ,
                    data: Icons.lock_open_outlined,
                    hintText: "Contraseña",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _adminIdTextEditingController.text.isNotEmpty
                    && _passwordTextEditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                    context: context,
                    builder: (c){
                      return ErrorAlertDialog(message: "Debes llenar todos los campos!",);
                    });
              },
              child: Text('Ingresar', style: TextStyle(fontFamily: "Urbanist", fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[900],
                  fixedSize: Size(140, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 1.0,
              width: _screenWidth * 0.8,
              color: Colors.white,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton.icon(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=>AuthenticScreen())),
              icon: (Icon(Icons.nature_people_outlined, color: Colors.white,)),
              label: Text("No soy administrador" , style: TextStyle(color: Colors.white, fontFamily: "Urbanist"),),
            ),
            SizedBox(
              height: 100.0,

            ),
          ],
        ),
      ),
    );
  }


  /*Vefica permisos para entrar como administrador*/
  loginAdmin(){
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) {
        if(result.data["id"] != _adminIdTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("El token es incorrecto"),));
        }
        else if(result.data["password"] != _passwordTextEditingController.text.trim()){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("La contraseña es incorrecta"),));
        }
        else{
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Bienvenido..." + result.data["name"]),));

          setState(() {
            _adminIdTextEditingController.text ="";
            _passwordTextEditingController.text="";
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
