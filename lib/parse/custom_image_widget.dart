import 'package:flutter/material.dart';

class CustomImageWidget extends StatelessWidget {
  String url;
  Map<String, String> attributes;

  CustomImageWidget(this.url, {this.attributes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30),
      height: 200,
      // color: Colors.grey,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(url,fit: BoxFit.contain,)),
    );
  }
}