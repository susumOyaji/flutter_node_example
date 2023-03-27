import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //画面右上の赤いバーナーを消す
      debugShowCheckedModeBanner: false,
      home: UrlLaunchePage(),
    );
  }
}

class UrlLaunchePage extends StatefulWidget {
  @override
  UrlLaunchePageFul createState() => UrlLaunchePageFul();
}

class UrlLaunchePageFul extends State<UrlLaunchePage> {
  void _opneUrl() async {
    const url = 'http://localhost:3000'; //←ここに表示させたいURLを入力する

    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      );
    } else {
      throw 'このURLにはアクセスできません';
    }
  }

  void _openHtml() async {
    final url = 'http://localhost:3000';

    final request = await HttpRequest.request(
      url,
      method: 'GET',
      responseType: 'json',
    );

    final responseJson = request.response as Map<String, dynamic>;
    final title = responseJson['title'] as String;
  }

  @override
  void initState() {
    super.initState();
    //_opneUrl();
    //window.open('http://localhost:3000'.toString(), '_top');
    _openHtml();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Url Launcher'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Urlを開く'),
          onPressed: () => _opneUrl(),
        ),
      ),
    );
  }
}
