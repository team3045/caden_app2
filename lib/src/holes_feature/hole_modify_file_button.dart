import 'dart:io';

import 'package:caden_app2/src/holes_feature/holes_feature_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class HoleModifyFileButton extends StatelessWidget {
  const HoleModifyFileButton({
    super.key,
  });

  static const double maxXLength = 31.0; //in
  static const double maxYWidth = 4.5; //in

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<HolesFeatureState>(context,listen: false);

    return ElevatedButton(
      onPressed:  () {
        if(!isReadyForEdit(context)){
          toastification.show(
	          context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: const Text("Your parameters are not allowed"),
            description: const Text(
                "Try checking that your offset and spacing doesn't exceed workspace boundaries. "),
            alignment: Alignment.center,
            autoCloseDuration: const Duration(seconds: 4),
            primaryColor: const Color(0xff4682b4),
            boxShadow: lowModeShadow,
	);
        } else{
          appState.editFile(modifyFile(context));
        }
      }, 
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

  bool isReadyForEdit(BuildContext context){
    var appState = Provider.of<HolesFeatureState>(context,listen: false);
    double xOff = appState.lengthOffset.value;
    double yOff = appState.widthOffset.value;
    double numHolesLength = appState.numHolesLength.value - 1;
    double numHolesWidth = appState.numHolesWidth.value - 1;
    double xSpacing = appState.spaceBetweenLength.value;
    double ySpacing = appState.spaceBetweenWidth.value;

    return (xOff+numHolesLength*xSpacing <= maxXLength) &&
      (yOff + numHolesWidth*ySpacing <= maxYWidth);
  }
}
