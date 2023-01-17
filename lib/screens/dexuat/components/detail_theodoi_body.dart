// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuatDetail.dart';

class DetailTheoDoiBody extends StatefulWidget {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;
  const DetailTheoDoiBody({Key? key, required this.id, this.phieuDeXuat}) : super(key: key);

  @override
  _DetailTheoDoiBodyPageState createState() => new _DetailTheoDoiBodyPageState(id, phieuDeXuat);
}

class _DetailTheoDoiBodyPageState extends State<DetailTheoDoiBody> {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;
  _DetailTheoDoiBodyPageState(this.id, this.phieuDeXuat);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Theo doi")),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
