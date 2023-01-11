import 'dart:convert';
import 'dart:ui';
import 'package:awesome_select/awesome_select.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';
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

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  TextEditingController _keywordForSearchEditingController = TextEditingController();

  late Future<PhieuDeXuatModels> listPhieuDeXuat;
  late int yearCurrent = DateTime.now().year;
  late List<int> statusCurrent = [0, 1];

  late int pageIndex = 1;
  late int itemPerPage = 15;
  late bool isLoading = false;
  late Future<ThongKeModel> thongKe;

  @override
  void initState() {
    _keywordForSearchEditingController.text = "";
    listPhieuDeXuat = _getListPhieuDeXuat();
    thongKe = _getThongKe(yearCurrent);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<PhieuDeXuatModels> _getListPhieuDeXuat() async {
    var sortOptions = [
      {"selector": "tinhTrang", "desc": "false"},
      {"selector": "ngayTao", "desc": "true"}
    ];
    var filterOptions = [];
    if (statusCurrent.length > 0) {
      var statusGroupFilterOptions = [];
      for (var index = 0; index < statusCurrent.length; index++) {
        if (statusCurrent[index] == 0) {
          statusGroupFilterOptions.add(['isDenLuot', '=', '1']);
        } else if (statusCurrent[index] == 1) {
          statusGroupFilterOptions.add(['tinhTrang', '<=', '1']);
        } else if (statusCurrent[index] == 2) {
          statusGroupFilterOptions.add(['tinhTrang', '=', '2']);
        } else if (statusCurrent[index] == 3) {
          statusGroupFilterOptions.add(['tinhTrang', '=', '3']);
        }

        if (index < statusCurrent.length - 1) statusGroupFilterOptions.add('or');
      }
      filterOptions.add(statusGroupFilterOptions);
    }
    if (_keywordForSearchEditingController.text.isNotEmpty) {
      var searchGroupFilterOptions = [];
      if (filterOptions.length > 0) filterOptions.add('and');
      searchGroupFilterOptions.add(['tieuDe', 'contains', _keywordForSearchEditingController.text.toString()]);
      filterOptions.add(searchGroupFilterOptions);
    }

    print(jsonEncode(filterOptions));
    var options = new LoadOptionsModel(take: itemPerPage * pageIndex, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await funcGetListPhieuDeXuat(yearCurrent, options);

    if (response.statusCode == 200) {
      var result = PhieuDeXuatModels.fromJson(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<ThongKeModel> _getThongKe(int year) async {
    var response = await funGetThongKe(year);
    print(response.body);
    if (response.statusCode == 200) {
      var result = ThongKeModels.fromJson(jsonDecode(response.body)).data.first;
      return new ThongKeModel(
        dangXuLy: result.dangXuLy,
        daDuyet: result.daDuyet,
        tuChoi: result.tuChoi,
        denLuot: result.denLuot,
        tongCong: result.tongCong,
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
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    List<S2Choice<int>> optionsYearFilter = [
                      S2Choice<int>(value: 2021, title: 'Năm 2021'),
                      S2Choice<int>(value: 2022, title: 'Năm 2022'),
                      S2Choice<int>(value: 2023, title: 'Năm 2023'),
                      S2Choice<int>(value: 2024, title: 'Năm 2024'),
                    ];
                    List<S2Choice<int>> optionsStatusFilter = [
                      S2Choice<int>(value: 0, title: 'Chờ tôi duyệt'),
                      S2Choice<int>(value: 1, title: 'Đang xử lý'),
                      S2Choice<int>(value: 2, title: 'Đã phê duyệt'),
                      S2Choice<int>(value: 3, title: 'Bị từ chối'),
                      S2Choice<int>(value: 4, title: 'Tất cả phiếu')
                    ];
                    return Scrollbar(
                        child: ListView(
                      addAutomaticKeepAlives: true,
                      children: <Widget>[
                        Expanded(
                            child: SmartSelect<int>.single(
                          title: 'Xem theo năm',
                          choiceItems: optionsYearFilter,
                          onChange: (state) => setState(() => yearCurrent = state.value),
                          selectedValue: yearCurrent,
                          modalType: S2ModalType.popupDialog,
                          modalHeader: true,
                          tileBuilder: (context, state) {
                            return S2Tile.fromState(
                              state,
                              isTwoLine: true,
                            );
                          },
                        )),
                        Expanded(
                            child: SmartSelect<int>.multiple(
                          title: 'Xem theo tình trạng',
                          choiceItems: optionsStatusFilter,
                          onChange: (state) => setState(() {
                            statusCurrent = state.value;
                            pageIndex = 1;
                          }),
                          selectedValue: statusCurrent,
                          choiceType: S2ChoiceType.chips,
                          modalType: S2ModalType.popupDialog,
                          modalHeader: true,
                          tileBuilder: (context, state) {
                            return S2Tile.fromState(
                              state,
                              isTwoLine: true,
                            );
                          },
                        )),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DefaultButton(
                                text: "Xác nhận",
                                press: () {
                                  setState(() {
                                    _keywordForSearchEditingController.text = "";
                                    listPhieuDeXuat = _getListPhieuDeXuat();
                                    thongKe = _getThongKe(yearCurrent);
                                  });
                                  Navigator.pop(context);
                                }),
                          ),
                        )
                      ],
                    ));
                  },
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [Icon(Icons.manage_search, color: kPrimaryColor, size: 40)],
                ),
              ),
            ),
            thongkeContainer(),
            searchContainer(),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      setState(() {
                        pageIndex = pageIndex + 1;
                        listPhieuDeXuat = _getListPhieuDeXuat();
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
                      builder: (BuildContext context, AsyncSnapshot<PhieuDeXuatModels> snapshot) {
                        if (snapshot.hasError)
                          return DataErrorWidget(error: snapshot.error.toString());
                        else {
                          if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) &&
                              !isLoading)
                            return LoadingWidget();
                          else {
                            if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                              return Column(children: [
                                Expanded(
                                  child: AnimationLimiter(
                                    child: ListView.separated(
                                      itemCount: snapshot.data!.data.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        var item = snapshot.data!.data.elementAt(index);
                                        return AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration: const Duration(milliseconds: 375),
                                          child: SlideAnimation(
                                            child: FadeInAnimation(child: phieuDeXuatItem(item)),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                                    ),
                                  ),
                                ),
                              ]);
                            } else {
                              return NoDataWidget(message: "Không tìm thấy phiếu đề xuất liên quan nào !!!");
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
                    Text("Đang tải thêm $itemPerPage dòng dữ liệu...")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container searchContainer() {
    return Container(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: TextField(
          controller: _keywordForSearchEditingController,
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty && value.trim().length > 3) listPhieuDeXuat = _getListPhieuDeXuat();
            });
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade300,
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade600,
              ),
              suffixIcon: _keywordForSearchEditingController.text.isNotEmpty
                  ? IconButton(
                      onPressed: _keywordForSearchEditingController.clear,
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              hintText: "Nhập từ khóa để tìm kiếm..."),
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
          builder: (BuildContext context, AsyncSnapshot<ThongKeModel> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData)
              return Text('Đang tải ...');
            else
              return Tags(
                itemCount: 5,
                itemBuilder: (int index) {
                  var list = [
                    {'value': snapshot.data!.denLuot.toString(), 'text': "Chờ tôi"},
                    {'value': snapshot.data!.dangXuLy.toString(), 'text': "Đang xử lý"},
                    {'value': snapshot.data!.daDuyet.toString(), 'text': "Đã duyệt"},
                    {'value': snapshot.data!.tuChoi.toString(), 'text': "Từ chối"},
                    {'value': snapshot.data!.tongCong.toString(), 'text': "Tổng"},
                  ];
                  var valueItemTag = int.parse(list.elementAt(index)['value'].toString());
                  var textItemTag = list.elementAt(index)['text'].toString();
                  return ItemTags(
                    index: index,
                    title: "$textItemTag " + (valueItemTag > 0 ? "(${NumberHelper.formatShort(valueItemTag)})" : ""),
                    textStyle: TextStyle(fontSize: 13.0),
                    active: statusCurrent.contains(index),
                    activeColor: kPrimaryColor,
                    color: Colors.white,
                    pressEnabled: true,
                    onPressed: (i) {
                      setState(() {
                        if (i.active && !statusCurrent.contains(i.index)) statusCurrent.add(i.index);
                        if (!i.active && statusCurrent.contains(i.index)) statusCurrent.remove(i.index);

                        isLoading = false;
                        pageIndex = 1;
                        listPhieuDeXuat = _getListPhieuDeXuat();
                      });
                    },
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
      case 3:
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
          style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.normal, fontSize: 12, fontStyle: FontStyle.italic),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (item.isQuanTrong ? "[QUAN TRỌNG] " : "").toString() + item.tieuDe.toString(),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
              style: TextStyle(color: Colors.black87, fontSize: 15.0, fontWeight: FontWeight.w600),
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
                  TextSpan(text: StringHelper.toShortName(item.nguoiTaoInfo.hoTen.toString()), style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
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
                  TextSpan(text: DateFormat("hh:mm dd/MM/yyyy").format(item.ngayTao), style: TextStyle(color: kSecondaryColor, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
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
