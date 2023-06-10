import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PredModel extends StatefulWidget {
  @override
  _PredModelState createState() => _PredModelState();
}

class _PredModelState extends State<PredModel> {
  final TextEditingController _RHController = TextEditingController();
  final TextEditingController _UPVController = TextEditingController();
  final TextEditingController _STypeController = TextEditingController();
  final TextEditingController _CTypeController = TextEditingController();
  late FocusNode _firstFocusNode;
  late FocusNode _secondFocusNode;
  late FocusNode _thirdFocusNode;
  late FocusNode _fourthFocusNode;
  var predValue = "";
  @override
  void initState() {
    super.initState();
    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
    _fourthFocusNode = FocusNode();
    predValue = "click predict button";
  }

  @override
  void dispose() {
    _RHController.dispose();
    _UPVController.dispose();
    _STypeController.dispose();
    _CTypeController.dispose();
    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    _thirdFocusNode.dispose();
    _fourthFocusNode.dispose();
    super.dispose();
  }

  Future<void> predData(val) async {
    final interpreter = await Interpreter.fromAsset('predmodel.tflite');
    var input = [
      [val, 300.0, 1695.0, 3736.0, 5340.0]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);

    this.setState(() {
      predValue = output[0][0].toStringAsFixed(3).toString();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set the cursor to the TextField after a small delay
    Future.delayed(Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_firstFocusNode);
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DT Predictor"),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      // optional flex property if flex is 1 because the default flex is 1
                      flex: 1,
                      child: TextField(
                        key: Key("rh_text_field"),
                        focusNode: _firstFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(
                              r'[,\s-]')), // Disallow comma, space, and minus sign
                        ],
                        controller: _RHController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          // Move the focus to the second TextField when Done is pressed
                          FocusScope.of(context).requestFocus(_secondFocusNode);
                        },
                        decoration: InputDecoration(
                            labelText: 'RH',
                            labelStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      // optional flex property if flex is 1 because the default flex is 1
                      flex: 1,
                      child: TextField(
                        key: Key("upv_text_field"),
                        focusNode: _secondFocusNode,
                        controller: _UPVController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(
                              r'[,\s-]')), // Disallow comma, space, and minus sign
                        ],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          // Move the focus to the second TextField when Done is pressed
                          FocusScope.of(context).requestFocus(_thirdFocusNode);
                        },
                        decoration: InputDecoration(
                            labelText: 'UPV',
                            labelStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      // optional flex property if flex is 1 because the default flex is 1
                      flex: 1,
                      child: TextField(
                        key: Key("stype_text_field"),
                        focusNode: _thirdFocusNode,
                        controller: _STypeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(
                              r'[,\s-]')), // Disallow comma, space, and minus sign
                        ],
                        onSubmitted: (value) {
                          // Move the focus to the second TextField when Done is pressed
                          FocusScope.of(context).requestFocus(_fourthFocusNode);
                        },
                        decoration: InputDecoration(
                            labelText: 'Sand Type',
                            labelStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      // optional flex property if flex is 1 because the default flex is 1
                      flex: 1,
                      child: TextField(
                        key: Key("ctype_text_field"),
                        focusNode: _fourthFocusNode,
                        controller: _CTypeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(
                              r'[,\s-]')), // Disallow comma, space, and minus sign
                        ],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          double val;

                          try {
                            val = double.parse(_RHController.text);
                          } catch (e) {
                            val = 0.0;
                          }
                          predData(val);
                        },
                        decoration: InputDecoration(
                            labelText: 'Cement Type',
                            labelStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      "PREDICT",
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      double val;

                      try {
                        val = double.parse(_RHController.text);
                      } catch (e) {
                        val = 0.0;
                      }
                      predData(val);
                    }),
                SizedBox(height: 12),
                Text(
                  "Predicted Value :  $predValue ",
                  style: TextStyle(color: Colors.red, fontSize: 23),
                ),
                SizedBox(height: 12),
                MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      "CLEAR",
                      style: TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      // initState();
                      _RHController.clear();
                      _UPVController.clear();
                      _STypeController.clear();
                      _CTypeController.clear();
                      setState(() {
                        predValue = "click predict button";
                      });
                    }),
              ],
            ),
          ),
        ));
  }
}
