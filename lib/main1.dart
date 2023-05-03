import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

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
  late Future _data;
  //int MarketCap = 0;
  bool _isLoading = false;
  String _message = '';

  static var returndata;

  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  Future<List<dynamic>> fetchData() async {
    //localhost:3000/api/v1/listにGETリクエストを送信し、レスポンスを待ちます。
    //レスポンスが受信されると、response変数に代入されます。

    var response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/list'));
    //await http.get(Uri.parse('http://192.168.2.111:3000/endpoint'));//192.168.2.111.3000
    //await http.get(Uri.parse('https://api.cashless.go.jp'));

    if (response.statusCode == 200) {
      //return json.decode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future fetchList() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/list'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future makeRequest() async {
    
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/v1/list'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        // OK
        var res = json.decode(response.body);
        print(res);
        return res;
      } else if (response.statusCode == 404) {
        // Not Found
        print('404 Not Found');
        return [];
      } else {
        // エラーの場合はその他のステータスコードが返される
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }


Future fetch() async {
     setState(() {
      _isLoading = true;
      _message = 'Loading data...';
    });

    const url = 'http://localhost:3000/api/v1/list'; //←ここに表示させたいURLを入力する

    try {
      final response = await http.get(Uri.parse(url).replace(queryParameters: {
        'data': jsonEncode(data),
      }));
      print(response.statusCode);
      setState(() {
        _isLoading = true;
        _message = 'Loading data...';
      });
      return json.decode(response.body);
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: fetch(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //else if (snapshot.hasError) {
            //  return Center(
            //    child: Text('${snapshot.error}'),
            //  );
            //}
            var res = snapshot.data;
            //final jsonData = json.decode(snapshot.data.toString());
            final stdstock = res?[0]['Code'];
            final anystock = res?[0]['message'];
            final totalUnitprice = res?[0]['name'];
            //final totalmarketcap = res['totalmarketcap'];
            //final totalGain = res['totalGain'];
            //final totalPolarity = res['totalpolarity'];

            return Container(
                child: Column(
              children: [
                Text(stdstock.toString()),
                Text(anystock),
                Text(totalUnitprice),
              ],
            ));
          },
        ),
      ),
    );
  }
}
