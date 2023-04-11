import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ntesco_smart_monitoring/size_config.dart';

class DefectAnalysisDetailsCreateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis-details/create";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: CreateBody());
  }
}

class CreateBody extends StatefulWidget {
  CreateBody({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => new _CreatePageState();
}

class _CreatePageState extends State<CreateBody> {
  File? pickedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo, width: 5),
                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                    ),
                    child: ClipOval(
                      child: pickedImage != null
                          ? Image.file(pickedImage!, width: 170, height: 170, fit: BoxFit.cover)
                          : Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberto_conversi_profile_pic.jpg',
                              width: 170,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_a_photo_outlined, color: Colors.blue, size: 30),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: imagePickerOption,
                icon: const Icon(Icons.add_a_photo_sharp),
                label: const Text('CHOOSE IMAGE'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // if (pickedImage != null) {
                  //   // Đọc nội dung file
                  //   var imageBytes = pickedImage!.readAsBytesSync();

                  //   // Encode dữ liệu sang base64 để gửi đi
                  //   String base64Image = base64Encode(imageBytes);

                  //   // Thực hiện yêu cầu HTTP POST
                  //   var response = await http.post(
                  //     Uri.parse('https://your-api-url'),
                  //     headers: {
                  //       'Content-Type': 'application/json',
                  //     },
                  //     body: jsonEncode(<String, String>{
                  //       'image': base64Image,
                  //     }),
                  //   );

                  //   // Xử lý phản hồi từ API ở đây
                  // } else {
                  //   print('No image selected.');
                  // }
                },
                icon: const Icon(Icons.send),
                label: const Text('UPLOAD IMAGE'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      List<XFile> _imageList = [];

      if (imageSource == ImageSource.camera) {
        var _image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 80, // Chất lượng ảnh (0 - 100)
          maxWidth: 800, // Chiều rộng tối đa của ảnh
          maxHeight: 800, // Chiều cao tối đa của ảnh
          preferredCameraDevice: CameraDevice.front,
        );
        if (_image != null) {
          _imageList.add(_image);
        }
      } else {
        _imageList = await ImagePicker().pickMultiImage(
          imageQuality: 80, // Chất lượng ảnh (0 - 100)
          maxWidth: 800, // Chiều rộng tối đa của ảnh
          maxHeight: 800, // Chiều cao tối đa của ảnh
        );
      }

      print(_imageList.length);
      _uploadImages(_imageList);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _uploadImages(_imageList) async {
    for (int i = 0; i < _imageList.length; i++) {
      final XFile imageFile = _imageList[i];
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      final http.Response response = await http.post(
        Uri.parse('https://portal-api.ntesco.com/v2/common/test'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'source': base64Image,
          'key': 1,
        }),
      );
      print(response.body);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
