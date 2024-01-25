import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih_app/pages/authPage.dart';
import 'package:sih_app/utils/constants.dart';
import 'package:sih_app/utils/widgets.dart';

class ApiService {
  Future<String> gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('x-auth-token');
    return "";
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      var res = await http.post(Uri.parse('$ServerUrl/frontend/authenticate'),body: jsonEncode({
            
            'email': email,
            'password': password,
            
          }),
          headers: <String, String>{
            'content-Type': 'application/json; charset=UTF-8'
          });
      var data = jsonDecode(res.body);
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', res.body);
        await prefs.setString('autho', data['autho']);

        return true;
      } else {
        // ignore: use_build_context_synchronously
        showSnakbar(context, Colors.red, data["message"]);
        return false;
      }
    } catch (e) {
      showSnakbar(context, Colors.red, e.toString());
      return false;
    }
  }

  Future<bool> regsiter(String name, String email, String password, String type,
      BuildContext context) async {
    try {
      var res = await http.post(Uri.parse('$ServerUrl/frontend/register'),
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'type': type
          }),
          headers: <String, String>{
            'content-Type': 'application/json; charset=UTF-8'
          });
      var data = jsonDecode(res.body);
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', res.body);
        await prefs.setString('autho', data['autho']);

        return true;
      } else {
        // ignore: use_build_context_synchronously
        showSnakbar(context, Colors.red, data["message"]);
        return false;
      }
    } catch (e) {
      print(e.toString());
      showSnakbar(context, Colors.red, e.toString());
      return false;
    }
  }

  void logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear().then((value) => {
            if (value)
              {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthPage()),
                    (Route route) => false)
              }
            else
              {showSnakbar(context, Colors.red, "something went wrong")}
          });
    } catch (e) {
      showSnakbar(context, Colors.red, e.toString());
    }
  }
}
