import 'package:http/http.dart' as http;

void main() async {
  final response = await http.get(Uri.parse('http://localhost:3000/'));

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
