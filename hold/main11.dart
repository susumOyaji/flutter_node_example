import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp11());
}

class MyApp11 extends StatelessWidget {
  const MyApp11({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //画面右上の赤いバーナーを消す
      debugShowCheckedModeBanner: false,
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
  late List<dynamic> _data;
  bool _isLoading = false;
  List stdstock = [];
  List anystock = [];
  int MarketCap = 0;

  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        _data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetch() async {
    setState(() {
      _isLoading = true;
    });

    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する

    //try {
    final response = await http.get(Uri.parse(url).replace(queryParameters: {
      'data': jsonEncode(data),
    }));

    if (response.statusCode == 200) {
      // データを取得できた場合
      var data = json.decode(response.body);
      setState(() {
        stdstock = data['stdstock'];
        anystock = data['anystock'];
      });

      //return json.decode(response.body);
    } else {
      // エラーが発生した場合
      throw Exception('Failed to load data');
    }
  }

  _getFormattedDate(String price, int Shares) {
    String dotnumber = price != "---" ? price.replaceAll(',', '') : "---";

    int int_price = dotnumber != "---" ? int.parse(dotnumber) : 000;

    print(int_price); // 4500

    int total = int_price * Shares; // 掛け算
    //setState(() {
    //MarketCap = MarketCap + total;
    //});

    //print(MarketCap); // 4500
    return total.toString();
  }

  @override
  void initState() {
    super.initState();
    fetch();
    //fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading Indicator Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: stdstock.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(stdstock[index]['Name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stdstock[index]['Name']),
                      Text(stdstock[index]['Price']),
                      Text(stdstock[index]['Reshio']),
                      Text(stdstock[index]['Percent']),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: anystock.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(anystock[index]['Name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(anystock[index]['Name']),
                        Text(anystock[index]['Price']),
                        Text(anystock[index]['Reshio']),
                        Text(anystock[index]['Percent']),
                        Text(_getFormattedDate(
                            anystock[index]['Price'], data[index][1])),
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //fetchData();
          fetch();
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
