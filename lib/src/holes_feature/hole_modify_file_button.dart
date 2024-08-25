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

    int startIndex = fileString.indexOf('LL)');

    fileString = fileString.replaceFirst(RegExp(r'[X]([\0-9][^ ]+)'), 'X${appState.widthOffset.value}');
    fileString = fileString.replaceFirst(RegExp(r'[Y]([\0-9][^ ]+)'), 'Y${appState.lengthOffset.value}');
    fileString = fileString.replaceFirst(RegExp(r'[L]([\0-9][^ ]+)'), 'L${appState.numHolesWidth.value}', startIndex+3);

    startIndex = fileString.indexOf('L${appState.numHolesWidth.value}');
    
    fileString = fileString.replaceFirst(RegExp(r'[L]([\0-9][^ ]+)'), 'L${appState.numHolesLength.value}', startIndex);
    fileString = fileString.replaceFirst(RegExp(r'[X]([\0-9][^ ]+)'), 'X${appState.spaceBetweenWidth.value}', startIndex);
    fileString = fileString.replaceFirst(RegExp(r'[Y]([\0-9][^ ]+)'), 'Y${appState.lengthOffset.value}', startIndex);

    startIndex = fileString.indexOf('Y${appState.lengthOffset.value}', startIndex);

    fileString =  fileString.replaceFirst(RegExp(r'[Y]([\0-9][^ ]+)'), 'Y${appState.spaceBetweenLength.value}', startIndex);

    fileString = fileString.replaceFirst(
      RegExp(r'^[(](.*)'), 
      '(${appState.numHolesLength.value} x ${appState.numHolesWidth.value} ${appState.spaceBetweenLength.value}in gap) '
    );

    return fileString;
  }
}
