import 'dart:io';

import 'package:caden_app2/src/facing_feature/facing_feature_details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyFileButton extends StatelessWidget {
  const ModifyFileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<FacingFeatureState>(context,listen: false);

    return ElevatedButton(
      onPressed:  () => appState.editFile(modifyFile(context)), 
      child: const Text("Modify"),
    );
  }

  String modifyFile(BuildContext context){
    var appState = Provider.of<FacingFeatureState>(context,listen: false);
    var result = appState.result;
    
    String? path = result?.paths.first;
    File file = File(path!);
    String fileString = file.readAsStringSync();

    RegExp faceLength = RegExp(r'^[(]([\0-9]+)');
    String? ogString = faceLength.firstMatch(fileString)!.group(1); //group 0 includes parenthesis, group 1 doesnt
    double ogNum = double.parse(ogString!);
    double ogLength = double.parse((ogNum * 25.4).toStringAsFixed(2)); //from inches to mm
    double lengthMM = double.parse((appState.lengthInches! * 25.4).toStringAsFixed(2));

    fileString = fileString.replaceFirst(faceLength, '(${appState.lengthInches}'); //replace oldInches with newInches at top

    fileString = fileString.replaceAll(RegExp('Y${(ogLength + 3.20).toStringAsFixed(2)}'), 'Y${(lengthMM+3.2).toStringAsFixed(2)}');
    fileString = fileString.replaceAll(RegExp('Y${(ogLength + 2.80).toStringAsFixed(2)}'), 'Y${(lengthMM + 2.8).toStringAsFixed(2)}');
    fileString = fileString.replaceAll(RegExp('Y${(ogLength + 2.40).toStringAsFixed(2)}'), 'Y${(lengthMM + 2.4).toStringAsFixed(2)}');
    fileString = fileString.replaceAll(RegExp('Y${(ogLength + 2.00).toStringAsFixed(2)}'), 'Y${(lengthMM + 2).toStringAsFixed(2)}');

    return fileString;
  }
}
