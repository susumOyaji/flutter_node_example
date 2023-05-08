import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Clipper.dart';

class StockData {
  final String code;
  final String name;
  final String price;
  final String reshio;
  final String percent;
  final String polarity;

  StockData({
    required this.code,
    required this.name,
    required this.price,
    required this.reshio,
    required this.percent,
    required this.polarity,
  });
}

class MyAppGPT extends StatelessWidget {
  const MyAppGPT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stock Data',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EdgeInsets std_margin =
      const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0);
  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  List<Map<String, dynamic,dynamic>> data1 = [
    {code: 6758, quantity: 200, price: 1665},
    {code: 6976, quantity: 300, price: 1801},
    {code: 3436, quantity: 0, price: 0}
  ];

  Future<List<StockData>>? _futureStockData;
  List anystock = [];
  List stdstock = [];

  Future<List<StockData>> _fetchStockData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/list'));

    const url = 'http://localhost:3000/api/v1/list'; //←ここに表示させたいURLを入力する
    final response1 =
        await http.get(Uri.parse(url).replace(queryParameters: data));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final stdData = jsonData['stdData'];
      final anyData = jsonData['anyData'];

      final stockDataList = <StockData>[];

      for (final data in stdData) {
        final stockData = StockData(
          code: data['Code'],
          name: data['Name'],
          price: data['Price'],
          reshio: data['Reshio'],
          percent: data['Percent'],
          polarity: data['Polarity'],
        );

        stockDataList.add(stockData);
      }

      for (final data in anyData) {
        final stockData = StockData(
          code: data['Code'],
          name: data['Name'],
          price: data['Price'],
          reshio: data['Reshio'],
          percent: data['Percent'],
          polarity: data['Polarity'],
        );

        stockDataList.add(stockData);
      }

      return stockDataList;
    } else {
      throw Exception('Failed to fetch stock data');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureStockData = _fetchStockData();
  }

  void _refreshData() {
    setState(() {
      print("_refreshData");
      _futureStockData = _fetchStockData();
    });
  }

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
                    child: Text("${anystock[index].code}",
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
                        "${anystock[index].name}",
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
                          Text("Market: ${anystock[index].price}",
                              style: const TextStyle(
                                  fontFamily: 'NotoSansJP',
                                  fontSize: 17.0,
                                  color: Colors.blue),
                              textAlign: TextAlign.left),
                          Text(
                            "Benefits: {anystock[index].banefits}",
                            style: const TextStyle(
                                fontFamily: 'NoteSansJP',
                                //fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.yellow),
                          ),
                        ],
                      ),
                      Text(
                        "Evaluation: {anystock[index].evaluation}",
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
                        backgroundColor: anystock[index].polarity == '+'
                            ? Colors.red
                            : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        anystock[index].reshio,
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
      appBar: AppBar(
        title: const Text('Stock Data'),
      ),
      body: Center(
        child: FutureBuilder<List<StockData>>(
          future: _futureStockData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            final stockDataList = snapshot.data!;
            stdstock = stockDataList.sublist(0, 2);
            anystock = stockDataList.sublist(2, stockDataList.length);
            return Stack(
              children: <Widget>[
                Container(
                  width: 750,
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
                      margin: std_margin,
                      width: 700,
                      height: 250,
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

/*
            ListView.builder(
              itemCount: anystock.length,
              itemBuilder: (context, index) {
                final stockData = anystock[index];

                return ListTile(
                  title: Text(stockData.name),
                  subtitle: Text(stockData.code),
                  trailing: Text(stockData.price),
                );
              },
            );
            */
          },
        ),
      ),
    );
  }
}
