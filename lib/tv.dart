import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
//import 'dart:convert';
import 'dart:io';
//import 'package:http/http.dart' as http;
import 'localhost.dart';

void main() {
  runApp(MyAppTv());
}

class MyAppTv extends StatefulWidget {
  const MyAppTv({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppTv> {
  List<dynamic> _programs = [];
  List<String> _keywords = ['HiHi Jets'];

  @override
  void initState() {
    super.initState();
    //localhost();
    locasever();
    //_fetchPrograms();
    //fetchData();
    _getData();
  }

  Future<void> _fetchPrograms() async {
    //final String url = 'https://tv.yahoo.co.jp/api/programs/v3/search';
    //final String url = 'https://tv.yahoo.co.jp/search?q=HiHiJets';
    final String appId = 'your_app_id'; // 自分のアプリIDに置き換える
    final List<String> fields = [
      'id',
      'title',
      'episode',
      'start_time',
      'end_time',
      'channel',
      'description',
      'genres'
    ];
    final String searchWords = _keywords.join(' OR ');

    var url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
    var response = await http.get(url);

    //final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _programs = data['channels'][0]['programs'];
      });
    } else {
      throw Exception('Failed to fetch programs');
    }
  }

  Future<void> fetchData() async {
    final url = Uri.parse('https://example.com/data.json');

    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    });

    //final response = await http.get(url, headers: {
    //  'Access-Control-Allow-Origin': '*', // CORS 対応
    //});

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> _getData() async {
    final url = "https://example.com/data"; // リクエスト先の URL
    final response = await http.get(Uri.parse(url));

    // レスポンスヘッダーに Access-Control-Allow-Origin が設定されているか確認する
    if (response.headers.containsKey("Access-Control-Allow-Origin")) {
      final data = json.decode(response.body);
      print(data);
    } else {
      print("CORS Error: Access-Control-Allow-Origin is not set");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TV Scheduled appearances'),
        ),
        body: ListView.builder(
          itemCount: _programs.length,
          itemBuilder: (BuildContext context, int index) {
            final program = _programs[index];
            return ListTile(
              title: Text(program['title']),
              subtitle: Text(program['description']),
              trailing: Text(program['start_time']),
            );
          },
        ),
      ),
    );
  }
}
