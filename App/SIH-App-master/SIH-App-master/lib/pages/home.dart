

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sih_app/utils/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   List<String> languages = ["English", "Hindi", "Urdu", "Tamil"];
  String currL = "English";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                  Text("Elevate",style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                  Container(
                    
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: DropdownMenu(
                        initialSelection: currL,
                      width: 100,
                                    
                        dropdownMenuEntries: languages
                            .map<DropdownMenuEntry<String>>(
                                (e) => DropdownMenuEntry(
                                      label: e,
                                      value: e,
                                    ))
                            .toList(),
                        onSelected: (value) {
                          setState(() {
                            currL = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: (){}, child: Text("Help",style:GoogleFonts.poppins(color: Colors.white),))
                ],
            ),
            SizedBox(height: 30,),
            Text("Shovel Details",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),

             
            Container(
              width: MediaQuery.of(context).size.width-40,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.withOpacity(0.2)
              ),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name",style: GoogleFonts.roboto(fontSize: 15,color:Colors.black,fontWeight: FontWeight.w500),),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Rajesh",style: GoogleFonts.roboto(fontSize: 14),),
                  ),

                ],
              )
            ),
            SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width-40,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.withOpacity(0.2)
              ),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID",style: GoogleFonts.roboto(fontSize: 15,color:Colors.black,fontWeight: FontWeight.w500),),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("6655cazcn65",style: GoogleFonts.roboto(fontSize: 14),),
                  ),

                ],
              )
            ),
             SizedBox(height: 15,),
            Container(
              width: MediaQuery.of(context).size.width-40,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.withOpacity(0.2)
              ),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contact Number",style: GoogleFonts.roboto(fontSize: 15,color:Colors.black,fontWeight: FontWeight.w500),),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("+91 5688545554545",style: GoogleFonts.roboto(fontSize: 14),),
                  ),

                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}