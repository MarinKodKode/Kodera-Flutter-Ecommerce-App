import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Store/Search.dart';


class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent
      ) =>
      InkWell(
        onTap: (){
          Route route = MaterialPageRoute(builder: (c)=>SearchProduct());
          Navigator.pushReplacement(context, route);
        },
        child: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors:
                [ Colors.blue[500],
                  Colors.blue[800]
                ],
                begin: Alignment.bottomCenter,
                end:   Alignment.topCenter,
              )
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 80.0,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 10.0,right: 10.0 ),
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 14.0),
                      child: Icon(
                          Icons.search,
                        color: Colors.blue[800],
                      ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text("Buscar en Kodera.com", style: TextStyle(fontFamily: "Urbanist", fontWeight: FontWeight.w400),),
                  ),
                ],
              ),
            ),
          ),
        ),
      );



  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}


