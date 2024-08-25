import 'package:caden_app2/src/facing_feature/facing_feature_details_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilePickerTap extends StatelessWidget{
  const FilePickerTap({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FacingFeatureState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () async {
              appState.updateFile(
                await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['tap']
                )
              );
            },
            child: const Text("File Picker"),
          )
        ),
        if(appState.result != null)
          Text(
            appState.result?.files.first.name ?? '',
            style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold)
          ),
      ],
    );
  }
  
}

