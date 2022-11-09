import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String label;
  final String label2;
  final String route;

  const Labels({super.key, required this.route, required this.label, required this.label2});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
          SizedBox(height: 10),
          GestureDetector(
            child: Text(label2, style: TextStyle( color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.pushReplacementNamed(context, route);
            },
          )
        ],
      ),
    );
  }
}