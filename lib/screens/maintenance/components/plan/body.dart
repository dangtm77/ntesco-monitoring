import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/mt_plan.dart' as MT;
import 'package:ntesco_smart_monitoring/helper/network.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/mt/Plan.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  TextEditingController _keywordForSearchEditingController = TextEditingController();
  late List<int> _projectsCurrent = [];
  late Future<PlanModels> _listOfPlans;

  @override
  void initState() {
    _keywordForSearchEditingController.text = "";
    _listOfPlans = _getListOfPlans();

    NetworkHelper.instance.initialise();
    NetworkHelper.instance.myStream.listen((rs) {
      var result = rs.keys.toList()[0];
      setState(() {
        isOnline = (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) ? true : false;
      });
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<PlanModels> _getListOfPlans() async {
    var sortOptions = [
      {"selector": "fullPath", "desc": "false"},
      {"selector": "startDate", "desc": "true"},
      {"selector": "endDate", "desc": "true"}
    ];
    var filterOptions = [];
    var options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await MT.getList(options);
    if (response.statusCode == 200) {
      var result = PlanModels.fromJson(jsonDecode(response.body));
      return result;
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
            _header(context),
            _listAll(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return TopHeaderSub(
      title: "maintenance.plan_title".tr(),
      subtitle: "maintenance.plan_subtitle".tr(),
      buttonLeft: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pop(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
        ),
      ),
      buttonRight: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pop(context),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Ionicons.filter_outline,
              color: (_projectsCurrent.length > 0) ? kPrimaryColor : Colors.grey.shade500,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
        child: TextField(
          controller: _keywordForSearchEditingController,
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty && value.trim().length > 3) {
                _listOfPlans = _getListOfPlans();
              }
            });
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.all(0.0),
              prefixIcon: Icon(Ionicons.search, size: 22, color: Colors.grey.shade600),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_keywordForSearchEditingController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _keywordForSearchEditingController.clear();
                            _listOfPlans = _getListOfPlans();
                          });
                        },
                        icon: Icon(Ionicons.close_circle, color: Colors.grey.shade500, size: 22),
                      ),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(
                        Ionicons.filter,
                        color: (_projectsCurrent.length > 0) ? kPrimaryColor : Colors.grey.shade500,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade500),
              hintText: "Nhập từ khóa để tìm kiếm..."),
        ),
      ),
    );
  }

  Widget _listAll(BuildContext context) {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        child: (isOnline)
            ? RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _listOfPlans = _getListOfPlans();
                  });
                },
                child: FutureBuilder<PlanModels>(
                  future: _listOfPlans,
                  builder: (BuildContext context, AsyncSnapshot<PlanModels> snapshot) {
                    if (snapshot.hasError)
                      return DataErrorWidget(error: snapshot.error.toString());
                    else {
                      if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active))
                        return LoadingWidget();
                      else {
                        if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(10.0),
                              horizontal: getProportionateScreenWidth(0.0),
                            ),
                            child: AnimationLimiter(
                              child: ListView.separated(
                                itemCount: snapshot.data!.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = snapshot.data!.data.elementAt(index);
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 400),
                                    child: SlideAnimation(
                                      child: FadeInAnimation(child: _item(item)),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                              ),
                            ),
                          );
                        } else
                          return NoDataWidget(message: "Không tìm thấy phiếu đề xuất nào liên quan đến bạn !!!");
                      }
                    }
                  },
                ),
              )
            : NoConnectionWidget(),
      ),
    );
  }

  Widget _item(PlanModel item) {
    if (item.idParent == null)
      return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.stt,
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: getProportionateScreenWidth(12),
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
        title: Text(
          "PROJECT",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenWidth(11),
            fontStyle: FontStyle.italic,
          ),
        ),
        subtitle: Text(
          item.title,
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: getProportionateScreenWidth(11),
            fontStyle: FontStyle.normal,
          ),
        ),
      );
    else {
      double levelSpace = item.level * 25.0;
      return ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.stt,
              style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.normal,
                fontSize: getProportionateScreenWidth(10),
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
        title: Padding(
          padding: EdgeInsets.only(left: levelSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  color: kSecondaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: getProportionateScreenWidth(11),
                  fontStyle: FontStyle.normal,
                ),
              ),
              Text.rich(TextSpan(
                children: [
                  WidgetSpan(child: Icon(Ionicons.calendar_outline, size: 20.0, color: kSecondaryColor)),
                  WidgetSpan(child: SizedBox(width: 2.0)),
                  TextSpan(
                    text: "${DateFormat("dd/MM/yyyy").format(item.startDate!)} - ${DateFormat("dd/MM/yyyy").format(item.endDate!)}",
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.normal,
                      fontSize: getProportionateScreenWidth(10),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
                  // ((item.participantsInfo != null)
                  //     ? TextSpan(
                  //         children: [
                  //           WidgetSpan(child: Icon(Ionicons.people, size: 20.0, color: kSecondaryColor)),
                  //           WidgetSpan(child: SizedBox(width: 2.0)),
                  //           TextSpan(
                  //             text: item.participantsInfo!.map((e) => e.hoTen).join(', '),
                  //             style: TextStyle(
                  //               color: kSecondaryColor,
                  //               fontWeight: FontWeight.normal,
                  //               fontStyle: FontStyle.normal,
                  //               fontSize: getProportionateScreenWidth(10),
                  //             ),
                  //           ),
                  //         ],
                  //       )
                  //     : WidgetSpan(child: SizedBox(width: 00))),
                  ),
            ],
          ),
        ),
        // subtitle: (item.participantsInfo != null)
        //     ? Padding(
        //         padding: EdgeInsets.only(left: levelSpace),
        //         child: ,
        //       )
        //     : null,
        //trailing: _trangThaiIcon,
        //onTap: () => Navigator.pushNamed(context, DetailOfDeXuatScreen.routeName, arguments: {'id': item.id}),
      );
    }
  }
}