import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;

import '../../../../components/state_widget.dart';
import '../../../../constants.dart';
import '../../../../models/LoadOptions.dart';
import '../../../../models/mt/SystemReportsModel.dart';
import '../../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late StreamSubscription<ConnectivityResult> subscription;

  late bool isLoading = false;
  late Future<SystemReportsModels> _listOfSystemReports;

  @override
  void initState() {
    super.initState();
    checkConnectivity(null);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => checkConnectivity(result));
  }

  Future<void> checkConnectivity(ConnectivityResult? result) async {
    Util.checkConnectivity(result, (status) {
      setState(() {
        isOnline = status;
        _listOfSystemReports = _getlistOfSystemReports();
      });
    });
  }

  Future<SystemReportsModels> _getlistOfSystemReports() async {
    List<dynamic> sortOptions = [];
    List<dynamic> filterOptions = [];
    LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    Response response = await Maintenance.SystemReports_GetList(options.toMap());
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      SystemReportsModels result = SystemReportsModels.fromJson(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
      return result;
    } else
      throw Exception(response.body);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
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
      title: "maintenance.title".tr(),
      subtitle: "maintenance.subtitle".tr(),
    );
  }

  Widget _listAll(BuildContext context) {
    return Expanded(
      child: (isOnline)
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    isLoading = true;
                    _listOfSystemReports = _getlistOfSystemReports();
                  });
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = false;
                    _listOfSystemReports = _getlistOfSystemReports();
                  });
                },
                child: FutureBuilder<SystemReportsModels>(
                  future: _listOfSystemReports,
                  builder: (BuildContext context, AsyncSnapshot<SystemReportsModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !isLoading) return LoadingWidget();
                    if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty)) return NoDataWidget(subtitle: "Vui lòng kiểm tra lại điều kiện lọc hoặc liên hệ trực tiếp đến quản trị viên...");

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10.0),
                        horizontal: getProportionateScreenWidth(0.0),
                      ),
                      child: AnimationLimiter(
                          child: GroupedListView<dynamic, String>(
                        elements: snapshot.data!.data,
                        //groupBy: (element) => "${element.project.name} (${element.project.customer})",
                        groupBy: (element) => "${element.idSystem}",
                        groupSeparatorBuilder: (String value) => Container(
                          width: MediaQuery.of(context).size.width,
                          color: kPrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                            child: Text(
                              value,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                        itemBuilder: (BuildContext context, dynamic item) {
                          return AnimationConfiguration.staggeredList(
                            position: 0,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              child: FadeInAnimation(child: Text(item.code)),
                            ),
                          );
                        },
                        separator: Divider(thickness: 1),
                        floatingHeader: false,
                        useStickyGroupSeparators: true,
                      )),
                    );
                  },
                ),
              ),
            )
          : NoConnectionWidget(),
    );
  }
}
