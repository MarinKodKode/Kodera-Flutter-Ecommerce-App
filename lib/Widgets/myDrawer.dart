import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Container(
        color: Colors.blue[900],
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.blue[900],Colors.blue[900]],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp,
                  )
              ),
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    elevation: 8.0,
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Text(
                    EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                    style: TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: "Urbanist"),
                  ),
                  Text(
                    EcommerceApp.sharedPreferences.getString(EcommerceApp.userEmail),
                    style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "Urbanist"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.0,),
            Container(
              padding: EdgeInsets.only(top: 1.0),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.blue[900],Colors.blue[900]],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp,
                  )
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home,color: Colors.white,),
                    title: Text("Inicio", style: TextStyle(color: Colors.white, fontFamily: "Urbanist", fontSize: 18.0),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c)=>StoreHome());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.blue[900], thickness: 6.0,),

                  ListTile(
                    leading: Icon(Icons.reorder,color: Colors.white,),
                    title: Text("Mis pedidos", style: TextStyle(color: Colors.white, fontFamily: "Urbanist", fontSize: 18.0),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c)=>MyOrders());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.blue[900], thickness: 6.0,),

                  ListTile(
                    leading: Icon(Icons.shopping_cart_outlined,color: Colors.white,),
                    title: Text("Mi carrito", style: TextStyle(color: Colors.white, fontFamily: "Urbanist", fontSize: 18.0),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c)=>CartPage());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.blue[900], thickness: 6.0,),

                  ListTile(
                    leading: Icon(Icons.search,color: Colors.white,),
                    title: Text("Buscar", style: TextStyle(color: Colors.white, fontFamily: "Urbanist", fontSize: 18.0),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c)=>SearchProduct());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.blue[900], thickness: 6.0,),

                  ListTile(
                    leading: Icon(Icons.add_location_alt_outlined,color: Colors.white,),
                    title: Text("Direcciones", style: TextStyle(color: Colors.white, fontFamily: "Urbanist", fontSize: 18.0),),
                    onTap: (){
                      Route route = MaterialPageRoute(builder: (c)=>AddAddress());
                      Navigator.pushReplacement(context, route);
                    },
                  ),
                  Divider(height: 10.0, color: Colors.blue[900], thickness: 6.0,),

                  ListTile(
                    leading: Icon(Icons.exit_to_app_rounded,color: Colors.white,),
                    title: Text("Cerrar sesión", style: TextStyle(color: Colors.white, fontFamily: "Urbanist", fontSize: 18.0),),
                    onTap: (){
                      EcommerceApp.auth.signOut().then((c){
                        Route route = MaterialPageRoute(builder: (c)=>AuthenticScreen());
                        Navigator.pushReplacement(context, route);
                      });
                    },
                  ),
                  Divider(height: 10.0, color: Colors.blue[900], thickness: 6.0,),
                ],
              ),
            ),
          ],

        ),
      ),

    );
  }
}
