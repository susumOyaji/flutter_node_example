import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main() {
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage> {
  String _responseText = '';

  Future<void> _fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000'));
    if (response.statusCode == 200) {
      setState(() {
        _responseText = response.body;
      });
    } else {
      setState(() {
        _responseText = 'Error: ${response.statusCode}';
      });
    }
  }

  Future<void> _fetchHtml() async {
    // 取得先のURLを元にして、Uriオブジェクトを生成する。
    final url = 'https://zenn.dev/';
    final target = Uri.parse(url);

    // 取得する。
    final response = await http.get(target);

    // 下の行のコメントを外すことで、返されたHTMLを出力できる。
    // print(response.body);

    // ステータスコードをチェックする。「200 OK」以外のときはその旨を表示して終了する。
    if (response.statusCode != 200) {
      print('ERROR: ${response.statusCode}');
      return;
    }

    // 取得したHTMLのボディをパースする。
    final document = parse(response.body);

    // 要素を絞り込んで、結果を文字列のリストで得る。
    final result = document.querySelectorAll('h2').map((v) => v.text).toList();

    // 結果を出力する。
    print(result);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  _responseText,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _fetchData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
