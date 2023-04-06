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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static List<List<dynamic>> data = [
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
              var data1 = snapshot.data;
              //final jsonData = json.decode(snapshot.data);
              final stdstock = data1['stdstock'];
              final anystock = data1['anystock'];
              //print(data['stdstock'][1]);

              return ListView(
                children: [
                  ListView.builder(
                    itemCount: stdstock.length,
                    itemBuilder: (BuildContext context, int index) {
                      // 初期値の設定
                      return ListTile(
                        title: Text(stdstock[index]['Code']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stdstock[index]['Name']),
                            Text(stdstock[index]['Price']),
                            Text(stdstock[index]['Reshio']),
                            Text(stdstock[index]['Percent']),
                            //Text(_getFormattedDate('1,000.00')),
                          ],
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: anystock.length,
                    itemBuilder: (BuildContext context, int index) {
                      // 初期値の設定
                      return ListTile(
                        title: Text(anystock[index]['Code']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(anystock[index]['Name']),
                            Text(anystock[index]['Price']),
                            Text(anystock[index]['Reshio']),
                            Text(anystock[index]['Percent']),
                            //Text(_getFormattedDate('1,000.00')),
                          ],
                        ),
                      );
                    },
                  ),
                ],
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

  Future fetch() async {
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
    /*
    jsonArray = jsonDecode(response.body);

    for (int i = 0; i < jsonArray.length; i++) {
      print(jsonArray[i]['Code']);
      print(jsonArray[i]['Name']);
      print(jsonArray[i]['Price']);
      print(jsonArray[i]['Reshio']);
      print(jsonArray[i]['Percent']);
      print(jsonArray[i]['Polarity']);
    }
    */
    //setState(() {
    //  _responseText = jsonArray;
    //});
    //} catch (e) {
    //レスポンスがない場合の処理
    //setState(() {
    //  print('Server unresponsive: $e');
    //});
  }

  _getFormattedDate(String price) {
    String dotnumber = price.replaceAll(',', '');
    String removedString = dotnumber.substring(0, dotnumber.length - 3);

    int int_price = int.parse(removedString);
    //String number = dotnumber.replaceAll('.', '');

    //int numprice = int.parse(number); // カンマを取り除いて int に変換
    print(int_price); // 4500
    //int integerprice = numprice.toInt(); // 3
    //print(integerprice); // 4500
    int quantity = 3; // 数量
    int total = int_price * quantity; // 掛け算
    print(total); // 4500
    return total.toString();
  }

  //return jsonArray;
}
