import 'dart:convert';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Node.js Sample',
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}



class _MyWidgetState extends State<MyWidget> {
  List<dynamic> _data = [];

  Future<void> fetchData() async {


    
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/list'));

    print('Response body: ${response.body}');
    final jsonData = json.decode(response.body);
    setState(() {
      _data = jsonData;
    });
  }

  @override
  void initState() {
    super.initState();
    //fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) {
        final data = _data[index];
        return ListTile(
          title: Text(data['title']),
          subtitle: Text(data['body']),
        );
      },
    );
  }
}
