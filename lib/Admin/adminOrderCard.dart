import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderDetails.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';


int counter=0;
class AdminOrderCard extends StatelessWidget
{

  final int itemCount;
  final List<DocumentSnapshot>data;
  final String orderID;
  final String addressID;
  final String orderBy;

  AdminOrderCard({Key key, this.itemCount, this.data, this.addressID, this.orderID, this.orderBy}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return  InkWell(
      onTap: (){
        Route route;
        if(counter == 0){
          counter = counter + 1;
          route = MaterialPageRoute(builder: (c) => AdminOrderDetails(orderID: orderID, orderBy: orderBy, addressID: addressID));
        }
        Navigator.push(context, route);
      },
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0),
                blurRadius: 6.0,
              ),
            ],
            gradient: new LinearGradient(
              colors:
              [ Colors.grey[200],
                Colors.grey[200]
              ],
              begin: Alignment.bottomCenter,
              end:   Alignment.topCenter,
            )
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index){
            ItemModel model = ItemModel.fromJson(data[index].data);
            /*Trae la información del pedido del archivo ordeCart.dart*/
            return sourceOrderInfo(model, context);
          },
        ),
      ),
    );
  }
}

