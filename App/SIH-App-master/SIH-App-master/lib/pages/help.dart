import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sih_app/utils/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController controller = TextEditingController();
  List<String> languages = ["English", "Hindi", "Urdu", "Tamil"];
  String currL = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  Text(
                    "Help and Support",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  Expanded(child: Container()),
                  Container(
                    child: DropdownButton(
                      value: currL,
                      items: languages
                          .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          currL = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showSnakbar(
                            context, Colors.green, "Message sent to admin");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "1. critical accident",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 3,
                      color: Color.fromARGB(255, 230, 223, 223),
                    ),
                    GestureDetector(
                      onTap: () {
                        showSnakbar(
                            context, Colors.green, "Message sent to admin");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "2. Machine Failure",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 3,
                      color: Color.fromARGB(255, 230, 223, 223),
                    ),
                    GestureDetector(
                      onTap: () {
                        showSnakbar(context, Colors.green,
                            "Message sent to admin ragarding this.");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "3. Fuel not enough",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  launch("tel:9341246568");
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Center(
                      child: Text("EMERGENCY SOS",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))),
                ),
              ),
              Expanded(child: Container()),
              Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Message"),
                      ),
                    ),
                    Expanded(child: Container()),
                    Icon(Icons.send),
                    Icon(Icons.camera),
                    Icon(Icons.mic)
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
