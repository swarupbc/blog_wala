import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List> fetchPosts() async {
  final response = await http.get(
      "https://swarup.sanscript.tech/index.php/wp-json/wp/v2/posts",
      headers: {"Accept": "application/json"});

  var convertedData = jsonDecode(response.body);
  return convertedData;
}

Future<Map> fetchImage(href) async {
  final response =
      await http.get(href, headers: {"Accept": "application/json"});

  var convertedData = jsonDecode(response.body);
  return convertedData;
}
