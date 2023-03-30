import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:html';
import 'dart:convert';
import 'Clipper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //画面右上の赤いバーナーを消す
      debugShowCheckedModeBanner: false,
      home: UrlLaunchePage(),
    );
  }
}

class UrlLaunchePage extends StatefulWidget {
  //const UrlLaunchePage({Key? key});

  @override
  UrlLaunchePageFul createState() => UrlLaunchePageFul();
}

class UrlLaunchePageFul extends State<UrlLaunchePage> {
  List<dynamic> _responseText = [];
  var response = [];

  EdgeInsets std_margin =
      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);




  Future<List<dynamic>> fetch() async {
    //final String json;
    List<dynamic> jsonArray = [];
    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する

    final List<List<dynamic>> data = [
      ["6758", 1665, 200],
      ["6976", 300, 1801],
      ["3436", 0, 0],
    ];

    try {
      final response = await http.get(Uri.parse(url).replace(queryParameters: {
        'data': jsonEncode(data),
      }));

      //json = response.body;

      jsonArray = jsonDecode(response.body);

      for (int i = 0; i < jsonArray.length; i++) {
        print(jsonArray[i]['Code']);
        print(jsonArray[i]['Name']);
        print(jsonArray[i]['Price']);
        print(jsonArray[i]['Reshio']);
        print(jsonArray[i]['Percent']);
        print(jsonArray[i]['Polarity']);
      }

      //setState(() {
      //  _responseText = jsonArray;
      //});
    } catch (e) {
      // レスポンスがない場合の処理
      //setState(() {
      print('Server unresponsive: $e');
      //});
    }
    return jsonArray;
  }

  @override
  void initState() {
    super.initState();
    //_opneUrl();
    //List<dynamic> data = fetch();

    //response = fetch();
    //print(response);
    //window.open('http://localhost:3000'.toString(), '_top');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: 
        Container(
          width: 600,
          height: 700,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.orange,
          ),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: ClipPath(
                      clipper: MyCustomClipper(),
                      child: Container(
                          //margin: std_margin,
                          padding: const EdgeInsets.only(
                              top: 0.0, left: 20.0, right: 0.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.grey.shade800,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Stocks",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),

              Container(
                margin: std_margin,
                width: 450,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '^DJI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 0.8,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      'Nikkei',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 0.8,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Container(
                margin: std_margin,
                width: 450,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Flutter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 0.8,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      'Web',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 0.8,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Container(
                margin: std_margin,
                width: 450,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                child: const Text('UrlOpen'),
                onPressed: () => fetch(), //_opneUrl(),
              ),

              //),
              const Text("{_responseText[0]['Code']}"),
            ],
          ),
        ),
      ),
    );
  }
}
/*
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Url Launcher'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            //Center(
            ElevatedButton(
              child: const Text('UrlOpen'),
              onPressed: () => fetch(), //_opneUrl(),
            ),

            //),
            Text(_responseText),
          ],
        )));
  }
  */
//}
