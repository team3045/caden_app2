import 'package:caden_app2/src/facing_feature/facing_feature_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class LengthInputBox extends StatelessWidget{
  const LengthInputBox({super.key, this.descriptor = 'length'});

  final String descriptor;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FacingFeatureState>();

    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: BoxConstraints.tight(const Size.square(320.0)),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: "Enter $descriptor in inches"),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))],
            onSubmitted: (value) {
              if(isFloat(value)) {
                appState.updateLength(double.parse(value));
              }
            },
          ),
          Text("Selected $descriptor of ${appState.lengthInches}")
        ],
      ),
    );
  }
}
