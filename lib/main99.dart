import 'dart:convert';
import 'dart:io';

void main99() async {
  runCommand();
}

void runCommand() async {
  var result = await Process.run('ls', ['-l']);
  print(result.stdout);
}




