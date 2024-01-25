import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sih_app/map_provider.dart';
import 'package:sih_app/pages/loading.dart';
import 'package:sih_app/pages/map.dart';
import 'package:sih_app/pages/profile.dart';
import 'package:sih_app/utils/widgets.dart';

class MovingPage extends StatefulWidget {
  const MovingPage({super.key});

  @override
  State<MovingPage> createState() => _MovingPageState();
}

class _MovingPageState extends State<MovingPage> {
  @override
  Widget build(BuildContext context) {
    bool loading = context.watch<MapProvider>().loading;
    String instructs = context.watch<MapProvider>().instructions;
    double time = context.watch<MapProvider>().time_left;
    double distance = context.watch<MapProvider>().distance;
    int tp = context.watch<MapProvider>().total_points;
    int idx = context.watch<MapProvider>().idx;
    double vol = context.watch<MapProvider>().volume;

    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello Utkarsh!",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  InkWell(
                      onTap: () {
                        nextScreen(context, const ProfilePage());
                      },
                      child: const Icon(Icons.person_2_outlined))
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 40,
                decoration: const BoxDecoration(
                    color: Color(0xff101A29),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      Icons.arrow_upward_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      instructs,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              const MapScreen(),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${(time / 60).toStringAsFixed(1)} min",
                          style: TextStyle(
                              color: Color(
                                0xff101A29,
                              ),
                              fontWeight: FontWeight.w600),
                        ),
                        Text("${(distance / 1000).toStringAsFixed(2)} km . 4:35 PM"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (vol == 0.0) {
                          Provider.of<MapProvider>(context,listen: false).setVol(1.0);
                        }else{
                          Provider.of<MapProvider>(context,listen: false).setVol(0.0);
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: vol == 0.0?Icon(Icons.mic_off): Icon(
                          Icons.mic_none_outlined,
                          color: Color(0xff4A4A4A),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Next Destination",
                                style: TextStyle(
                                  color: Color(0xff4A4A4A),
                                ),
                              ),
                              const Text(
                                "Burgundy cres",
                                style: TextStyle(
                                    color: Color(0xff101A29),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (idx == tp) {
                                    nextScreenReplace(context, LoadingPage());
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  padding: const EdgeInsets.all(8),
                                  child: const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "REACHED",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: tp == idx
                                          ? Color(0xff101A29)
                                          : Colors.grey,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showdialog();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.help_outline_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "HELP & SUPPORT",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      )),
    );
  }

  void showdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
                child: Text(
              "ALERT",
              style: TextStyle(color: Color(0xff101A29)),
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Looks like something paused your progress. Need a hand getting back on track?"),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color(0xff101A29),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Center(
                        child: Text(
                      "DISMISS",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff101A29)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: const Center(child: Text("HELP & SUPPORT")),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
