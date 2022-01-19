
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hexcolor/hexcolor.dart'; 

import '../../../components/top_header.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        TopHeaderSub(title: "menu.reports".tr(), subtitle: "menu.reports_subtitle".tr()),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: listAll.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
            ),
            itemBuilder: (ctx, id) {
              return StatesDetailContainer(i: id);
            },
          ),
        ),
      ]),
    ));
  }
}

class StatesDetailContainer extends StatelessWidget {
  final int i;
  const StatesDetailContainer({Key? key, required this.i}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border(),
        borderRadius: BorderRadius.circular(15.0),
        color: HexColor(listAll[i]['bg_color'].toString()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            listAll[i]['title'].toString(),
            style: TextStyle(color: HexColor(listAll[i]['text_color'].toString()), fontSize: 16),
          ),
          Center(
            child: Text(
            listAll[i]['value'].toString(),
            style: TextStyle(color: HexColor(listAll[i]['text_color'].toString()), fontSize: 28, fontWeight: FontWeight.w700),
          ),
          ), 
          Text(
            listAll[i]['unit'].toString(),
            style: TextStyle(color: HexColor(listAll[i]['text_color'].toString()), fontSize: 14),
          ),
        ],
      ),
    );
  }
}


const List<Map<String, dynamic>> listAll = [
  {
    'title': "Turbidity",
    'value': 9999,
    'unit': 'NTU',
    'bg_color': "#0175C2",
    'text_color': "#FFFFFF",
  },
  {
    'title': "Salinity",
    'value': 9999,
    'unit': 'ppm',
    'bg_color': "#0175C2",
    'text_color': "#FFFFFF",
  },
  {
    'title': "Ozone",
    'value': 9999,
    'unit': 'ppm',
    'bg_color': "#0175C2",
    'text_color': "#FFFFFF",
  },
  {
    'title': "Flow outlet",
    'value': 9999,
    'unit': 'm3/hr',
    'bg_color': "#0175C2",
    'text_color': "#FFFFFF",
  },
  {
    'title': "Salinity",
    'value': 9999,
    'unit': 'm3/hr',
    'bg_color': "#0175C2",
    'text_color': "#FFFFFF",
  },
  {
    'title': "Ozone",
    'value': 9999,
    'unit': 'm3/hr',
    'bg_color': "#0175C2",
    'text_color': "#FFFFFF",
  },
];
