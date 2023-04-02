import 'dart:math';

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
  List<String> codeItems = []; //codekey
  static List<bool> percentcheng = [];

  final List<List<dynamic>> data = [
    ["6758", 1665, 200],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  EdgeInsets std_margin =
      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);

  void fetch() async {
    //final String json;
    List<dynamic> jsonArray = [];
    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する

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

      setState(() {
        _responseText = jsonArray;
      });
    } catch (e) {
      //レスポンスがない場合の処理
      setState(() {
        print('Server unresponsive: $e');
      });
    }
    //return jsonArray;
  }

  //List<dynamic> myList = await fetch();

  //Widget build(BuildContext context) async {
  //List<dynamic> dataList =  await fetch(); // fetch() の結果を待機して、List<dynamic> 型の変数に代入する
  // dataList を使用したコード
//}

  @override
  void initState() {
    super.initState();
    fetch();
    //while(_responseText.isEmpty){
    //  fetch();
    //}
  }

  //////
  ListView listView() => ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length, //+20,//<-- setState()
      //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    //Color(0xffb43af7),
                    //Color(0x0B52067),
                    //Color(0xff6d2af7),
                    Colors.black,
                    Colors.grey.shade800,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.max,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    // children:<Widget>[
                    Expanded(
                      flex: 2,
                      child:
                          //Padding(
                          //  padding: EdgeInsets.only(top: 0.0, right: 0.0, bottom: 0.0, left: 0.0),

                          //child:
                          ElevatedButton(
                        child: Text("${_responseText[index]["Code"]}",
                            //style: TextStyle(
                              //fontSize: 10.0,
                              //color: Colors.black,
                             // fontFamily: 'NotoSansJP',
                            //)
                            ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple, //ボタンの背景色
                          shape: const CircleBorder(),
                        ),
                        onPressed: () {
                          //_asyncEditDialog(context, index);
                        },
                        onLongPress: () {
                          //alertDialog(index);
                        },
                      ),
                    ),

                    //  ]
                    // ),

                    //SizedBox(width: 15.0,),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_responseText[index]['Name']}",
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              fontFamily: 'NoteSansJP',
                              fontWeight: FontWeight.bold,
                            ),
                            strutStyle: const StrutStyle(
                              fontSize: 10.0,
                              height: 1.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Market: ${_responseText[index]['Price']}",
                                  style: const TextStyle(
                                      fontFamily: 'NotoSansJP',
                                      fontSize: 12.0,
                                      color: Colors.blue),
                                  textAlign: TextAlign.left),
                              Text(
                                "Benefits: ${_responseText[index]['Price']}",
                                style: const TextStyle(
                                    fontFamily: 'NoteSansJP',
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.yellow),
                              ),
                            ],
                          ),
                          const Text(
                            "Evaluation: {separation(int.parse(valuableAssetsItems[index]))}", //$$$$
                            style: TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(width: 50.0,),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 0.0, bottom: 0.0, left: 0.0),
                        //child: //SizedBox(
                        //height: 30.0,
                        //width: 60.0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0.0),
                            primary: Colors.orange,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                            ),
                            backgroundColor: _responseText[index]['Plaryt']
                                ? Colors.red
                                : Colors.green,
                          ),
                          child: Text(
                            _responseText[index]['Percent'] //signalstate[index]
                                ? '{changePriceRate[index]}%' //$$$
                                : '{changePriceValue[index]}', //$$$
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black),
                          ),
                          onPressed: () => setState(() {
                            percentcheng[index] = !percentcheng[index];
                          }),
                        ),
                        //),
                      ),
                    ),
                  ])),
        );
      });

  ///Main Display Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Container(
          width: 600,
          height: 700,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
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
                width: 550,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 56, 50, 50),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 60,
                      color: Colors.grey,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center, //左右位置
                      children: [
                        Wrap(
                          spacing: 8.0, //Wrap内アイテムの間隔
                          children: [
                            CircleAvatar(
                              maxRadius: 8.0,
                              backgroundColor:
                                  _responseText[0]['Polarity'] == "+"
                                      ? Colors.red
                                      : Colors.green,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Dow Price:  \$',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: _responseText[0]['Price'],
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          //spacing: 5.0,
                          children: [
                            const SizedBox(width: 50), //////
                            Text.rich(
                              TextSpan(
                                text: 'The day brfore ratio:  ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: _responseText[0]['Reshio'] +
                                        "   " +
                                        _responseText[0]['Percent'],
                                    style: TextStyle(
                                        color: (_responseText[1]['Polarity'] ==
                                                "+")
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: [
                            CircleAvatar(
                              maxRadius: 8.0,
                              backgroundColor:
                                  _responseText[1]['Polarity'] == "+"
                                      ? Colors.red
                                      : Colors.green,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Nikkei Price:  \¥',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: _responseText[1]['Price'],
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'The day brfore ratio:  ',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: _responseText[1]['Reshio'] +
                                    "   " +
                                    _responseText[1]['Percent'],
                                style: TextStyle(
                                    color: (_responseText[1]['Polarity'] == "+")
                                        ? Colors.red
                                        : Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                margin: std_margin,
                width: 550,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 56, 50, 50),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_yen,
                      //Icons.attach_money,
                      size: 60,
                      color: Colors.grey,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: 'Market capitalization',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              maxRadius: 8.0,
                              backgroundColor:
                                  _responseText[1]['Polarity'] == "+"
                                      ? Colors.orange
                                      : Colors.blue,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Market Price:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: _responseText[1]['Price'],
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Profit(Gains):  \¥' +
                                _responseText[1]['Price'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: '   Investment:  \¥' +
                                    _responseText[1]['Reshio'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                child: listView(), //gridView1(),
              ),
              ElevatedButton(
                child: const Text('UrlOpen'),
                onPressed: () => fetch(), //_opneUrl(),
              ),

              //),
              Text(_responseText[0]['Code']),
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
