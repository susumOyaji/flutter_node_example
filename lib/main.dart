import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Clipper.dart';
import 'dart:io';
import 'dart:async';

void main() async {
  //main99();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
 // dynamic _data;
  late Future _data;
  //int MarketCap = 0;
  bool _isLoading = false;
  String _message = '';

  EdgeInsets std_margin =
      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);

  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  @override
  void initState() {
    super.initState();

    // ここで初期化処理を行う
    //runCommand();
    //_data = getData();
    _data = fetch();
  }

  void _refreshData() {
    setState(() {
      print("_refreshData");
      //_data = makeRequest();
      //_data = getData();
      _data = fetch();
    });
  }

  void runCommand() async {
    var result = await Process.run('node', ['Node/index.js']);
    print(result.stdout);
  }

  Future<dynamic> getData() async {
    //final response = await http.get(Uri.parse('https://raw.githubusercontent.com/dev-yakuza/users/master/api.json'));
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/user'));
    if (response.statusCode == 200) {
      final dataget = json.decode(response.body);
      print(dataget);
      //_data= data;
      return dataget;
    } else {
      print('Failed to fetch data. Error code: ${response.statusCode}');
    }
  }

  Future  fetch() async {
    //final String json;
    //List<dynamic> jsonArray = [];

    setState(() {
      _isLoading = true;
      _message = 'Loading data...';
    });

    const url = 'http://localhost:3000/api/v1/list'; //←ここに表示させたいURLを入力する

    try {
      final response = await http.get(Uri.parse(url).replace(queryParameters: {
        'data': jsonEncode(data),
      }));
      setState(() {
        _isLoading = true;
        _message = 'Loading data...';
      });
      return json.decode(response.body);
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _message = 'Failed to load data.';
      });
    }

    //if (response.statusCode == 200) {
    // データを取得できた場合

    //  return json.decode(response.body);
    //} else {
    // エラーが発生した場合
    //throw Exception('Failed to load data');
    //}
  }

  ListView listViewsample(dynamic anystock) => ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: (data.length), // リストの要素数
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 56, 50, 50),
            borderRadius: BorderRadius.circular(10.0),
          ),

          //alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          padding: const EdgeInsets.all(5.0),

          child: ListTile(
            leading: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                //padding: const EdgeInsets.all(0.0),
                fixedSize: const Size(50, 50),
                backgroundColor: Colors.purple,
                //primary: Colors.purple, //ボタンの背景色
                shape: const CircleBorder(),
              ),
              onPressed: () {
                //_asyncEditDialog(context, index);
              },
              onLongPress: () {
                //alertDialog(index);
              },
              child: Text("${anystock[index]["Code"]}",
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    // fontFamily: 'NotoSansJP',
                  )),
            ),

            title: Text(anystock[index]['Name'],
                style: const TextStyle(color: Colors.grey)), // タイトル
            //contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 8.0),
            subtitle: Column(
              children: [
                Wrap(
                  spacing: 8.0, //Wrap内アイテムの間隔
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Market price:  ¥${anystock[index]['Price']}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '   Benefits:  ¥${anystock[index]['Banefits']}',
                            style: const TextStyle(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Evaluation:  ¥',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: anystock[index]["Evaluation"],
                            style: const TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // サブタイトル
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 50),
                backgroundColor: anystock[index]['Polarity'] == '+'
                    ? Colors.red
                    : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                anystock[index]['Reshio'],
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () => _refreshData(), //_opneUrl(),
            ), // 右端のアイコン

            onTap: () {
              // リストアイテムがタップされたときの処理
              print('タップされたアイテム: $index');
              print(anystock[index]['Reshio']);
            },
          ),
        );
      });

  //////
  ListView listView(dynamic anystock) => ListView.builder(
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
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
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
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(50, 50),
                          backgroundColor: Colors.purple, //ボタンの背景色
                          shape: const CircleBorder(),
                        ),
                        onPressed: () {
                          runCommand();
                          //_asyncEditDialog(context, index);
                        },
                        onLongPress: () {
                          //alertDialog(index);
                        },
                        child: Text("${anystock[index]["Code"]}",
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontFamily: 'NotoSansJP',
                            )),
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
                            "${anystock[index]['Name']}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                              //fontFamily: 'NoteSansJP',
                              //fontWeight: FontWeight.bold,
                            ),
                            strutStyle: const StrutStyle(
                              fontSize: 10.0,
                              height: 1.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Market: ${anystock[index]['Price']}",
                                  style: const TextStyle(
                                      fontFamily: 'NotoSansJP',
                                      fontSize: 17.0,
                                      color: Colors.blue),
                                  textAlign: TextAlign.left),
                              Text(
                                "Benefits: ${anystock[index]['Banefits']}",
                                style: const TextStyle(
                                    fontFamily: 'NoteSansJP',
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    color: Colors.yellow),
                              ),
                            ],
                          ),
                          Text(
                            "Evaluation: ${anystock[index]['Evaluation']}",
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 17.0,
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 50),
                            backgroundColor: anystock[index]['Polarity'] == '+'
                                ? Colors.red
                                : Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            anystock[index]['Reshio'],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () => _refreshData(), //_opneUrl(),
                        ), // 右端のアイコン
                      ),
                    ),
                  ])),
        );
      });

  ///Main Display Screen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Stack Demo',
        home: Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: FutureBuilder(
                  future: _data,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var res = snapshot.data;
                    //final Map<String, dynamic> res = jsonDecode(snapshot.data!.body);
                    //final res = json.decode(snapshot.data.toString());
                    final stdstock = res["stdData"];
                    final anystock = res['anyData'];
                    final totalUnitprice = res['anyData'];
                    final totalmarketcap = res['anyData'];
                    final totalGain = res['anyData'];
                    //final totalPolarity = res[0]['Polarity'];
                    //child:
                    return Stack(
                      children: <Widget>[
                        Container(
                          width: 600,
                          height: 600,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
                          ),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    child: ClipPath(
                                      clipper: MyCustomClipper(),
                                      child: Container(
                                          //margin: std_margin,
                                          width: 550,
                                          height: 60,
                                          //margin: std_margin,
                                          padding: const EdgeInsets.only(
                                              top: 0.0,
                                              left: 20.0,
                                              right: 0.0,
                                              bottom: 10.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.grey.shade800,
                                              ],
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Stocks      $_message   $_isLoading",
                                                    style: const TextStyle(
                                                      fontSize: 30.0,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                padding: const EdgeInsets.only(top: 10.0),
                                width: 550,
                                height: 90,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, //左右位置
                                      children: [
                                        Wrap(
                                          spacing: 8.0, //Wrap内アイテムの間隔
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 8.0,
                                              backgroundColor:
                                                  stdstock[0]['Polarity'] == "+"
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
                                                    text: stdstock[0]['Price'],
                                                    style: const TextStyle(
                                                        color: Colors.blue),
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
                                                    text: stdstock[0]
                                                            ['Reshio'] +
                                                        "   " +
                                                        stdstock[0]['Percent'],
                                                    style: TextStyle(
                                                        color: stdstock[0][
                                                                    'Polarity'] ==
                                                                "+"
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
                                                  stdstock[1]['Polarity'] == "+"
                                                      ? Colors.red
                                                      : Colors.green,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Nikkei Price:  ¥',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: stdstock[1]['Price'],
                                                    style: const TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          children: [
                                            const SizedBox(width: 50),
                                            Text.rich(
                                              TextSpan(
                                                text: 'The day brfore ratio:  ',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: stdstock[1]
                                                            ['Reshio'] +
                                                        "   " +
                                                        stdstock[1]['Percent'],
                                                    style: TextStyle(
                                                        color: (stdstock[1][
                                                                    'Polarity'] ==
                                                                "+")
                                                            ? Colors.red
                                                            : Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
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
                                  gradient: LinearGradient(
                                    colors: [
                                      //Color(0xffb43af7),
                                      //Color(0x0B52067),
                                      //Color(0xff6d2af7),
                                      Colors.black,
                                      Colors.grey.shade800,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 56, 50, 50),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 8.0,
                                              backgroundColor:
                                                  stdstock[0]["Polarity"] == "+"
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
                                                    text: totalmarketcap,
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
                                            text: 'Profit(Gains):  ¥$totalGain',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '   Investment:  ¥$totalUnitprice',
                                                style: const TextStyle(
                                                    color: Colors.white),
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
                                width: 600,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black,
                                ),
                                child: listView(
                                    anystock), //listView(), //gridView1(),
                              ),

                              //),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20.0,
                          top: 23.0,
                          child: ClipOval(
                            child: Material(
                              color: Colors.orange, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: const SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(Icons.autorenew)),
                                onTap: () {
                                  _refreshData();
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 25.0,
                          top: 180.0,
                          child: IconButton(
                            icon: const Icon(Icons.grain),
                            color: Colors.blueGrey,
                            iconSize: 50,
                            onPressed: () {
                              // _asyncInputDialog(context);
                            },
                          ),
                        ),
                      ],
                    );
                    //);
                  },
                ))));
  }
}
