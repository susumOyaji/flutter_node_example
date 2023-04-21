import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<String> _keywords = ['ジャニーズ', '嵐', '関ジャニ∞'];

  @override
  void initState() {
    super.initState();
    _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    //final String url = 'https://tv.yahoo.co.jp/api/programs/v3/search';
    final String url = 'https://tv.yahoo.co.jp/search?q=';
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

    final response = await http
        .get(Uri.parse('$url?fields=${fields.join(',')}&q=$searchWords'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _programs = data['channels'][0]['programs'];
      });
    } else {
      throw Exception('Failed to fetch programs');
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
