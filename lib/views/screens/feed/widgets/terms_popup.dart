import 'package:flutter/material.dart';

import 'package:hp3ki/localization/language_constraints.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/dialog/animated/animated.dart';

class TermsPopup extends StatelessWidget {
  const TermsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext buildContext) { 
        return [
          PopupMenuItem(
            child: Text("block user",
              style: robotoRegular.copyWith(
                color: ColorResources.error,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/report-user"
          ),
          PopupMenuItem(
            child: Text("It's spam",
              style: robotoRegular.copyWith(
                color: ColorResources.error,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/report-user"
          ),
          PopupMenuItem(
            child: Text("Nudity or sexual activity",
              style: robotoRegular.copyWith(
                color: ColorResources.error,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/report-user"
          ),
          PopupMenuItem(
            child: Text("False Information",
              style: robotoRegular.copyWith(
                color: ColorResources.error,
                fontSize: Dimensions.fontSizeSmall
              )
            ), 
            value: "/report-user"
          )
        ];
      },
      onSelected: (route) {
        if(route == "/report-user") {
          showAnimatedDialog(context,
            Dialog(
              child: Container(
                height: 150.0,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    const Icon(Icons.delete,
                      color: ColorResources.black,
                    ),
                    const SizedBox(height: 10.0),
                    Text(getTranslated("ARE_YOU_SURE_REPORT", context),
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(getTranslated("NO", context),
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            )
                          )
                        ), 

                        StatefulBuilder(
                          builder: (BuildContext context, Function s) {
                          return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              ColorResources.error
                            ),
                          ),
                          onPressed: () async { 
                            Navigator.of(context, rootNavigator: true).pop(); 
                          },
                          child: Text(getTranslated("YES", context), 
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall
                            ),
                          ),                           
                        );
                      })

                    ],
                  ) 
                ])
              )
            )
        );
      }
    },
  );
  }
}