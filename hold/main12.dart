import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp12());
}

class MyApp12 extends StatelessWidget {
  const MyApp12({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //画面右上の赤いバーナーを消す
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}



class Data {
  final String name;

  Data({required this.name});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['Name'],
    );
  }
}


class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<Data> _data;

   static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];




  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<Data> fetchData() async {
     const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する

    //try {
    final response = await http.get(Uri.parse(url).replace(queryParameters: {
      'data': jsonEncode(data),
    }));

    //final response = await http.get(Uri.parse('http://localhost:3000'));
    if (response.statusCode == 200) {
      return Data.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Data>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // データがまだ取得されていない場合の表示
        return const CircularProgressIndicator();
      },
    );
  }

  void _refreshData() {
    setState(() {
      _data = fetchData();
    });
  }
}
