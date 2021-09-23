import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Store/product_page.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/Config/config.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors:
                  [ Colors.blue[800],
                    Colors.blue[800]
                  ],/*
                  begin: Alignment.bottomCenter,
                  end:   Alignment.topCenter,
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,*/
                )
            ),
          ),
          title: Text(
            "Kodera.com",
            style: TextStyle(fontSize: 18.0, color: Colors.white,fontFamily: "Urbanist"),
          ),
          centerTitle: true,
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
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true,delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("items")
                    .limit(15)
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, dataSnapshot){
                  return !dataSnapshot.hasData 
                      ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                      :SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 1,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context,index){
                        ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
                        return sourceInfo(model, context);
                      },
                      itemCount: dataSnapshot.data.documents.length,
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}



Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: (){
      Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel:model));
      Navigator.pushReplacement(context, route);
    },
    splashColor: Colors.blueAccent,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(model.thumbnailUrl, width: 125.0, height: 130.0,),
            SizedBox(width: 10.0,),
            Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.0,),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(model.title, style: TextStyle(color: Colors.black, fontSize: 14.0,),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(model.shortInfo, style: TextStyle(color: Colors.black54, fontSize: 12.0,),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.red[700],
                            ),
                            alignment: Alignment.topLeft,
                            width: 40.0,
                            height: 43.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "50%", style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "OFF", style: TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Column(
                            crossAxisAlignment:  CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"Precio original: $ ",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      (model.price + model.price).toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Nuevo precio: ",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      r"$ ",
                                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                                    ),
                                    Text(
                                      (model.price).toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ],
                      ),

                      Flexible(
                        child: Container(),
                      ),

                      //to implement the cart item add/remove
                      Align(
                        alignment: Alignment.centerRight,
                        child: removeCartFunction == null
                        ? IconButton(
                            icon: Icon(Icons.add_shopping_cart_outlined, color: Colors.yellow[800],),
                          onPressed: (){
                              checkItemInCart(model.shortInfo, context);
                          },
                        )
                        :IconButton(
                          onPressed: () {
                            removeCartFunction();
                            Route route = MaterialPageRoute(builder: (c)=>StoreHome());
                            Navigator.pushReplacement(context, route);
                          },
                            icon: Icon(Icons.delete_outline, color: Colors.red[900],),

                        ),
                      ),
                      Divider(
                        height: 5.0,
                        color: Colors.blueGrey,
                      )
                    ],
                  ),
            ),
          ],
        ),
      ),
    ),
  );
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width *.34,
    margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(offset: Offset(0,5), blurRadius: 10.0, color: Colors.grey[200]),
      ]
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      child: Image.network(
        imgPath,
        height: 150.0,
        width: width * .34,
        fit: BoxFit.fill,
      ),
    ),
  );
}



void checkItemInCart(String shortInfoAsId, BuildContext context)
{
  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).contains(shortInfoAsId)
      ? Fluttertoast.showToast(msg: "Ya añadiste este prodcuto")
      : addItemToCart(shortInfoAsId,context);
}

addItemToCart(String shortInfoAsId, BuildContext context){
  List tempCartList =  EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  tempCartList.add(shortInfoAsId);

  EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({
        EcommerceApp.userCartList : tempCartList,
      }).then((v){
        Fluttertoast.showToast(msg: "Producto añadido, con éxito");
        EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, tempCartList);
        
        Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });

}
