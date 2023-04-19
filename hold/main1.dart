import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, dynamic>> fetchData() async {
    //localhost:3000/api/v1/listにGETリクエストを送信し、レスポンスを待ちます。
    //レスポンスが受信されると、response変数に代入されます。
   
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/list'));
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Text(snapshot.data?['message']),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
