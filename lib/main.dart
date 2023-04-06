import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Data'),
        ),
        body: Center(
          child: FutureBuilder(
            future: fetch(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var res = snapshot.data;
              //final jsonData = json.decode(snapshot.data.toString());
              final stdstock = res['stdstock'];
              final anystock = res['anystock'];
              return ListView(
                children: [
                  
                  const ListTile(
                    title: Text('stdstock'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stdstock.length,
                    itemBuilder: (BuildContext context, int index) {
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
                  
                  const ListTile(
                    title: Text('anystock'),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: anystock.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(anystock[index]['Code']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(anystock[index]['Name']),
                              Text(anystock[index]['Price']),
                              Text(anystock[index]['Reshio']),
                              Text(anystock[index]['Percent']),
                            ],
                          ));
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
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
}
