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

  Future<void> predData(RH, UPV, SandT, CementT) async {
    final interpreter =
        await Interpreter.fromAsset('linear_regression_model.tflite');
    // final interpreter = await Interpreter.fromAsset('predmodel.tflite');
    var input = [
      [RH, UPV, SandT, CementT]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);

    this.setState(() {
      predValue = (output[0][0] / 10).toStringAsFixed(3).toString() + " Pa";
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
        backgroundColor: const Color(0xffe3c0ed),
        appBar: AppBar(
            title: Text("DT Predictor"),
            backgroundColor: const Color(0xff521662)),
        body: SingleChildScrollView(
          child: Padding(
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
                            FocusScope.of(context)
                                .requestFocus(_secondFocusNode);
                          },
                          decoration: InputDecoration(
                              labelText: 'RH',
                              labelStyle:
                                  TextStyle(color: const Color(0xff310d3b))),
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
                            FocusScope.of(context)
                                .requestFocus(_thirdFocusNode);
                          },
                          decoration: InputDecoration(
                              labelText: 'UPV',
                              labelStyle:
                                  TextStyle(color: const Color(0xff310d3b))),
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
                            FocusScope.of(context)
                                .requestFocus(_fourthFocusNode);
                          },
                          decoration: InputDecoration(
                              labelText: 'Sand Type',
                              labelStyle:
                                  TextStyle(color: const Color(0xff310d3b))),
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
                            double RH, UPV, SandT, CementT;

                            try {
                              RH = double.parse(_RHController.text);
                              UPV = double.parse(_UPVController.text);
                              SandT = double.parse(_STypeController.text);
                              CementT = double.parse(_CTypeController.text);
                            } catch (e) {
                              RH = 0.0;
                              UPV = 0.0;
                              SandT = 0.0;
                              CementT = 0.0;
                            }
                            predData(RH, UPV, SandT, CementT);
                          },
                          decoration: InputDecoration(
                              labelText: 'Cement Type',
                              labelStyle:
                                  TextStyle(color: const Color(0xff310d3b))),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Text(
                    "Predicted Value :  $predValue ",
                    style:
                        TextStyle(color: const Color(0xff310d3b), fontSize: 23),
                  ),
                  SizedBox(height: 32.0),
                  Align(
                    alignment: Alignment.topRight,
                    child: MaterialButton(
                        color: Color(0xff521662),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        child: Text(
                          "PREDICT",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          double RH, UPV, SandT, CementT;

                          try {
                            RH = double.parse(_RHController.text);
                            UPV = double.parse(_UPVController.text);
                            SandT = double.parse(_STypeController.text);
                            CementT = double.parse(_CTypeController.text);
                          } catch (e) {
                            RH = 0.0;
                            UPV = 0.0;
                            SandT = 0.0;
                            CementT = 0.0;
                          }
                          predData(RH, UPV, SandT, CementT);
                        }),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.topRight,
                    child: MaterialButton(
                        color: Color(0xff521662),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                        ),
                        child: Text(
                          "CLEAR",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        onPressed: () {
                          // initState();
                          _RHController.clear();
                          _UPVController.clear();
                          _STypeController.clear();
                          _CTypeController.clear();
                          setState(() {
                            predValue = "";
                          });
                          FocusScope.of(context).requestFocus(_firstFocusNode);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
