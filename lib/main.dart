//以下は、FlutterのCircularProgressIndicatorとFutureBuilderウィジェットを使用して、非同期処理中にローディングインジケータを表示するサンプルコードです。
//この例では、ボタンをタップするとAPIからデータを取得し、取得したデータを表示する処理を行います。
//FutureBuilderは非同期処理の完了を待ち、処理が完了したら取得したデータを表示するようにします。

//この例では、_isLoadingというフラグを使用して、APIからデータを取得中かどうかを示しています。
//_isLoadingがtrueの場合は、ローディングインジケータを表示します。
//_isLoadingがfalseの場合は、取得したデータを表示するためにFutureBuilderを使用します。

//また、floatingActionButtonにRefreshボタンを配置し、ボタンをタップするとAPIからデータを再取得して、取得したデータを表示します。

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FutureBuilder Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter FutureBuilder Demo'),
        ),
        body: FutureBuilder(
          future: fetch(), //fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // データがある場合
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return 
                  
                  
                  
                  
                  
                  ListTile(
                    title: Text(snapshot.data[index]['Code']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data[index]['Name']),
                        Text(snapshot.data[index]['Price']),
                        Text(snapshot.data[index]['Reshio']),
                        Text(snapshot.data[index]['Percent']),
                      ],
                    ),
                  );
                },
              );
              
            } else if (snapshot.hasError) {
              // エラーがある場合
              return Text("${snapshot.error}");
            }
            // データがまだない場合
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // 非同期処理でデータを取得する関数
  Future<List<dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      // データを取得できた場合
      return json.decode(response.body);
    } else {
      // エラーが発生した場合
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> fetch() async {
    //final String json;
    List<dynamic> jsonArray = [];
    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する

    //try {
    final response = await http.get(Uri.parse(url).replace(queryParameters: {
      'data': jsonEncode(data),
    }));

    if (response.statusCode == 200) {
      // データを取得できた場合
      return json.decode(response.body);
    } else {
      // エラーが発生した場合
      throw Exception('Failed to load data');
    }

    //json = response.body;

    jsonArray = jsonDecode(response.body);

    for (int i = 0; i < jsonArray.length; i++) {
      print(jsonArray[i]['Code']);
      print(jsonArray[i]['Name']);
      print(jsonArray[i]['Price']);
      print(jsonArray[i]['Reshio']);
      print(jsonArray[i]['Percent']);
      print(jsonArray[i]['Polarity']);
    }

    //setState(() {
    //  _responseText = jsonArray;
    //});
    //} catch (e) {
    //レスポンスがない場合の処理
    //setState(() {
    //  print('Server unresponsive: $e');
    //});
  }
  //return jsonArray;
}
