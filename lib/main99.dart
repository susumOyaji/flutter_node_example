import 'package:flutter/material.dart';

void main() => runApp(MyApp99());

class MyApp99 extends StatelessWidget {
  const MyApp99({Key? key}) : super(key: key);
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stack Demo',
      home: 
      Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Stack Demo'),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              // Red box
              Container(
                height: 200,
                width: 200,
                color: Colors.red,
              ),
              // Blue box
              Positioned(
                top: 50,
                left: 50,
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                ),
              ),
              // Text
              const Positioned(
                top: 75,
                left: 75,
                child: Text(
                  'Hello, Flutter!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
