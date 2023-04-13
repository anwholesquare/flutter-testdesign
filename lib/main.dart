// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sign_button/sign_button.dart';

void main () {
    runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int appColor = 3;
  void update (int status, dynamic data) {
      if (status == 1 && data is int) {
        appColor = data % 4;
        setState(() {});
      }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: appColor == 3 ? Colors.blue : appColor == 2 ? Colors.green : Colors.red,
            fontFamily: GoogleFonts.poppins().fontFamily
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(updateMyApp: update)

    );
  }
}

class HomePage extends StatefulWidget {
  final void Function (int, dynamic)? updateMyApp;
  const HomePage({super.key, required this.updateMyApp});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dob = DateFormat.yMd().format (DateTime.now());
  List<DropdownMenuItem<String>> countries = [DropdownMenuItem(child: Text("No Country"))];
  String? selectedCountry;
  bool _isChecked = true;
  int appColor = 3;

  Widget TextBox (String label, String hint, {bool security = false}) => TextField(
    obscureText: security,
    decoration: InputDecoration (
      labelText: label,
      hintText: hint,
      prefixIcon:  Icon (security ? Icons.pin : Icons.person),
      border: UnderlineInputBorder()
    )
  );

  void getCountries () async {

    final response = await http.get(Uri.parse("https://raw.githubusercontent.com/anwholesquare/form-building-json/main/countries.json"));
    countries = [DropdownMenuItem(child: Text("No Country"))];
    if (response.statusCode == 200) {
        var cntr = json.decode(response.body);
        for (dynamic k in cntr) {
            String nText = k["text"].toString();
            countries.add(DropdownMenuItem(value: k["value"], child: Text(nText)));
        }
        setState(() {
          
        });
    }
  }

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column (children: [
                      Row (children: [
                        Icon(Icons.arrow_back_ios_new_rounded),
                        SizedBox(height:20),
                        Text("Coursido Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold) )
                       ],),
                       SizedBox(height: 20,),
                       TextBox("Email", "Enter Email Address"),
                       SizedBox(height: 20,),
                       Row (children: [
                          Flexible (
                            flex:4,
                            child: 
                          DropdownButtonFormField<String>(
                              items: countries,
                              isExpanded: true,
                              onChanged: (String? ne) {
                                debugPrint(ne);
                              },
                              decoration: InputDecoration(
                                labelText: "Country",
                                prefixIcon: Icon(Icons.public_rounded)
                              ),

                          ),),
                          SizedBox(width: 5,),
                          Flexible(
                            flex:3,
                            child: TextFormField(
                              onTap:() async {
                                  final DateTime? pickDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());

                                  if (pickDate != null) {
                                      setState(() {
                                        dob = DateFormat.yMd().format(pickDate);
                                      });
                                  }
                              },
                              readOnly: true,
                              controller: TextEditingController(text:dob),
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                                prefixIcon: Icon(Icons.calendar_month_sharp),
                                border: UnderlineInputBorder()
                              )
                            )
                          )

                       ],),
                      SizedBox(height:20),
                      TextBox(security: true, "PIN", "Enter PIN"),
                      SizedBox(height: 20,),
                      Row (children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (val) => setState(() {
                            _isChecked = val!;
                          }),
                        ),
                        SizedBox(width: 10,),
                        Text("I agree with terms and conditions")


                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => setState(() {
                              appColor = 1; widget.updateMyApp!(1, appColor);
                            }),
                            child: Container (
                              height: 32,
                            width: 32,
                            decoration: BoxDecoration(shape:BoxShape.circle, color: Colors.red),
                            child: (appColor == 1) ? Icon(Icons.check_rounded, color: Colors.white,) : null,
                            
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: () => setState(() {
                              appColor = 2; widget.updateMyApp!(1, appColor);
                            }),
                            child: Container (
                              height: 32,
                            width: 32,
                            decoration: BoxDecoration(shape:BoxShape.circle, color: Colors.green),
                            child: (appColor == 2) ? Icon(Icons.check_rounded, color: Colors.white,) : null,
                            
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: () => setState(() {
                              appColor = 3; widget.updateMyApp!(1, appColor);
                            }),
                            child: Container (
                              height: 32,
                            width: 32,
                            decoration: BoxDecoration(shape:BoxShape.circle, color: Colors.blue),
                            child: (appColor == 3) ? Icon(Icons.check_rounded, color: Colors.white,) : null,
                            
                            ),
                          ),
                          
                          
                        ]
                      ),
                      SizedBox(height: 20,),
                      Center (child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ThankYouPage()));
                        },
                        child: Text("Create a New Account")
                      ),),
                      SizedBox(height: 20,),
                      Center(child: Text("OR",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                      SizedBox(height: 20,),
                      Center(
                        child: SignInButton(buttonType: ButtonType.google, buttonSize: ButtonSize.small,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ThankYouPage()));
                        },
                        ),
                      )


                  ],)
              ),
            ),
        )
      )
      
    );
  }
}


class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Coursido")),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/boring.gif", height: 300,),
          SizedBox(height: 20,),
          Text("Thank you for the registration", style: TextStyle(fontWeight: FontWeight.bold),)

      ],)),
    );
  }
}