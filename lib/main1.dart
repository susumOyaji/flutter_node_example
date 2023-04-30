import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp1());
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  
  Future fetchData() async {
    //localhost:3000/api/v1/listにGETリクエストを送信し、レスポンスを待ちます。
    //レスポンスが受信されると、response変数に代入されます。

    final response = await http.get(Uri.parse('http://localhost:3000/users'));
    //await http.get(Uri.parse('http://192.168.2.111:3000/endpoint'));//192.168.2.111.3000
    //await http.get(Uri.parse('https://api.cashless.go.jp'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<String> fetchList() async {
    var response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/list'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: fetchData(),
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
            final stdstock = res[0]['id'];
            final anystock = res[0]['message'];
            final totalUnitprice = res[0]['name'];
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
