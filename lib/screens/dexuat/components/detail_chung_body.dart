import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuatDetail.dart';

class DetailChungBody extends StatefulWidget {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;

  const DetailChungBody({Key? key, required this.id, this.phieuDeXuat}) : super(key: key);

  @override
  _DetailChungBodyPageState createState() => new _DetailChungBodyPageState(id, phieuDeXuat);
}

class _DetailChungBodyPageState extends State<DetailChungBody> {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;

  _DetailChungBodyPageState(this.id, this.phieuDeXuat);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tieuDeController = TextEditingController();
  final TextEditingController _mucDichController = TextEditingController();
  final TextEditingController _noiDungController = TextEditingController();

  final TextEditingController _tuNgayController = TextEditingController();
  final TextEditingController _denNgayController = TextEditingController();
  @override
  void initState() {
    _tieuDeController.text = phieuDeXuat!.tieuDe;
    _mucDichController.text = phieuDeXuat!.mucDich;
    _noiDungController.text = phieuDeXuat!.noiDung;

    _tuNgayController.text = DateFormat('HH:mm dd/MM/yyyy').format(phieuDeXuat!.tuNgay);
    _denNgayController.text = DateFormat('HH:mm dd/MM/yyyy').format(phieuDeXuat!.denNgay);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tieuDeController,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: phieuDeXuat!.tieuDeLabel,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _mucDichController,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: phieuDeXuat!.mucDichLabel,
                  hintText: phieuDeXuat!.mucDichLabel,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _noiDungController,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: phieuDeXuat!.noiDungLabel,
                  hintText: phieuDeXuat!.noiDungLabel,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tuNgayController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: phieuDeXuat!.tuNgayLabel,
                  hintText: phieuDeXuat!.tuNgayLabel,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Ionicons.calendar_outline,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _denNgayController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: phieuDeXuat!.denNgayLabel,
                  hintText: phieuDeXuat!.denNgayLabel,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Ionicons.calendar_outline,
                      color: kPrimaryColor,
                    ),
                    onPressed: () async {
                      DatePicker.showDateTimePicker(
                        context,
                        currentTime: DateTime.now(),
                        locale: LocaleType.vi,
                        onConfirm: (date) {
                          print('confirm $date');
                        },
                      );
                    },
                  ),
                ),
              )
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFormField(
              //         decoration: InputDecoration(
              //             labelText: phieuDeXuat!.tuNgayLabel,
              //             hintText: phieuDeXuat!.tuNgayLabel,
              //             suffixIcon: Icon(
              //               Icons.search,
              //               color: Colors.grey,
              //             )),
              //       ),
              //     ),
              //     const SizedBox(width: 10),
              //     Expanded(
              //       child: TextFormField(
              //         decoration: InputDecoration(
              //           labelText: phieuDeXuat!.denNgayLabel,
              //           hintText: phieuDeXuat!.denNgayLabel,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Validate returns true if the form is valid, or false otherwise.
              //     if (_formKey.currentState!.validate()) {
              //       // If the form is valid, display a snackbar. In the real world,
              //       // you'd often call a server or save the information in a database.
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('Processing Data')),
              //       );
              //     }
              //   },
              //   child: const Text('Submit'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
