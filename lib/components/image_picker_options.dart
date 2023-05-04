import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ntesco_smart_monitoring/constants.dart';

class ImagePickerOptions extends StatefulWidget {
  final Function callBack;
  const ImagePickerOptions({Key? key, required this.callBack}) : super(key: key);

  @override
  State<ImagePickerOptions> createState() => _ImagePickerOptionsState(callBack);
}

class _ImagePickerOptionsState extends State<ImagePickerOptions> {
  final Function callBack;

  _ImagePickerOptionsState(this.callBack);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  "Chọn hình ảnh đính kèm từ ...",
                  style: TextStyle(fontSize: kNormalFontSize, fontWeight: FontWeight.bold, color: kTextColor),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: kPrimaryColor),
                          onPressed: () async {
                            var _image = await ImagePicker().pickImage(
                              source: ImageSource.camera,
                              imageQuality: UPLOAD_IMAGE_QUALITY,
                              maxWidth: UPLOAD_IMAGE_WIDTH_MAX,
                              maxHeight: UPLOAD_IMAGE_HEIGHT_MAX,
                              preferredCameraDevice: CameraDevice.front,
                            );
                            if (_image != null) {
                              callBack([_image]);
                              Navigator.pop(context);
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera, color: Colors.white, size: 60),
                              SizedBox(height: 10),
                              Text('Từ Camera', style: TextStyle(fontSize: kNormalFontSize, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: TextButton(
                          style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: kPrimaryColor),
                          onPressed: () async {
                            var _images = await ImagePicker().pickMultiImage(
                              imageQuality: UPLOAD_IMAGE_QUALITY,
                              maxWidth: UPLOAD_IMAGE_WIDTH_MAX,
                              maxHeight: UPLOAD_IMAGE_HEIGHT_MAX,
                            );
                            if (_images.length > 0) {
                              callBack(_images);
                              Navigator.pop(context);
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, color: Colors.white, size: 60),
                              SizedBox(height: 10),
                              Text('Từ thư viện', style: TextStyle(fontSize: kNormalFontSize, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
