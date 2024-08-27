import 'dart:developer';
import 'dart:io';

import 'package:caden_app2/src/holes_feature/holes_feature_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HoleModifyFileButton extends StatelessWidget {
  const HoleModifyFileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<HolesFeatureState>(context,listen: false);

    return ElevatedButton(
      onPressed:  () => appState.editFile(modifyFile(context)), 
      child: const Text("Modify"),
    );
  }

  String modifyFile(BuildContext context){
    var appState = Provider.of<HolesFeatureState>(context,listen: false);
    var result = appState.result;
    
    String? path = result?.paths.first;
    File file = File(path!);
    String fileString = file.readAsStringSync();

    //Replace Title
    fileString = fileString.replaceFirst(
      RegExp(r'[(](.*[)])'), 
      '(${appState.numHolesLength.value} x ${appState.numHolesWidth.value} ${appState.spaceBetweenLength.value}in gap) '
    );

    int startIndex = fileString.indexOf('LL)');

    //Replace First X12.7 and Y12.7, L3
    fileString = fileString.replaceFirst(RegExp(r'[X][0-9]+([.]([0-9]+)?)?'), 'X${appState.widthOffset.value}');
    fileString = fileString.replaceFirst(RegExp(r'[Y][0-9]+([.]([0-9]+)?)?'), 'Y${appState.lengthOffset.value}');
    fileString = fileString.replaceFirst(RegExp(r'[L][0-9]+([.]([0-9]+)?)?'), 'L${(appState.numHolesWidth.value - 1).toInt()}', startIndex+3);
    
    startIndex = fileString.indexOf('Y${appState.lengthOffset.value}') + 1;

    //replace second X12.7 Y12.7
    fileString = fileString.replaceFirst(RegExp(r'[X][0-9]+([.]([0-9]+)?)?'), 'X${appState.spaceBetweenWidth.value}', startIndex+3);
    fileString = fileString.replaceFirst(RegExp(r'[Y][0-9]+([.]([0-9]+)?)?'), 'Y${appState.lengthOffset.value}', startIndex+3);


    startIndex = fileString.indexOf('L${(appState.numHolesWidth.value - 1).toInt()}');

    //Replace Second L3
    fileString = fileString.replaceFirst(RegExp(r'[L][0-9]+([.]([0-9]+)?)?'), 'L${(appState.numHolesLength.value - 1).toInt()}', startIndex + 2);


    //find second L3
    startIndex = fileString.indexOf('L${(appState.numHolesLength.value - 1).toInt()}', startIndex);

    //replace 3rd L3
    fileString = fileString.replaceFirst(RegExp(r'[L][0-9]+([.]([0-9]+)?)?'), 'L${(appState.numHolesLength.value - 1).toInt()}', startIndex+3);

    //replace feedrate
    fileString =  fileString.replaceAll(RegExp(r'[F][0-9]+([.]([0-9]+)?)?'), 'F${appState.feedRate.value}');

    startIndex = fileString.indexOf('G0 X0 ');

    //Replace last Y12.7
    fileString =  fileString.replaceFirst(RegExp(r'[Y][0-9]+([.]([0-9]+)?)?'), 'Y${appState.spaceBetweenLength.value}', startIndex);

    return fileString;
  }
}
