
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  const HoleModifyFileButton(),
                  const Spacer(),
                  SizedBox(
                    height: 150,
                    width: 300,
                    child: HoleLengthInputBox(
                      descriptor: 'Feed Rare mm/min', 
                      updateFunction: HolesFeatureState().updateFeedRate, 
                      appStateVariable: HolesFeatureState().feedRate),
                  ),
                  const Spacer(),
                  const HoleFilePickerTap(title: 'File Picker')
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
  ValueNotifier<double> lengthOffset = ValueNotifier(0.5); //mm, 3 dec
  ValueNotifier<double> widthOffset = ValueNotifier(0.5);//mm, 3 dec
  ValueNotifier<double> numHolesLength = ValueNotifier(1);
  ValueNotifier<double> numHolesWidth = ValueNotifier(1); //min 1, max 3
  ValueNotifier<double> spaceBetweenLength = ValueNotifier(0.5); //mm, 3 dec
  ValueNotifier<double> spaceBetweenWidth = ValueNotifier(0.5); //mm, 3 dec
  ValueNotifier<double> feedRate = ValueNotifier(1016); //mm/min
  //TODO: enum option for hole type or diameter

  FilePickerResult? result;

  HolesFeatureState._(){
    log("creating singleton");
  } //cannot be instantiated

  static final HolesFeatureState _instance = HolesFeatureState._();

  factory HolesFeatureState() => _instance;

  void updateLengthOffset(double newOffsetIN){
    lengthOffset.value = num.parse((newOffsetIN * 25.4).toStringAsFixed(3)).toDouble();
    notifyListeners();
  }

  void updateWidthOffset(double newOffsetIN){
    widthOffset.value = num.parse((newOffsetIN *25.4).toStringAsFixed(3)).toDouble();
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

  void updateSpaceBetweenLength(double newGapIN){
    spaceBetweenLength.value = num.parse((newGapIN * 25.4).toStringAsFixed(3)).toDouble();
    notifyListeners();
  }

  void updateSpaceBetweenWidth(double newGapIN){
    spaceBetweenWidth.value = num.parse((newGapIN * 25.4).toStringAsFixed(3)).toDouble();
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

  void updateFeedRate(double newVal){
    feedRate.value = newVal;
    notifyListeners();
  }
}
