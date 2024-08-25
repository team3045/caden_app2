
import 'dart:developer';
import 'dart:io';

import 'package:caden_app2/src/holes_feature/hole_file_picker_tap.dart';
import 'package:caden_app2/src/holes_feature/hole_length_input_box.dart';
import 'package:caden_app2/src/holes_feature/hole_modify_file_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HolesFeatureDetailView extends StatelessWidget{
  const HolesFeatureDetailView({super.key});

  static const String routeName = '/holes_item';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HolesFeatureState>.value(
      value: HolesFeatureState(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Holes Page')
        ),
        body:  Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                Expanded(
                  child: HoleLengthInputBox(
                    descriptor: 'Length Offset', 
                    updateFunction: HolesFeatureState().updateLengthOffset, 
                    appStateVariable: HolesFeatureState().lengthOffset),
                ),
                Expanded(
                  child: HoleLengthInputBox(
                    descriptor: 'Width Offset', 
                    updateFunction: HolesFeatureState().updateWidthOffset, 
                    appStateVariable: HolesFeatureState().widthOffset),
                ),
                Expanded(
                  child: HoleLengthInputBox(
                    descriptor: 'Number of Holes Length Wise', 
                    updateFunction: HolesFeatureState().updateNumHolesLength, 
                    appStateVariable: HolesFeatureState().numHolesLength),
                ),
                Expanded(
                  child: HoleLengthInputBox(
                    descriptor: 'Number of Holes Width Wise', 
                    updateFunction: HolesFeatureState().updateNumHolesWidth, 
                    appStateVariable: HolesFeatureState().numHolesWidth),
                ),
                Expanded(
                  child: HoleLengthInputBox(
                    descriptor: 'Space Between Holes Length Wise', 
                    updateFunction: HolesFeatureState().updateSpaceBetweenLength, 
                    appStateVariable: HolesFeatureState().spaceBetweenLength),
                ),
                Expanded(
                  child: HoleLengthInputBox(
                    descriptor: 'Space Between Holes Width Wise', 
                    updateFunction: HolesFeatureState().updateSpaceBetweenWidth, 
                    appStateVariable: HolesFeatureState().spaceBetweenWidth),
                ),
               ],
            ),
          const Padding(
            padding: EdgeInsets.all(95.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                HoleModifyFileButton(),
                Spacer(),
                HoleFilePickerTap(title: 'File Picker')
              ],
            ),
          )
          ],
        )
      )
    );
  }
  
}

class HolesFeatureState extends ChangeNotifier {
  ValueNotifier<double> lengthOffset = ValueNotifier(0.5); //in
  ValueNotifier<double> widthOffset = ValueNotifier(0.5);//in
  ValueNotifier<double> numHolesLength = ValueNotifier(1);
  ValueNotifier<double> numHolesWidth = ValueNotifier(1); //min 1, max 3
  ValueNotifier<double> spaceBetweenLength = ValueNotifier(0.5); //in
  ValueNotifier<double> spaceBetweenWidth = ValueNotifier(0.5); //in
  //TODO: enum option for hole type or diameter

  FilePickerResult? result;

  HolesFeatureState._(){
    log("creating singleton");
  } //cannot be instantiated

  static final HolesFeatureState _instance = HolesFeatureState._();

  factory HolesFeatureState() => _instance;

  void updateLengthOffset(double newOffset){
    lengthOffset.value = newOffset;
    notifyListeners();
  }

  void updateWidthOffset(double newOffset){
    widthOffset.value = newOffset;
    notifyListeners();
  }

  void updateNumHolesLength(double newHoles){
    numHolesLength.value = newHoles;
    notifyListeners();
  }

  void updateNumHolesWidth(double newHoles){
    newHoles = newHoles < 1 ? 1 : newHoles;
    newHoles = newHoles > 3 ? 3 : newHoles;
    
    numHolesWidth.value = newHoles;
    notifyListeners();
  }

  void updateSpaceBetweenLength(double newGap){
    spaceBetweenLength.value = newGap;
    notifyListeners();
  }

  void updateSpaceBetweenWidth(double newGap){
    spaceBetweenWidth.value = newGap;
    notifyListeners();
  }

  void editFile(String newContents){
      String? path = result?.paths.first;
      File file = File(path!);

      file.writeAsStringSync(newContents);
    }

  void updateFile(FilePickerResult? result){
      this.result = result;
      notifyListeners();
    }


  @override
  void dispose(){
    super.dispose();
  }
}
