
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:income_tax_cal/thousands_separator_input_formatter.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Income Tax Calculator - Sri Lanka'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String displayTaxAmount = "";
  String displayBalanceAmount = "";
  double enteredAmount = 0;
  TextEditingController textBoxController = TextEditingController();

  void calculateTax() {
    debugPrint("start calculateTax method()... text:${textBoxController.text.isEmpty}");

      double taxAmount = 0;
      if (textBoxController.text.isNotEmpty) {
        double taxBreak = 500000 / 12;
        debugPrint("taxBreak:$taxBreak");

        double runningAmount = double.parse(textBoxController.text.replaceAll(",", ""));
        enteredAmount = runningAmount;
        if (runningAmount > 100000) {
          runningAmount -= 100000;
          if (runningAmount <= taxBreak) {
            taxAmount += runningAmount * 0.06;
          } else {
            taxAmount += taxBreak * 0.06;
            runningAmount -= taxBreak;
            if (runningAmount <= taxBreak) {
              taxAmount += runningAmount * 0.12;
            } else {
              taxAmount += taxBreak * 0.12;
              runningAmount -= taxBreak;
              if (runningAmount <= taxBreak) {
                taxAmount += runningAmount * 0.18;
              } else {
                taxAmount += taxBreak * 0.18;
                runningAmount -= taxBreak;
                if (runningAmount <= taxBreak) {
                  taxAmount += runningAmount * 0.24;
                } else {
                  taxAmount += taxBreak * 0.24;
                  runningAmount -= taxBreak;
                  if (runningAmount <= taxBreak) {
                    taxAmount += runningAmount * 0.3;
                  } else {
                    taxAmount += taxBreak * 0.3;
                    runningAmount -= taxBreak;
                    if (runningAmount > 0) {
                      taxAmount += runningAmount * 0.36;
                    }
                  }
                }
              }
            }
          }
        }
      }

    setState(() {
      displayTaxAmount = NumberFormat("###,##0.00").format(taxAmount);
      displayBalanceAmount = NumberFormat("###,##0.00").format(enteredAmount - taxAmount);
    });
  }

  void resetAll() {
    debugPrint("start resetAll method()...");
    setState(() {
      enteredAmount = 0;
      displayTaxAmount = '';
      textBoxController.text = '';
      displayBalanceAmount = '';
    });
  }

  void clearCalculations() {
    debugPrint("start clearCalculations method()...");
    setState(() {
      displayTaxAmount = '';
      displayBalanceAmount = '';
    });
  }


  @override
  Widget build(BuildContext context) {
    debugPrint("start build method()...");
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),


      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Income Tax Calculator', style: Theme.of(context).textTheme.headline4,
            ),
            Container(height: 50),
            Text(
              'Enter Monthly Income', style: Theme.of(context).textTheme.headline6,
            ),
            //Container(height: 10),
             TextField(
              controller: textBoxController,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*,*\.?\d*)'))],
               //inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*,*\.?\d*)')), ThousandsSeparatorInputFormatter()],
                decoration: const InputDecoration(
                  filled: true,
                ),
               style: const TextStyle(
                 fontSize: 40
               ),
               onTap: clearCalculations,
            ),
            Container(height: 10),
             FlatButton(
              child: Text('Calculate', style: Theme.of(context).textTheme.headline3),
                color: Colors.lightBlue,
                onPressed: calculateTax),
            FlatButton(
              child: Text('Clear', style: Theme.of(context).textTheme.headline3),
              color: Colors.lightBlue,
              onPressed: resetAll),
            Container(height: 10),
            Text(
              'Tax Amount', style: Theme.of(context).textTheme.headline6,
            ),
            Text(displayTaxAmount, style: Theme.of(context).textTheme.headline3),
            Container(height: 10),
            Text(
              'Balance Monthly Income', style: Theme.of(context).textTheme.headline6,
            ),
            Text(displayBalanceAmount, style: Theme.of(context).textTheme.headline3)
          ],
        ),
      ),
    );
  }
}
