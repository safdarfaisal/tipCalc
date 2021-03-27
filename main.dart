import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}
class MyAppState extends State<MyApp> {
  bool amountEntered = false;
  double amount = 0;

  setAmountEntered(amt) {
    setState(() {
      amountEntered = true;
      amount = amt;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title:  'Flutter Demo',
      theme: ThemeData(
        accentColor: Colors.red,
        primarySwatch: Colors.red,
        accentTextTheme: Typography.whiteCupertino,
        canvasColor: Colors.orangeAccent,
      ),
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('AmountCalculator'),
            child: AmountCalculator(
              title: 'Tip Calculator',
              onNext: setAmountEntered,
            ),
          ),
          if (amountEntered) MaterialPage(
            key: ValueKey('TipCalculator'),
            child: TipCalculator(
              title: 'Tip Calculator',
              amount: amount,
            ),
          ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          setState(() {
            amountEntered = false;
          });


          return true;
        },
      ),
    );
  }
}


class AmountCalculator extends StatefulWidget {
  AmountCalculator({Key key, this.title, this.onNext}) : super(key: key);
  final String title;
  final ValueChanged<double> onNext;

  @override
  _AmountCalculatorState createState() => _AmountCalculatorState();
}

class _AmountCalculatorState extends State<AmountCalculator> {
  double _amount = 0;
  TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: new InputDecoration(
                labelText: "Enter bill amount paid",
                fillColor: Colors.grey[200],
                filled: true,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
              textAlign: TextAlign.center,
              controller: _controller,
              onChanged: (String value) async {
                _amount = double.parse(value);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => widget.onNext(_amount),
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}


class TipCalculator extends StatefulWidget {
  double amount = 0;
  TipCalculator({Key key, this.title, this.amount}) : super(key: key);
  final String title;
  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator> {
  double _tipPercentage = 0;
  double _total = 0;
  double _tip = 0;
  TextEditingController _controller;
  TextEditingController _controlTip;

  void calculateTotal() {
    _tip = (widget.amount*_tipPercentage)/100;
    _total = widget.amount + _tip;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Here's your bill"),
          content: Text (' Amount Paid: ' +
              widget.amount.toString() + '\n Tips Paid: $_tip \n Total Amount: $_total'),
          actions: <Widget>[
            TextButton(
              onPressed: () { Navigator.pop(context); },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controlTip = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    _controlTip.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title != null ? widget.title : "Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
                'Amount before tips: ' + widget.amount.toString(),
                textScaleFactor: 1.5,
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
            ),

            TextField(
              decoration: new InputDecoration(
                labelText: "Tip Percentage",
                fillColor: Colors.white,
                filled: true,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
              textAlign: TextAlign.center,
              controller: _controlTip,
              onChanged: (String value) async {
                _tipPercentage = double.parse(value);
              },
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: calculateTotal,
        child: Text(
          '=',
          textScaleFactor: 3,
        ),
      ),
    );
  }
}


