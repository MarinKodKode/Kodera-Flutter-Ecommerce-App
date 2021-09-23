import 'package:flutter/material.dart';

/*TextField reusable en para el registro y el inicio de sesion*/

class CustomTextField extends StatelessWidget
{
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;


  /*Constructor*/
  CustomTextField(
      {Key key, this.controller, this.data, this.hintText,this.isObsecure}
      ) : super(key: key);



  @override
  Widget build(BuildContext context)
  {
    return Container
    (
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(60.0))
      ) ,
      padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 10.0, right: 10.0),
      margin: EdgeInsets.only(top: 10.0, left: 35.0,right: 35.0,bottom: 10.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: "Urbanist", color: Colors.black45)
        ),
      ),
    );
  }
}
