import 'package:flutter/material.dart';
import 'localhost.dart';

void main() => runApp(MyApp99());






class MyApp99 extends StatelessWidget {
  const MyApp99({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //画面右上の赤いバーナーを消す
      debugShowCheckedModeBanner: false,
      home: Stockcardweb(),
    );
  }
}

class Stockcardweb extends StatefulWidget {
  const Stockcardweb({Key? key}) : super(key: key);
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Stockcardweb> {



@override
  void initState() {
    super.initState();
    localhost();
    // ここで初期化処理を行う
    //runCommand();
   
  }









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
