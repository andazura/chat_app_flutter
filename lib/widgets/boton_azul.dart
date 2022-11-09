import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  
  final void Function() onPress;
  final String textButton;

  const BotonAzul({ required this.onPress, required this.textButton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(2),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all(StadiumBorder())
            ),
            onPressed: onPress,
            child: Container(
              width: double.infinity,
              height: 55,
              child: Center(
                child: Text(textButton, style:  TextStyle( color: Colors.white, fontSize: 17),),
              ),
            ),
    );
  }
}

