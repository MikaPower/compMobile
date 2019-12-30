import 'package:flutter/material.dart';

Widget avatarLeft(index){
  return new Text(index.toString(),
          textAlign: TextAlign.center,
          style:new TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontStyle: FontStyle.italic,
          )
  );
}