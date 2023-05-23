import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart';
import 'dart:io';

void main() async {
  //main99();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //title: 'Stock Data',
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final formatter = NumberFormat('#,###');
  EdgeInsets stdmargin =
      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);

  Future<Map<String, dynamic>>? _data;

  String marktprice = "";
  String inVestment = "";
  String profit = "";
  String marktpolarity = "";

  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  Map<String, dynamic> data2 = {
    'key1': '6758',
    'key2': '200',
    'key3': '1665',
    'key4': '6976',
    'key5': '100',
    'key6': '1801',
    'key7': '3436',
    'key8': '0',
    'key9': '0',
  };


Future _fetchStd() async {
  const url = 'https://finance.yahoo.co.jp/quote/6976.T';
  const backendUrl = 'http://localhost:3000'; // バックエンドのURL

  final uri = Uri.parse(backendUrl); // バックエンドのURLをURIオブジェクトに変換
  final response = await http.get(uri.replace(queryParameters: {'url': url}));
  if (response.statusCode == 200) {
    print(response.body); // レスポンスのボディを出力
  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}



  Future<Map<String, dynamic>> _fetchStockTv() async {
    // テレビ番組のスケジュールを取得するURLを設定します。
    //String url = 'https://www.tv-tokyo.co.jp/program/schedule/';
    //String url = 'https://www.nhk.or.jp/hensei/tv/schedule/all/';
    const url = 'http://localhost:3000/api/v1/tv'; //←ここに表示させたいURLを入力する

    // URLから応答を取得します。
    Response response = await http.get(Uri.parse(url).replace());
// テレビ番組のスケジュールを取得するURLを設定します。

    // 応答を解析して、各番組の出演者を取得します。
    Map<String, dynamic> programs =
        json.decode(response.body)['list'];

    // 出演者を画面に出力します。
    //for (var program in programs) {
      print('番組名：{program}');
      print('出演者：{program}');
    //}
    return programs;
  }

  Future<Map<String, dynamic>> _fetchStockData() async {
    const url = 'http://localhost:3000/api/v1/list'; //←ここに表示させたいURLを入力する
    final response =
        await http.get(Uri.parse(url).replace(queryParameters: data2));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return jsonData;
    } else {
      throw Exception('Failed to fetch stock data');
    }
  }

  @override
  void initState() {
    super.initState();
    //_data = _fetchStockData();
    //_data = _fetchStockTv();
    _fetchStd();
  }

  void _refreshData() {
    setState(() {
      print("_refreshData");
      _data = _fetchStockData();
    });
  }

  Container stackmarketView(stdstock) => Container(
    padding: const EdgeInsets.only(top:10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.grey.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 56, 50, 50),
      ),
      child: Row(children: [
        const Icon(
          Icons.trending_up,
          size: 60,
          color: Colors.grey,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: <Widget>[
              CircleAvatar(
                maxRadius: 5.0,
                backgroundColor: stdstock[0]['Polarity'] == 'true'
                    ? Colors.red
                    : Colors.green,
              ),
              const Text(
                "Dow Price: \$ ",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w900,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${stdstock[0]['Price']}',
                      style: const TextStyle(
                        fontSize: 15.0, //fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w900,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: <Widget>[
              const SizedBox(width: 10),
              const Text(
                "          The day before ratio: \$ ",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w900,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          '${stdstock[0]['Reshio'] + "   " + stdstock[0]["Percent"]}',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: stdstock[0]["Polarity"] == '+'
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(height: 10),

          Row(
            children: <Widget>[
              CircleAvatar(
                maxRadius: 5.0,
                backgroundColor:
                    stdstock[1]["Polarity"] == '+' ? Colors.red : Colors.green,
              ),
              const Text(
                "Nikkey Price: ￥ ",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w900,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${stdstock[1]["Price"]}',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w900,
                        color: Colors.blueAccent, //fontWeight: FontWeight.bold,
                      ),
                      //style: TextStyle(fontSize: 12.0,//fontWeight: FontWeight.bold,
                      //),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Row(children: <Widget>[
            const SizedBox(width: 10),
            const Text(
              "          The day before ratio: ￥ ",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w900,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${stdstock[1]["Reshio"] + "  " + stdstock[1]["Percent"]}',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: stdstock[1]["Polarity"] == '+'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ]),
      ]));

  Container stackAssetView(asset) => Container(
    padding: const EdgeInsets.only(top:5.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.grey.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 56, 50, 50),
      ),
      child: Row(children: [
        const Icon(
          Icons.currency_yen,
          size: 60,
          color: Colors.grey,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 5.0,
                  backgroundColor: asset[0]["Polarity"] == "+"
                      ? Colors.orange
                      : Colors.green, //Colors.green,
                ),
                const Text(
                  "Market price: ", //"Gain or loss",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${asset[0]["Market"]}',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: asset[0]["Polarity"] == "+"
                              ? Colors.orange
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                //Text("The day before ratio",
                //  style: TextStyle(fontSize: 10.0, color: Colors.white),
                //),
                const Text(
                  "Profit(Gains)", //"Gain or loss", //"Market price",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "￥",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      TextSpan(
                        text: '${asset[0]["Profit"]}',
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Investment",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "￥",
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      TextSpan(
                        text: '${asset[0]["Invest"]}',
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ]));

  ListView listView(dynamic anystock) => ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: anystock.length, //+20,//<-- setState()
      //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
              margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.grey.shade800,
                  ],
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(children: <Widget>[
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      fixedSize: const Size(50, 50),
                      backgroundColor: Colors.purple, //ボタンの背景色
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      //runCommand();
                      //_asyncEditDialog(context, index);
                    },
                    onLongPress: () {
                      //alertDialog(index);
                    },
                    child: Text("${anystock[index]['Code']}",
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
                        "${anystock[index]["Name"]}",
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
                          Text("Market: ${anystock[index]["Price"]}",
                              style: const TextStyle(
                                  fontFamily: 'NotoSansJP',
                                  fontSize: 17.0,
                                  color: Colors.blue),
                              textAlign: TextAlign.left),
                          Text(
                            "Benefits: ${anystock[index]["Banefits"]}",
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.yellow),
                          ),
                        ],
                      ),
                      Text(
                        "Evaluation: ${anystock[index]["Evaluation"]}",
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
                        backgroundColor: anystock[index]["Polarity"] == '+'
                            ? Colors.red
                            : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        anystock[index]["Reshio"],
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () => _refreshData(), //_opneUrl(),
                    ), // 右端のアイコン
                  ),
                ),
              ])),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text('Stock Data'),
      //),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _data, //  _fetchStockData(), //_futureStockData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            Map<String, dynamic> stockDataList = snapshot.data!;
            var stdstock = stockDataList["stdData"];
            var anystock = stockDataList["anyData"];
            var asset = stockDataList["assetData"];
            //anystock = stockDataList.sublist(2, stockDataList.length);
            return Stack(
              children: <Widget>[
                Container(
                  width: 650,
                  height: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      margin: stdmargin,
                      width: 500,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: stackmarketView(
                          stdstock), //marketView(asset), //listView(), //gridView1(),
                    ),
                    Container(
                      margin: stdmargin,
                      width: 500,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: stackAssetView(
                          asset), //marketView(asset), //listView(), //gridView1(),
                    ),
                    Container(
                      margin: stdmargin,
                      width: 500,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black,
                      ),
                      child: listView(anystock), //listView(), //gridView1(),
                    ),
                  ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
