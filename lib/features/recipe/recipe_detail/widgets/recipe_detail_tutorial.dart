import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class RecipeDetailTutorial {
  late TutorialCoachMark tutorialCoachMark;

  void createTutorial(GlobalKey publishKey, VoidCallback onFinish) {
    tutorialCoachMark = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "publish_icon",
          keyTarget: publishKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Tap here to publish your recipe and let more people see it!",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ],
      colorShadow: Colors.black54,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: onFinish,
    );
  }
}
