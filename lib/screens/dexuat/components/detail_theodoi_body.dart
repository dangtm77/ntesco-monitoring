// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/dx_phieudexuat.dart';
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuatDetail.dart';
import 'package:ntesco_smart_monitoring/models/dx/TheoDoi.dart';
import 'package:timeline_tile/timeline_tile.dart';

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

  late Future<TheoDoiModels> listTheoDoi;

  @override
  void initState() {
    listTheoDoi = _getListTheoDoi();
    super.initState();
  }

  Future<TheoDoiModels> _getListTheoDoi() async {
    var sortOptions = [
      {"selector": "thuTu", "desc": "false"}
    ];
    var filterOptions = [];

    var options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await getListTheoDoi(id, options);
    if (response.statusCode == 200)
      return TheoDoiModels.fromJson(jsonDecode(response.body));
    else
      throw Exception(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("THÔNG TIN TRÌNH TỰ PHÊ DUYỆT", style: TextStyle(color: kTextColor, fontWeight: FontWeight.w700, fontSize: 20.0)),
          ),
          _listOfTheoDoi(context),
        ],
      ),
    );
  }

  Widget _listOfTheoDoi(context) {
    return Expanded(
      child: new RefreshIndicator(
        onRefresh: () async {
          setState(() {
            listTheoDoi = _getListTheoDoi();
          });
        },
        child: FutureBuilder<TheoDoiModels>(
          future: listTheoDoi,
          builder: (BuildContext context, AsyncSnapshot<TheoDoiModels> snapshot) {
            if (snapshot.hasError)
              return DataErrorWidget(error: snapshot.error.toString());
            else {
              if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active))
                return LoadingWidget();
              else {
                if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                  return Column(children: [
                    Expanded(
                      child: AnimationLimiter(
                        child: ListView.separated(
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            //var item = snapshot.data!.data.elementAt(index);
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                child: FadeInAnimation(
                                  child: _itemOfTheoDoi(index, snapshot.data!.data, context),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => TimelineDivider(begin: 0.1, end: 0.9, color: Colors.grey, thickness: 10),
                        ),
                      ),
                    ),
                  ]);
                } else {
                  return NoDataWidget();
                }
              }
            }
          },
        ),
      ),
    );
  }

  Widget _itemOfTheoDoi(index, List<TheoDoiModel> list, context) {
    var item = list.elementAt(index);
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: (index == 0 || index % 2 == 0) ? 0.1 : 0.9,
      isFirst: (index == 0),
      isLast: (index == list.length - 1),
      beforeLineStyle: const LineStyle(color: Colors.grey, thickness: 10),
      afterLineStyle: const LineStyle(color: Colors.grey, thickness: 10),
      indicatorStyle: IndicatorStyle(
        width: 40.0,
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        drawGap: false,
        indicator: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (item.isDuyet == null ? Colors.grey : (item.isDuyet == true ? Colors.green : Colors.red)),
              border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
            ),
            child: Icon(
              (item.isDuyet == null ? Ionicons.time_outline : (item.isDuyet == true ? Ionicons.checkmark_outline : Ionicons.close_outline)),
              color: Colors.white,
              size: 30,
            )),
      ),
      endChild: (index % 2 == 0)
          ? Container(
              alignment: Alignment.centerLeft,
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.only(left: 0),
                  child: Badge(
                    showBadge: item.ghiChu.isNotEmpty,
                    //padding: EdgeInsets.all(5.0),
                    badgeContent: Icon(Icons.insert_comment_sharp, color: Colors.white, size: 13),
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundImage: NetworkImage(item.nguoiDuyetInfo.anhDaiDien.toString()),
                    ),
                  ),
                ),
                title: Text(
                  item.nguoiDuyetInfo.hoTen.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                subtitle: Text(
                  "${item.nguoiDuyetInfo.chucDanh.toString()} - ${item.nguoiDuyetInfo.phongBan.toString()}",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: kTextColor),
                ),
              ))
          : null,
      startChild: (index % 2 != 0)
          ? Container(
              alignment: Alignment.centerRight,
              child: ListTile(
                trailing: Container(
                  padding: EdgeInsets.only(left: 0),
                  child: Badge(
                    showBadge: item.ghiChu.isNotEmpty,
                    //padding: EdgeInsets.all(5.0),
                    badgeContent: Icon(Icons.insert_comment_sharp, color: Colors.white, size: 13),
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundImage: NetworkImage(item.nguoiDuyetInfo.anhDaiDien.toString()),
                    ),
                  ),
                ),
                title: Text(
                  item.nguoiDuyetInfo.hoTen.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kPrimaryColor),
                ),
                subtitle: Text(
                  "${item.nguoiDuyetInfo.chucDanh.toString()} - ${item.nguoiDuyetInfo.phongBan.toString()}",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: kTextColor),
                ),
                onTap: (() => Util.showNotification(context, null, item.ghiChu, ContentType.help, 10)),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
