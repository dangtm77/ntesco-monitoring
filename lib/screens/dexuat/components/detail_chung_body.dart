// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuat.dart';

class DetailChungBody extends StatefulWidget {
  final int id;
  final PhieuDeXuatModel? phieuDeXuat;

  const DetailChungBody({Key? key, required this.id, this.phieuDeXuat}) : super(key: key);

  @override
  _DetailChungBodyPageState createState() => new _DetailChungBodyPageState(id, phieuDeXuat);
}

class _DetailChungBodyPageState extends State<DetailChungBody> {
  final int id;
  final PhieuDeXuatModel? phieuDeXuat;

  _DetailChungBodyPageState(this.id, this.phieuDeXuat);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tieuDeController = TextEditingController();

  @override
  void initState() {
    _tieuDeController.text = phieuDeXuat!.tieuDe;
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
                decoration: InputDecoration(
                  hintText: 'What do people call you?',
                  labelText: 'Name *',
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "CVV",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "MM/YY",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              )
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
