import 'package:flutter/material.dart';

import 'package:detectable_text_field/detectable_text_field.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';

class MentionsDemo extends StatefulWidget {
  const MentionsDemo({super.key});

  @override
  MentionsDemoState createState() => MentionsDemoState();
}

class MentionsDemoState extends State<MentionsDemo> {

  DetectableTextEditingController controller = DetectableTextEditingController(
    regExp: atSignRegExp,
    detectedStyle: const TextStyle(
      fontSize: Dimensions.fontSizeDefault,
      color: Colors.blue,
    ),
  );

  List<String> suggestions = ["Alice", "Bob", "Charlie"];
  String mentionTrigger = "@";
  String inputText = "";

  void onTextChanged(String text) {
    setState(() {
      inputText = text;
    });
  }

  // NOT PRESERVE @
  // void onSuggestionSelected(String suggestion) {
  //   final cursorPosition = controller.selection.baseOffset;
  //   final mentionIndex = inputText.lastIndexOf(_mentionTrigger, cursorPosition);
    
  //   if (mentionIndex != -1) {
  //     final beforeMention = inputText.substring(0, mentionIndex);
  //     final afterMention = inputText.substring(cursorPosition);
  //     final newText = '$beforeMention$suggestion $afterMention';

  //     controller.text = newText;

  //     // Set cursor position to end of the inserted mention
  //     final newCursorPosition = mentionIndex + suggestion.length + 1;
  //     controller.selection = TextSelection.fromPosition(
  //       TextPosition(offset: newCursorPosition),
  //     );
  //   }
  // }

  // PRESERVE @
  void onSuggestionSelected(String suggestion) {
    final cursorPosition = controller.selection.baseOffset;
    final mentionIndex = inputText.lastIndexOf(mentionTrigger, cursorPosition);

    if (mentionIndex != -1) {
      final beforeMention = inputText.substring(0, mentionIndex);
      final afterMention = inputText.substring(cursorPosition);
      final newText = '$beforeMention$mentionTrigger$suggestion $afterMention';

      controller.text = newText;

      final newCursorPosition = mentionIndex + mentionTrigger.length + suggestion.length + 1;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newCursorPosition),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentions')
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (inputText.contains(mentionTrigger))
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: kElevationToShadow[4]
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: suggestions.map((suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () => onSuggestionSelected(suggestion),
                    );
                  }).toList(),
                ),
              ),

              DetectableTextField(
                controller: controller,
                onChanged: onTextChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorResources.white,
                  contentPadding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: ColorResources.black,
                    ),
                    onPressed: () async {
                    
                    } 
                  ),
                  hintText: '${getTranslated("WRITE_COMMENT", context)} ...',
                  hintStyle: robotoRegular.copyWith(
                    color: ColorResources.greyDarkPrimary,
                    fontSize: Dimensions.fontSizeDefault
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
