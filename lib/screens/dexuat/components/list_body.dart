import 'dart:convert';
import 'dart:ui';
import 'package:awesome_select/awesome_select.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/screens/dexuat/detail_of_dexuat_screen.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/phieudexuat.dart';
import 'package:ntesco_smart_monitoring/helper/number.dart';
import 'package:ntesco_smart_monitoring/helper/string.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ntesco_smart_monitoring/models/Login.dart';
import 'package:ntesco_smart_monitoring/models/dx/DanhMuc.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuatList.dart';
import 'package:ntesco_smart_monitoring/models/dx/ThongKe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  TextEditingController _keywordForSearchEditingController = TextEditingController();

  late Future<PhieuDeXuatListModels> listPhieuDeXuat;
  late Future<ThongKeModel> thongKe;
  late Future<DanhMucModels> listDanhMuc;
  late int yearCurrent = DateTime.now().year;
  late List<int> statusCurrent = [];
  late List<int> danhMucCurrent = [];
  late bool isViewListOwner = false;

  late int pageIndex = 1;
  late int itemPerPage = 15;
  late bool isLoading = false;

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

  Future<PhieuDeXuatListModels> _getListPhieuDeXuat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userCurrent = LoginResponseModel.fromJson(json.decode(prefs.getString('USERCURRENT')!));
    var sortOptions = [
      {"selector": "tinhTrang", "desc": "false"},
      {"selector": "ngayTao", "desc": "true"}
    ];

    var filterOptions = [];
    //FILTER BY STATUS
    if (statusCurrent.isNotEmpty && statusCurrent.length > 0) {
      var statusGroupFilterOptions = [];
      var nguoiTaoGroupFilterOptions = [];
      statusCurrent.forEach((status) {
        switch (status) {
          case 0:
            statusGroupFilterOptions.add(['isDenLuot', '=', '1']);
            statusGroupFilterOptions.add('or');
            break;
          case 1:
            statusGroupFilterOptions.add(['tinhTrang', '<', '2']);
            statusGroupFilterOptions.add('or');
            break;
          case 2:
            statusGroupFilterOptions.add(['tinhTrang', '=', '2']);
            statusGroupFilterOptions.add('or');
            break;
          case 3:
            statusGroupFilterOptions.add(['tinhTrang', '=', '3']);
            statusGroupFilterOptions.add('or');
            break;
          case 4:
            nguoiTaoGroupFilterOptions.add(['nguoiTao', '=', userCurrent.username]);
            break;
        }
      });
      if (statusGroupFilterOptions.length > 0) {
        if (statusGroupFilterOptions.last == 'or') statusGroupFilterOptions.removeAt(statusGroupFilterOptions.length - 1);
        filterOptions.add(statusGroupFilterOptions);
      }

      if (nguoiTaoGroupFilterOptions.length > 0) {
        if (filterOptions.length > 0) filterOptions.add('and');
        filterOptions.add(nguoiTaoGroupFilterOptions);
      }
    }

    //FILTER BY DANHMUC
    if (danhMucCurrent.isNotEmpty && danhMucCurrent.length > 0) {
      var danhMucGroupFilterOptions = [];
      danhMucCurrent.forEach((danhmuc) {
        danhMucGroupFilterOptions.add(['idDanhMuc', '=', danhmuc]);
        danhMucGroupFilterOptions.add("or");
      });
      if (danhMucGroupFilterOptions.length > 0) {
        if (filterOptions.length > 0) filterOptions.add('and');
        if (danhMucGroupFilterOptions.last == "or") danhMucGroupFilterOptions.removeAt(danhMucGroupFilterOptions.length - 1);
        if (danhMucGroupFilterOptions.length > 0) filterOptions.add(danhMucGroupFilterOptions);
      }
    }

    //FILTER BY KEYWORD
    if (_keywordForSearchEditingController.text.isNotEmpty) {
      var searchGroupFilterOptions = [];
      if (filterOptions.length > 0) filterOptions.add('and');
      searchGroupFilterOptions.add(['tieuDe', 'contains', _keywordForSearchEditingController.text.toString()]);
      filterOptions.add(searchGroupFilterOptions);
    }

    print(jsonEncode(filterOptions));
    var options = new LoadOptionsModel(take: itemPerPage * pageIndex, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await getListPhieuDeXuat(yearCurrent, options);

    if (response.statusCode == 200) {
      var result = PhieuDeXuatListModels.fromJson(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<List<S2Choice<int>>> _getListDanhMuc() async {
    var sortOptions = [
      {"selector": "sapXep", "desc": "true"}
    ];
    var filterOptions = [];
    var options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await getListDanhMuc(options);

    if (response.statusCode == 200) {
      var result = DanhMucModels.fromJson(jsonDecode(response.body));

      return S2Choice.listFrom<int, dynamic>(
        source: result.data,
        value: (index, item) => item.id,
        title: (index, item) => item.tieuDe,
        group: (index, item) => item.nhomDanhMuc,
      );
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  Future<ThongKeModel> _getThongKe(int year) async {
    var response = await getDetailThongKe(year);
    if (response.statusCode == 200)
      return ThongKeModels.fromJson(jsonDecode(response.body)).data.first;
    else if (response.statusCode == 401)
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
            topHeaderContainer(),
            //thongkeContainer(),
            //searchContainer(),
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
                        isLoading = false;
                        listPhieuDeXuat = _getListPhieuDeXuat();
                      });
                    },
                    child: FutureBuilder<PhieuDeXuatListModels>(
                      future: listPhieuDeXuat,
                      builder: (BuildContext context, AsyncSnapshot<PhieuDeXuatListModels> snapshot) {
                        if (snapshot.hasError)
                          return DataErrorWidget(error: snapshot.error.toString());
                        else {
                          if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !isLoading)
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
                                          duration: const Duration(milliseconds: 400),
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

  Container topHeaderContainer() {
    return Container(
      child: TopHeaderSub(
        title: "phieudexuat.title".tr(),
        subtitle: "phieudexuat.subtitle".tr(),
        buttonRight: InkWell(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [Icon(Ionicons.filter_circle_outline, color: kPrimaryColor, size: 35.0)],
          ),
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              List<S2Choice<int>> optionsYearFilter = [S2Choice<int>(value: 2021, title: 'Năm 2021'), S2Choice<int>(value: 2022, title: 'Năm 2022'), S2Choice<int>(value: 2023, title: 'Năm 2023'), S2Choice<int>(value: 2024, title: 'Năm 2024')];
              List<S2Choice<int>> optionsStatusFilter = [S2Choice<int>(value: 0, title: 'Chờ tôi duyệt'), S2Choice<int>(value: 1, title: 'Đang xử lý'), S2Choice<int>(value: 2, title: 'Đã phê duyệt'), S2Choice<int>(value: 3, title: 'Bị từ chối'), S2Choice<int>(value: 4, title: 'Phiếu do tôi tạo'), S2Choice<int>(value: 5, title: 'Tất cả phiếu')];
              Future<List<S2Choice<int>>> optionsDanhMucFilter = _getListDanhMuc();

              return Scrollbar(
                child: ListView(
                  addAutomaticKeepAlives: true,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Lọc danh sách phiếu",
                          style: TextStyle(color: kPrimaryColor, fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      child: SmartSelect<int>.single(
                        title: 'Xem theo năm',
                        choiceItems: optionsYearFilter,
                        onChange: (state) => setState(() => yearCurrent = state.value),
                        selectedValue: yearCurrent,
                        modalType: S2ModalType.bottomSheet,
                        modalHeader: true,
                        tileBuilder: (context, state) {
                          return S2Tile.fromState(state, isTwoLine: true);
                        },
                      ),
                    ),
                    FutureBuilder<List<S2Choice<int>>>(
                      initialData: [],
                      future: optionsDanhMucFilter,
                      builder: (context, snapshot) {
                        return SmartSelect<int>.multiple(
                          title: 'Xem theo danh mục',
                          placeholder: "Vui lòng chọn ít nhất 1 danh mục",
                          modalFilter: true,
                          //selectedChoice: [],
                          selectedValue: danhMucCurrent,
                          choiceItems: snapshot.data,
                          choiceGrouped: true,
                          groupBuilder: (context, state, group) {
                            return StickyHeader(
                              header: state.groupHeader(group),
                              content: state.groupChoices(group),
                            );
                          },
                          groupHeaderBuilder: (context, state, group) {
                            return Container(
                              color: kPrimaryColor,
                              padding: const EdgeInsets.all(15),
                              alignment: Alignment.centerLeft,
                              child: S2Text(
                                text: "Nhóm ${group.name}",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                              ),
                            );
                          },
                          modalHeader: true,
                          choiceType: S2ChoiceType.checkboxes,
                          modalType: S2ModalType.bottomSheet,
                          onChange: (state) => setState(() => danhMucCurrent = state.value),
                          tileBuilder: (context, state) {
                            return S2Tile.fromState(
                              state,
                              isTwoLine: true,
                              trailing: state.selected.length > 0
                                  ? CircleAvatar(
                                      radius: 15,
                                      backgroundColor: kPrimaryColor,
                                      child: Text(
                                        '${state.selected.length}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : null,
                              isLoading: snapshot.connectionState == ConnectionState.waiting,
                            );
                          },
                        );
                      },
                    ),
                    Container(
                      child: SmartSelect<int>.multiple(
                        title: 'Xem theo tình trạng',
                        placeholder: "Vui lòng chọn ít nhất 1 tình trạng",
                        choiceItems: optionsStatusFilter,
                        onChange: (state) => setState(() => statusCurrent = state.value),
                        selectedValue: statusCurrent,
                        choiceType: S2ChoiceType.chips,
                        modalType: S2ModalType.bottomSheet,
                        modalHeader: true,
                        tileBuilder: (context, state) {
                          return S2Tile.fromState(
                            state,
                            isTwoLine: true,
                            trailing: state.selected.length > 0
                                ? CircleAvatar(
                                    radius: 15,
                                    backgroundColor: kPrimaryColor,
                                    child: Text(
                                      '${state.selected.length}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DefaultButton(
                          text: "Xác nhận",
                          press: () {
                            print(danhMucCurrent);
                            setState(() {
                              _keywordForSearchEditingController.text = "";
                              listPhieuDeXuat = _getListPhieuDeXuat();
                              thongKe = _getThongKe(yearCurrent);
                              pageIndex = 1;
                              isLoading = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container searchContainer() {
    return Container(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        child: TextField(
          controller: _keywordForSearchEditingController,
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty && value.trim().length > 3) {
                isLoading = false;
                listPhieuDeXuat = _getListPhieuDeXuat();
              }
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
            if (snapshot.connectionState == ConnectionState.waiting)
              return Text('Đang cập nhật ...');
            else
              return Tags(
                itemCount: 6,
                itemBuilder: (int index) {
                  var list = [
                    {'id': 0, 'value': snapshot.data!.denLuot.toString(), 'text': "Chờ tôi duyệt"},
                    {'id': 1, 'value': snapshot.data!.dangXuLy.toString(), 'text': "Đang xử lý"},
                    {'id': 2, 'value': snapshot.data!.daDuyet.toString(), 'text': "Đã duyệt"},
                    {'id': 3, 'value': snapshot.data!.tuChoi.toString(), 'text': "Từ chối"},
                    {'id': 4, 'value': snapshot.data!.khoiTao.toString(), 'text': "Do tôi tạo"},
                    {'id': 5, 'value': snapshot.data!.tongCong.toString(), 'text': "Tổng cộng"},
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

  Slidable phieuDeXuatItem(PhieuDeXuatListModel item) {
    Icon _trangThaiIcon = Icon(Ionicons.hourglass_outline);
    switch (item.tinhTrang.toInt()) {
      case 1:
        _trangThaiIcon = Icon(
          Ionicons.timer_outline,
          color: Colors.amber,
        );
        break;
      case 2:
        _trangThaiIcon = Icon(Ionicons.checkmark_circle_outline, color: Colors.green);
        break;
      case 3:
        _trangThaiIcon = Icon(Icons.block_rounded, color: Colors.red);
        break;
    }

    return Slidable(
      key: const ValueKey(0),
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 2,
            autoClose: true,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            icon: Ionicons.eye_outline,
            label: 'Xem chi tiết',
            onPressed: (context) => Navigator.pushNamed(context, DetailOfDeXuatScreen.routeName, arguments: {'id': item.id}),
          ),
        ],
      ),
      child: ListTile(
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
        trailing: _trangThaiIcon,
        onTap: () => Navigator.pushNamed(context, DetailOfDeXuatScreen.routeName, arguments: {'id': item.id}),
      ),
    );
  }
}
