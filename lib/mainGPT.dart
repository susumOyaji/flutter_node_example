import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StockData {
  final String code;
  final String name;
  final String price;
  final String reshio;
  final String percent;
  final String polarity;

  StockData({
    required this.code,
    required this.name,
    required this.price,
    required this.reshio,
    required this.percent,
    required this.polarity,
  });
}

class MyAppGPT extends StatelessWidget {
  const MyAppGPT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stock Data',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<StockData>>? _futureStockData;

  Future<List<StockData>> _fetchStockData() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/v1/list'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      final stdData = jsonData['stdData'];
      final anyData = jsonData['anyData'];

      final stockDataList = <StockData>[];

      for (final data in stdData) {
        final stockData = StockData(
          code: data['Code'],
          name: data['Name'],
          price: data['Price'],
          reshio: data['Reshio'],
          percent: data['Percent'],
          polarity: data['Polarity'],
        );

        stockDataList.add(stockData);
      }

      for (final data in anyData) {
        final stockData = StockData(
          code: data['Code'],
          name: data['Name'],
          price: data['Price'],
          reshio: data['Reshio'],
          percent: data['Percent'],
          polarity: data['Polarity'],
        );

        stockDataList.add(stockData);
      }

      return stockDataList;
    } else {
      throw Exception('Failed to fetch stock data');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureStockData = _fetchStockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Data'),
      ),
      body: Center(
        child: FutureBuilder<List<StockData>>(
          future: _futureStockData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stockDataList = snapshot.data!;

              return ListView.builder(
                itemCount: stockDataList.length,
                itemBuilder: (context, index) {
                  final stockData = stockDataList[index];

                  return ListTile(
                    title: Text(stockData.name),
                    subtitle: Text(stockData.code),
                    trailing: Text(stockData.price),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
