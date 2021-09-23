import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{

  //Variables globales del registro de un usuario nuevo
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUri = "";
  File _imageFile;


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width ,_screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 40.0,),
            InkWell(
              onTap: () => _selectImage(),
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white12,
                backgroundImage: _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                  ? Icon(Icons.perm_media_outlined, size: _screenWidth * 0.15,color: Colors.blue,)
                    : null,
              ),
            ),
            SizedBox(height: 8.0,),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameTextEditingController ,
                      data: Icons.person,
                      hintText: "Nombre",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _emailTextEditingController ,
                      data: Icons.email_outlined,
                      hintText: "Correo",
                      isObsecure: false,
                    ),
                    CustomTextField(
                      controller: _passwordTextEditingController ,
                      data: Icons.lock_open_outlined,
                      hintText: "Contraseña",
                      isObsecure: true,
                    ),
                    CustomTextField(
                      controller: _cPasswordTextEditingController ,
                      data: Icons.lock_open_outlined,
                      hintText: "Confirmar contraseña",
                      isObsecure: true,
                    ),
                  ],
                ),
            ),
            ElevatedButton(
              onPressed: () { uploadUserImage(); },
              child: Text('Crear cuenta', style: TextStyle(fontFamily: "Urbanist", fontWeight: FontWeight.bold, color: Colors.white),),
              style: ElevatedButton.styleFrom(
                  primary: Colors.yellow[900],
                  fixedSize: Size(140, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 1.0,
              width: _screenWidth * 0.8,
              color: Colors.white,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  /*Abrir galeria local y seleccionar imagen de usuario*/
  Future<void> _selectImage() async{
    _imageFile =  await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadUserImage() async{
    /*Verificar que exista una imagen de perfil elegida*/
    if(_imageFile == null){
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: "Selecciona una imagen de perfil",);
          });
    }
    /*Verificar que el formulario este lleno y que las contraseñas coincidan*/
    else{
      _passwordTextEditingController.text == _cPasswordTextEditingController.text
          ? _emailTextEditingController.text.isNotEmpty
          && _passwordTextEditingController.text.isNotEmpty
          && _cPasswordTextEditingController.text.isNotEmpty
          &&  _nameTextEditingController.text.isNotEmpty

          ? uploadToStorage()

          : displayDialog("Debes llenar todos los campos!")

          :displayDialog("Las contraseñas deben coincidir!");
    }
  }

  uploadToStorage() async{
    showDialog(
        context: context,
        builder: (c){
          return LoadingAlertDialog(message: "Verificando tu cuenta...",);
        });

    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();

    StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;

    await storageTaskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUri = urlImage;

      _registerUser();
    });
  }

  /*Guardar los datos del usuario en la Firebase*/
  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async{
    FirebaseUser firebaseUser;

    await _auth.createUserWithEmailAndPassword(
        email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
    ).then((auth){
      firebaseUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: error.message.toString(),);
          });
    });

    if(firebaseUser != null){
      saveUserInformation(firebaseUser).then((value){
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  /*Guardar los datos del usuario en la firebase*/
  Future saveUserInformation(FirebaseUser firebaseUser) async{
      Firestore.instance.collection("users").document(firebaseUser.uid).setData({
        "uid": firebaseUser.uid,
        "email" : firebaseUser.email,
        "name" : _nameTextEditingController.text.trim(),
        "url" : userImageUri,
        EcommerceApp.userCartList : ["garbageValue"],
      });
      
      await EcommerceApp.sharedPreferences.setString("uid", firebaseUser.uid);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, firebaseUser.email);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUri);
      await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }


  /*AlertDialog*/
  displayDialog(String msg){
    showDialog(
        context: context,
        builder: (c){
          return ErrorAlertDialog(message: msg,);
        });
  }
}

