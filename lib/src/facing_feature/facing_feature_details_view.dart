import 'dart:io';

import 'package:caden_app2/src/facing_feature/file_picker_tap.dart';
import 'package:caden_app2/src/facing_feature/length_input_box.dart';
import 'package:caden_app2/src/facing_feature/modify_file_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays detailed information about a SampleItem.
class FacingFeatureDetailsView extends StatelessWidget {
  const FacingFeatureDetailsView({super.key});

  static const routeName = '/facing_item';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FacingFeatureState(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Facing Feature'),
          ),
          body: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FilePickerTap(title: "File Picker")
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LengthInputBox(),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ModifyFileButton()
                )
              ]
            ),
          ),
        ),
      );
  }
}

class FacingFeatureState extends ChangeNotifier {
    FilePickerResult? result;
    double? lengthInches;
    
    void updateFile(FilePickerResult? result){
      this.result = result;
      notifyListeners();
    }

    void updateLength(double? length){
      lengthInches = length;
      notifyListeners();
    }

    void editFile(String newContents){
      String? path = result?.paths.first;
      File file = File(path!);

      file.writeAsStringSync(newContents);
    }
}
