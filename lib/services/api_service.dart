import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/utils/snackbar_message.dart';
import 'package:toast/toast.dart';

class ApiService {
  static String url = "https://api.nstack.in/v1/todos";

  static Future<bool> createTodo(BuildContext context,
      {required Map<String, dynamic> body}) async {
    Uri uri = Uri.parse(url);
    var json = jsonEncode(body);
    var response = await http
        .post(uri, body: json, headers: {'content-type': 'application/json'});
    // print(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<List> getTodo() async {
    Uri uri = Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=20");
    var response = await http.get(uri);
    var data = jsonDecode(response.body);
    List todoItems = data['items'];
    return todoItems;
  }

  static getParticularTodo({required String id}) async {
    Uri uri = Uri.parse('$url/$id');
    var response = await http.get(uri);
    print(response.body);
  }

  static Future<bool> editTodo(
      {required String id, required Map<String, dynamic> body}) async {
    Uri uri = Uri.parse('$url/$id');
    var json = jsonEncode(body);
    var response = await http
        .put(uri, body: json, headers: {'content-type': 'application/json'});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteTodo({required String id}) async {
    Uri uri = Uri.parse('$url/$id');
    var response = await http.delete(uri);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
