import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main11.dart';

void main() {
  runApp(const MyApp11());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //画面右上の赤いバーナーを消す
      debugShowCheckedModeBanner: false,
      home: Stockcardweb(),
    );
  }
}

class Stockcardweb extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Stockcardweb> {
  int  MarketCap=0;

  static List<List<dynamic>> data = [
    ["6758", 200, 1665],
    ["6976", 300, 1801],
    ["3436", 0, 0],
  ];

  @override
  void initState() {
    super.initState();
    // ここで初期化処理を行う
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
  }

  _getFormattedDate(String price, int Shares) {
    String dotnumber = price != "---" ? price.replaceAll(',', '') : "---";
    //String removedString = dotnumber.substring(0, dotnumber.length - 3);

    int int_price = dotnumber != "---" ? int.parse(dotnumber) : 000;

    print(int_price); // 4500
    //int integerprice = numprice.toInt(); // 3
    //print(integerprice); // 4500

    int total = int_price * Shares; // 掛け算

    MarketCap = MarketCap+total ;

    print(MarketCap); // 4500
    return total.toString();
  }

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
                                Text(_getFormattedDate(
                                    anystock[index]['Price'], data[index][1])),
                              ],
                            ));
                      },
                    ),
                      ListTile(
                      title: Text(MarketCap.toString()),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
