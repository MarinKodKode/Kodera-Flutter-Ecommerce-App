import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName  = TextEditingController();
  final cPhoneNumber  = TextEditingController();
  final cHomeNumber  = TextEditingController();
  final cCity  = TextEditingController();
  final cState  = TextEditingController();
  final cCountry  = TextEditingController();
  final cPinCode  = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              if(formKey.currentState.validate()){
                final model = AddressModel(
                  name: cName.text.trim(),
                  state: cState.text.trim(),
                  pincode: cPinCode.text,
                  phoneNumber: cPhoneNumber.text,
                  flatNumber: cHomeNumber.text,
                  city: cCity.text.trim(),
                ).toJson();
                
                //add to Firestore
                EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                    .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                    .collection(EcommerceApp.subCollectionAddress)
                    .document(DateTime.now().toString())
                    .setData(model)
                    .then((value){
                         final snack = SnackBar(content: Text("Dirección añadida"));
                         scaffoldKey.currentState.showSnackBar(snack);
                         FocusScope.of(context).requestFocus(FocusNode());
                         formKey.currentState.reset();
                });

                Route route = MaterialPageRoute(builder: (c)=>StoreHome());
                Navigator.pushReplacement(context, route);
              }
            },
            label: Text("Hecho"),
            backgroundColor: Colors.green,
            icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Añadii dirección",style: TextStyle(color: Colors.white12, fontWeight: FontWeight.bold,fontSize: 20.0),),
                ),
              ),
              Form(
                  key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Nombre",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Teléfono",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Domicilio",
                      controller: cHomeNumber,
                    ),
                    MyTextField(
                      hint: "Ciudad",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "Estado | País",
                      controller: cCountry,
                    ),
                    MyTextField(
                      hint: "Código postal",
                      controller: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//TextField personalizado
class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val)=>val.isEmpty ? "No puede haber espacios vacios." : null,
      ),
    );
  }
}
