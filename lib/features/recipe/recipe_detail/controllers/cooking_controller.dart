import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class CookingController extends GetxController {
  final FlutterTts tts = FlutterTts();

  RxInt currentStep = 0.obs;
  RxBool isSpeaking = false.obs;

  @override
  void onInit() {
    super.onInit();
    tts.setLanguage("vi-VN");
    tts.setSpeechRate(0.45);
  }

  Future speak(String text) async {
    isSpeaking.value = true;

    await tts.stop();

    if (_isVietnamese(text)) {
      await tts.setLanguage("vi-VN");
      await tts.setSpeechRate(0.45);
    } else {
      await tts.setLanguage("en-US");
      await tts.setSpeechRate(0.5);
    }

    await tts.speak(text);
  }

  Future stop() async {
    isSpeaking.value = false;
    await tts.stop();
  }

  bool _isVietnamese(String text) {
    final vietnameseRegex = RegExp(r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]');
    return vietnameseRegex.hasMatch(text.toLowerCase());
  }

  @override
  void onClose() {
    tts.stop();
    super.onClose();
  }
}
