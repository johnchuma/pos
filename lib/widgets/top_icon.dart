import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';

Widget topIcon({widget,backgroundColor,double? padding}){
  return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color:backgroundColor?? backgroundColor,
                
                height: 50,
                child: Padding(
                  padding:  EdgeInsets.all(padding??5),
                  child: widget,
                )),
            ),
          );
}