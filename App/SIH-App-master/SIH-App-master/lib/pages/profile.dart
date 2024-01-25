import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sih_app/database/Apis.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> data = {};
  void getData() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    var user = await sh.getString("user");
    data = jsonDecode(user!)['user'];
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFEF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ).copyWith(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Profile",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Driver Profile"),
                    enabled
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                enabled = false;
                              });
                            },
                            child: const Text("Done"))
                        : InkWell(
                            onTap: () {
                              setState(() {
                                enabled = true;
                              });
                            },
                            child: const Icon(
                              Icons.edit_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                          )
                  ],
                ),
                const SizedBox(
                  height: 10,
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
                            const Icon(
                              Icons.person_outline,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Name",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  height: 30,
                                  child: TextFormField(
                                    enabled: enabled,
                                    initialValue: "njbn",
                                    decoration: const InputDecoration(
                                      disabledBorder: InputBorder.none,
                                    ),
                                    style: const TextStyle(
                                        color: Color(0xff101A29),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.car_crash_rounded,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Driver ID",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  height: 30,
                                  child: TextFormField(
                                    enabled: enabled,
                                    initialValue: "njbn",
                                    decoration: const InputDecoration(
                                        disabledBorder: InputBorder.none),
                                    style: const TextStyle(
                                        color: Color(0xff101A29),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_3_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Age",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  height: 30,
                                  child: TextFormField(
                                    enabled: enabled,
                                    initialValue: "njbn",
                                    decoration: const InputDecoration(
                                        disabledBorder: InputBorder.none),
                                    style: const TextStyle(
                                        color: Color(0xff101A29),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_city_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Address",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  height: 30,
                                  child: TextFormField(
                                    enabled: enabled,
                                    initialValue: "njbn",
                                    decoration: const InputDecoration(
                                        disabledBorder: InputBorder.none),
                                    style: const TextStyle(
                                        color: Color(0xff101A29),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.bloodtype_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Blood Group",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  height: 30,
                                  child: TextFormField(
                                    enabled: enabled,
                                    initialValue: "njbn",
                                    decoration: const InputDecoration(
                                        disabledBorder: InputBorder.none),
                                    style: const TextStyle(
                                        color: Color(0xff101A29),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  height: 30,
                                  child: TextFormField(
                                    enabled: enabled,
                                    initialValue: "njbn",
                                    decoration: const InputDecoration(
                                        disabledBorder: InputBorder.none),
                                    style: const TextStyle(
                                        color: Color(0xff101A29),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("App Settings"),
                const SizedBox(
                  height: 10,
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
                            const Icon(
                              Icons.language_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Language",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "English",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            const Icon(
                              Icons.arrow_drop_down_sharp,
                              color: Color(0xff4A4A4A),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Machine Details"),
                const SizedBox(
                  height: 10,
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
                            const Icon(
                              Icons.car_crash_sharp,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Vehile Number",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "MH-712-jkj",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.perm_identity_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Unique ID",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "MH-712-jkj",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.monitor_weight_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Capacity",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "75",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.type_specimen_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Model Number",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "712-jkj",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.work_history_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Working Condition",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "A+",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.panorama_vertical_select_sharp,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Distance travelled",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "545121 km",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        color: const Color(0xffEFEFEF),
                        height: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.fire_truck_outlined,
                              color: Color(0xff4A4A4A),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Load carried",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                  ),
                                ),
                                Text(
                                  "4565 ton",
                                  style: TextStyle(
                                      color: Color(0xff101A29),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(child: Text("ALERT")),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Are you sure to Log Out?"),
                                GestureDetector(
                                  onTap: () {
                                    ApiService apiService = ApiService();
                                    apiService.logout(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                        color: Color(0xffD7323D),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Center(
                                        child: Text(
                                      "LOG OUT",
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
                                        border: Border.all(
                                            color: const Color(0xff101A29)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Center(child: Text("CANCEL")),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color(0xffD7323D),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "LOG OUT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
