import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

class HoleLengthInputBox extends StatelessWidget{
  const HoleLengthInputBox({super.key, required this.descriptor, required this.updateFunction, required this.appStateVariable});

  final String descriptor;
  final void Function(double) updateFunction;
  final ValueListenable<double> appStateVariable;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 500,
        minWidth: 100,
        maxWidth: 200
      ),
      padding: const EdgeInsets.all(4.0),
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.blueGrey,
            width: 4.0
            ),
          horizontal: BorderSide(
            color: Colors.blueGrey,
            width: 4.0
          )
        ),
        color: Colors.grey
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "Enter $descriptor in inches"),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))],
              onSubmitted: (value) {
                if(value.isEmpty){
                  value = '0.0';
                }
                
                if(isFloat(value)) {
                  updateFunction(double.parse(value));
                }
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<double>(
              valueListenable: appStateVariable,
              builder: (context, value, child) {
                return Text("Selected $descriptor: ${appStateVariable.value}");
              }
            ),
          )
        ],
      ),
    );
  }
}
