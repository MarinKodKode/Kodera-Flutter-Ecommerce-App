import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0),
                blurRadius: 6.0,
              ),
            ],
            gradient: new LinearGradient(
              colors:
              [ Colors.blue[900],
                Colors.blue[900]
              ],
              begin: Alignment.bottomCenter,
              end:   Alignment.topCenter,
            )
        ),
      ),
      centerTitle: true,
      title: Text(
        "Kodera.com",
        style: TextStyle(fontSize: 18.0, color: Colors.white,fontFamily: "Urbanist",fontWeight: FontWeight.w500),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                },
                icon: Icon(Icons.shopping_basket_outlined, color: Colors.white,)
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.white,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    left: 6.0,
                    child: Consumer<CartItemCounter>(
                      builder: (context,counter, _){
                        return Text(
                          (EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length-1).toString(),
                          style: TextStyle(color: Colors.blueAccent, fontSize: 12.0, fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
