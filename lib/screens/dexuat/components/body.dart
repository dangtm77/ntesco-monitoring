import 'dart:convert';
import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/phieudexuat.dart';
import 'package:ntesco_smart_monitoring/helper/number.dart';
import 'package:ntesco_smart_monitoring/helper/string.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuat.dart';
import 'package:ntesco_smart_monitoring/models/dx/ThongKe.dart';

import '../../../components/top_header.dart';
import '../../home/home_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  late Future<PhieuDeXuatModels> listPhieuDeXuat;
  late int yearCurrent = 2022;
  late int pageIndex = 1;
  late int itemPerPage = 15;
  late bool isLastPage = false;
  late bool isLoading = false;
  late Future<ThongKeModel> thongKe;

  @override
  void initState() {
    listPhieuDeXuat = _getListPhieuDeXuat();
    thongKe = _getThongKe(yearCurrent);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<PhieuDeXuatModels> _getListPhieuDeXuat() async {
    var options = new LoadOptionsModel(
        take: itemPerPage * pageIndex,
        skip: 0,
        sort:
            "[{\"selector\":\"tinhTrang\", \"desc\":\"false\"},{\"selector\":\"ngayTao\", \"desc\":\"true\"}]",
        filter: "[]",
        requireTotalCount: "true");
    var response = await funcGetListPhieuDeXuat(options);

    print(response.body);
    if (response.statusCode == 200) {
      var result = PhieuDeXuatModels.fromJson(jsonDecode(response.body));
      setState(() {
        isLoading = false;
        if (pageIndex == (result.totalCount / itemPerPage).ceil())
          isLastPage = true;
      });
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<ThongKeModel> _getThongKe(int year) async {
    var response = await funGetThongKe(year);
    if (response.statusCode == 200) {
      var result = ThongKeModels.fromJson(jsonDecode(response.body));
      return new ThongKeModel(
        dangXuLy: result.data
            .map((item) => item.dangXuLy)
            .reduce((value, current) => value + current),
        daDuyet: result.data
            .map((item) => item.daDuyet)
            .reduce((value, current) => value + current),
        tuChoi: result.data
            .map((item) => item.tuChoi)
            .reduce((value, current) => value + current),
        denLuot: result.data
            .map((item) => item.denLuot)
            .reduce((value, current) => value + current),
        tongCong: result.data
            .map((item) => item.tongCong)
            .reduce((value, current) => value + current),
      );
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopHeaderSub(
              title: "menu.dexuat".tr(),
              subtitle: "menu.dexuat_subtitle".tr(),
              button: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => Navigator.pushNamed(context, HomeScreen.routeName),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.manage_search, color: kPrimaryColor, size: 40)
                  ],
                ),
              ),
            ),
            thongkeContainer(),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading &&
                        !isLastPage &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                      pageIndex = pageIndex + 1;
                      listPhieuDeXuat = _getListPhieuDeXuat();
                      setState(() {
                        isLoading = true;
                      });
                    }
                    return true;
                  },
                  child: new RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        listPhieuDeXuat = _getListPhieuDeXuat();
                      });
                    },
                    child: FutureBuilder<PhieuDeXuatModels>(
                      future: listPhieuDeXuat,
                      builder: (BuildContext context,
                          AsyncSnapshot<PhieuDeXuatModels> snapshot) {
                        if (snapshot.hasError)
                          return DataErrorWidget(
                              error: snapshot.error.toString());
                        else {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              !snapshot.hasData)
                            return LoadingWidget();
                          else {
                            if (snapshot.hasData &&
                                snapshot.data!.totalCount > 0) {
                              return Column(children: [
                                Expanded(
                                  child: AnimationLimiter(
                                    child: ListView.separated(
                                      itemCount: snapshot.data!.data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var item = snapshot.data!.data
                                            .elementAt(index);
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            child: FadeInAnimation(
                                                child: phieuDeXuatItem(item)),
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    ),
                                  ),
                                ),
                              ]);
                            } else {
                              return NoDataWidget(
                                  message:
                                      "Không tìm thấy bất kỳ thông tin nào");
                            }
                          }
                        }
                      },
                    ),
                  )),
            ),
            Container(
              height: isLoading ? 30.0 : 0,
              color: Colors.transparent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                      height: 10.0,
                      width: 10.0,
                    ),
                    SizedBox(width: 10.0),
                    Text("Đang tải thêm ${itemPerPage} dòng dữ liệu...")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container thongkeContainer() {
    return Container(
      height: 40.0,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FutureBuilder<ThongKeModel>(
          future: thongKe,
          builder:
              (BuildContext context, AsyncSnapshot<ThongKeModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData)
              return Text('Đang tải ...');
            else
              return Tags(
                itemCount: 5,
                itemBuilder: (int index) {
                  var list = [
                    {
                      'value': snapshot.data!.denLuot.toString(),
                      'text': "Chờ tôi"
                    },
                    {
                      'value': snapshot.data!.dangXuLy.toString(),
                      'text': "Đang xử lý"
                    },
                    {
                      'value': snapshot.data!.daDuyet.toString(),
                      'text': "Đã duyệt"
                    },
                    {
                      'value': snapshot.data!.tuChoi.toString(),
                      'text': "Từ chối"
                    },
                    {
                      'value': snapshot.data!.tongCong.toString(),
                      'text': "Tổng"
                    },
                  ];
                  var valueItemTag =
                      int.parse(list.elementAt(index)['value'].toString());
                  var textItemTag = list.elementAt(index)['text'].toString();
                  return ItemTags(
                    index: index,
                    title:
                        "$textItemTag "+ (valueItemTag>0?"(${NumberHelper.formatShort(valueItemTag)})":""),
                    textStyle: TextStyle(fontSize: 13.0),
                  );
                },
                horizontalScroll: true,
                spacing: 4,
                symmetry: false,
                alignment: WrapAlignment.spaceBetween,
              );
          },
        ),
      ),
    );
  }

  ListTile phieuDeXuatItem(PhieuDeXuatModel item) {
    Icon _trangThaiIcon = Icon(Icons.timer_sharp);
    switch (item.tinhTrang.toInt()) {
      case 1:
        _trangThaiIcon = Icon(
          Icons.play_circle_outline_rounded,
          color: Colors.amber,
        );
        break;
      case 2:
        _trangThaiIcon = Icon(Icons.task_alt_rounded, color: Colors.green);
        break;
      case 2:
        _trangThaiIcon = Icon(Icons.block_rounded, color: Colors.red);
        break;
    }

    return ListTile(
        leading: Container(
          padding: EdgeInsets.only(left: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(
                    item.nguoiTaoInfo.anhDaiDien.toString(),
                  )),
            ],
          ),
        ),
        title: Text(
          item.tenDanhMuc,
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
          style: TextStyle(
              color: kSecondaryColor,
              fontWeight: FontWeight.normal,
              fontSize: 12,
              fontStyle: FontStyle.italic),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (item.isQuanTrong ? "[QUAN TRỌNG] " : "").toString() +
                  item.tieuDe.toString(),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
            ),
            Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12),
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.person_add_alt,
                      size: 15.0,
                      color: kSecondaryColor,
                    ),
                  ),
                  WidgetSpan(
                    child: SizedBox(
                      width: 3.0,
                    ),
                  ),
                  TextSpan(
                      text: StringHelper.toShortName(
                          item.nguoiTaoInfo.hoTen.toString()),
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic)),
                  WidgetSpan(
                    child: SizedBox(
                      width: 15.0,
                    ),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.event_available,
                      size: 15.0,
                      color: kSecondaryColor,
                    ),
                  ),
                  WidgetSpan(
                    child: SizedBox(
                      width: 3.0,
                    ),
                  ),
                  TextSpan(
                      text: DateFormat("hh:mm dd/MM/yyyy").format(item.ngayTao),
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            )
          ],
        ),
        trailing: _trangThaiIcon
        // onTap: () async {
        //   var uri = Uri.parse(item.option001.toString());
        //   if (await canLaunchUrl(uri)) await canLaunchUrl(uri);
        // },
        );
  }
}
