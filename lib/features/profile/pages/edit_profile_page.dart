import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yumshare/features/profile/controllers/profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? imagePath;
  final ProfileController _profileController = Get.find<ProfileController>();

  late TextEditingController usernameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();

  late TextEditingController whatsappController = TextEditingController();
  late TextEditingController facebookController = TextEditingController();
  late TextEditingController twitterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = _profileController.userData.value;

    usernameController = TextEditingController(text: user!.name);
    descriptionController = TextEditingController(text: user.description);
    whatsappController = TextEditingController(text: user.whatsapp);
    facebookController = TextEditingController(text: user.facebook);
    twitterController = TextEditingController(text: user.twitter);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        imagePath = file.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: imagePath != null
                        ? Image.file(File(imagePath!), fit: BoxFit.cover).image
                        : const AssetImage("assets/images/avatar1.png"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _headerText("Username"),
            _inputField(usernameController),

            _headerText("Description"),
            _inputField(descriptionController),

            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Social Media",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 10),

            _headerText("WhatsApp"),
            _inputField(whatsappController),

            _headerText("Facebook"),
            _inputField(facebookController),

            _headerText("Twitter"),
            _inputField(twitterController),

            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: () {
                _profileController.updateProfile(
                  name: usernameController.text.trim(),
                  des: descriptionController.text.trim(),
                  wa: whatsappController.text.trim(),
                  fb: facebookController.text.trim(),
                  tw: twitterController.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _headerText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: 1,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.2)),
      ),
      cursorColor: Colors.red,
      style: const TextStyle(fontSize: 16),
    );
  }
}
