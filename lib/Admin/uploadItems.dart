import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen(){
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
        leading: IconButton(
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
              Navigator.pushReplacement(context, route);
            },
            icon: Icon(
              Icons.shop_two_outlined,
              color: Colors.white,
            ),
        ),
        actions: [
          TextButton(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
              child:
              Text("Cerrar sesión",
                style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "urbanist"),
              ),
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody(){
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.blue[900],Colors.blue[900]],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          )
      ),
      child: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Icon(Icons.shop_two_outlined, color: Colors.white, size: 200.0,),
           Padding(
               padding: EdgeInsets.only(top: 20.0),
               child: ElevatedButton(
                 onPressed: () => pickImage(context),
                 child: Text('Añadir articulos',style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontFamily: "Urbanist"),),
                 style: ElevatedButton.styleFrom(
                     primary: Colors.white,
                     fixedSize: Size(250, 50),
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(50))),
               ),
             ),
         ],
       ),
      ),
    );
  }

  displayAdminUploadFormScreen(){
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
        leading: IconButton(
            onPressed: clearFormInfo,
            icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("Nuevo producto", style: TextStyle(color: Colors.white,fontSize: 18.0, fontFamily: "Urbanist", fontWeight: FontWeight.bold),),
        actions: [
          ElevatedButton(
            onPressed: uploading ? null :  ()=> uploadImageSaveItemInfo(),
              child: Text("Añadir" , style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: "Urbanist"),),
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(image: DecorationImage(image: FileImage(file),fit: BoxFit.cover)),
                  ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top:12.0)),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blueAccent,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.brown),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "| Palabras clave | ",
                  hintStyle: TextStyle(color: Colors.blueAccent, fontFamily: "urbanist"),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black54,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blueAccent,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.brown),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Articulo",
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black54,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blueAccent,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.brown),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Cuentanos sobre el producto.",
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black54,),

          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.blueAccent,),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.brown),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Precio",
                  hintStyle: TextStyle(color: Colors.blueAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black54,)
        ],
      ),
    );
  }

  uploadImageSaveItemInfo() async{
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUri = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUri;
  }

  saveItemInfo(String downloadUrl){
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "shortInfo" : _shortInfoTextEditingController.text.trim(),
      "longDescription" : _descriptionTextEditingController.text.trim(),
      "price" : int.parse(_priceTextEditingController.text),
      "publishedDate" : DateTime.now(),
      "status" : "available",
      "thumbnailUrl" : downloadUrl,
      "title" : _titleTextEditingController.text.trim(),
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }

  clearFormInfo(){
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  pickImage(mContext){
    return showDialog(
        context: mContext,
        builder: (com){
          return SimpleDialog(
             title: Text("Imagen", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                child: Text("Tomar una foto",style: TextStyle(color: Colors.blueAccent,),),
                onPressed: captureWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Seleccionar foto",style: TextStyle(color: Colors.blueAccent,),),
                onPressed: pickFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancelar",style: TextStyle(color: Colors.blueAccent,),),
                onPressed: (){Navigator.pop(context);},
              ),
            ],
          );
        });
  }

  captureWithCamera() async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  pickFromGallery() async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imageFile;
    });
  }
}
