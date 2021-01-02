import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interest Calculator',
      theme:
          ThemeData(primarySwatch: Colors.teal, accentColor: Colors.tealAccent),
      home: Form(),
    );
  }
}

class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {
  // controller
  TextEditingController principalTextEditingController =
      TextEditingController();
  TextEditingController rateofInterestTextEditingController =
      TextEditingController();
  TextEditingController termTextEditingController = TextEditingController();

  // currencices
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];

  String result = "";
  String _character = "";
  String currentValue = "";
  String nv = "";

  @override
  void initState() {
    currentValue = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Interest Calculator",
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            //image
            getImage(),

            Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: ListTile(
                    title: Text("Simple Interest"),
                    leading: Radio(
                      value: "simple",
                      groupValue: _character,
                      onChanged: (String value) {
                        setState(() {
                          // here it is simple
                          _character = value;
                        });
                      },
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: ListTile(
                    title: Text("Coumpound Interest"),
                    leading: Radio(
                      value: "coumpound",
                      groupValue: _character,
                      onChanged: (String value) {
                        setState(() {
                          // here it is simple
                          _character = value;
                        });
                      },
                    ),
                  ),
                )),
                Container(
                  width: 5.0,
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: principalTextEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Principal",
                    hintText: "Enter a principal amount e.g, 1099",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: rateofInterestTextEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Rate of Interest",
                    hintText: "Enter a rate per year",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      controller: termTextEditingController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: "Term",
                          hintText: "Enter number of year",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),

                // dropdown menu
                Expanded(
                  child: DropdownButton<String>(
                    items: _currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: currentValue,
                    onChanged: (String newValue) {
                      _setSelectedValue(newValue);
                      this.nv = newValue;
                      setState(() {
                        this.currentValue = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Expanded(
                    child: RaisedButton(
                  color: Colors.tealAccent,
                  textColor: Colors.black,
                  child: Text(
                    "CALCULATE",
                    textScaleFactor: 1.75,
                  ),
                  onPressed: () {
                    this.result = _getEffectiveAmount(this.nv);
                    onDialogOpen(context, this.result);
                  },
                )),
                Container(
                  width: 10,
                ),
                Expanded(
                    child: RaisedButton(
                  color: Colors.tealAccent,
                  textColor: Colors.black,
                  child: Text(
                    "RESET",
                    textScaleFactor: 1.75,
                  ),
                  onPressed: () {
                    _reset();
                  },
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _setSelectedValue(String newValue) {
    setState(() {
      this.currentValue = newValue;
    });
  }

  String _getEffectiveAmount(String newValue) {
    String newResult;
    double principal = double.parse(principalTextEditingController.text);
    double rate = double.parse(rateofInterestTextEditingController.text);
    double term = double.parse(termTextEditingController.text);

    double netpayableAmount = 0;
    if (_character == "simple") {
      netpayableAmount = principal + (principal * rate * term) / 100;
    } else if (_character == "compound") {
      netpayableAmount = principal * pow((1 + (rate / 100)), term);
    }

    if (term == 1) {
      newResult =
          "After $term year, you will have to pay total amount = $netpayableAmount $currentValue";
    } else {
      newResult =
          "After $term year, you will have to pay total amount = $netpayableAmount $currentValue";
    }
    return newResult;
  }

  void _reset() {
    principalTextEditingController.text = "";
    rateofInterestTextEditingController.text = "";
    termTextEditingController.text = "";
    result = "";
    currentValue = _currencies[0];
  }

  // dialog box

  void onDialogOpen(BuildContext context, String s) {
    var alertDialog = AlertDialog(
      title: Text("NP is selected...."),
      content: Text(s),
      backgroundColor: Colors.green,
      elevation: 8.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(s),
          );
        });
  }
}

Widget getImage() {
  AssetImage assetImage = AssetImage("assets/back.png");
  Image image = Image(
    image: assetImage,
    width: 150,
    height: 150,
  );

  return Container(
    child: image,
    margin: EdgeInsets.all(30),
  );
}
