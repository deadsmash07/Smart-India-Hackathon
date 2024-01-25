import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:sih_app/database/Apis.dart';
import 'package:sih_app/map_provider.dart';
import 'package:sih_app/pages/authpage.dart';
import 'package:sih_app/pages/getstarted.dart';
import 'package:sih_app/pages/loading.dart';
import 'package:sih_app/pages/moving.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MapProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loggedIn = false;
  ApiService apiService = ApiService();
  @override
  void initState() {
    apiService.gettoken().then((value) => {
          if (value != null)
            {
              setState(() {
                loggedIn = true;
              })
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elevate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: GetStarted(),
    );
  }
}
