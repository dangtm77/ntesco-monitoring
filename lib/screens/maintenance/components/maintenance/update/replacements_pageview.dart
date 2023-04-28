// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ntesco_smart_monitoring/screens/maintenance/components/maintenance/update/replacements/update.dart';

import '../../../../../components/default_button.dart';
import '../../../../../components/state_widget.dart';
import '../../../../../constants.dart';
import '../../../../../models/mt/SystemReportModel.dart';
import '../../../../../models/mt/SystemReportReplacementsModel.dart';
import '../../../../../repository/mt/systyem_report_replacements.dart';
import '../../../../../size_config.dart';
import 'replacements/create.dart';

class ReplacementPageView extends StatefulWidget {
  final int id;
  final SystemReportModel model;
  const ReplacementPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<ReplacementPageView> createState() => _ReplacementPageViewState(id, model);
}

class _ReplacementPageViewState extends State<ReplacementPageView> {
  final int id;
  final SystemReportModel model;
  _ReplacementPageViewState(this.id, this.model);

  late bool _isLoading = false;
  late Future<SystemReportReplacementsModels> _listOfSystemReportReplacements;

  @override
  void initState() {
    _isLoading = false;
    _listOfSystemReportReplacements = MaintenanceSystemReportReplacementsRepository.getList(model.id);
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = false;
      _listOfSystemReportReplacements = MaintenanceSystemReportReplacementsRepository.getList(model.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<SystemReportReplacementsModels>(
                future: _listOfSystemReportReplacements,
                builder: (BuildContext context, AsyncSnapshot<SystemReportReplacementsModels> snapshot) {
                  if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                  if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !_isLoading) return LoadingWidget();
                  if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty))
                    return NoDataWidget(
                      subtitle: "Vui lòng kiểm tra lại các điều kiện lọc hoặc liên hệ quản trị viên",
                      button: OutlinedButton.icon(onPressed: _refresh, icon: Icon(Ionicons.refresh, size: 24.0), label: Text('Refresh')),
                    );
                  else
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
                              child: SlideAnimation(child: FadeInAnimation(child: _item(item))),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) => const Divider(color: kPrimaryColor),
                        ),
                      ),
                    );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(10.0),
              horizontal: getProportionateScreenWidth(10.0),
            ),
            child: Center(
              child: DefaultButton(
                icon: Icons.add,
                text: 'THÊM THIẾT BỊ CẦN THAY THẾ / SỬA CHỮA',
                press: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => SystemReportReplacementsCreateScreen(id: id),
                ).then((value) async => _refresh()),
              ),
            ),
          )
        ],
      ),
    );
  }

  _item(SystemReportReplacementsModel item) {
    return ListTile(
      leading: Text(item.sortIndex.toString(), style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold)),
      trailing: Text(item.stateOfEmergency! ? "maintenance.system_report_replacements.state_of_emergency.option_01".tr() : "maintenance.system_report_replacements.state_of_emergency.option_02".tr(), style: TextStyle(color: item.stateOfEmergency! ? kWarningColor : kTextColor)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${item.name}", style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal)),
          SizedBox(height: 5.0),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
              children: [
                TextSpan(
                  children: [
                    TextSpan(text: "maintenance.system_report_replacements.quantity.label".tr() + ": ", style: TextStyle(color: kTextColor)),
                    TextSpan(text: "${item.quantity}", style: TextStyle(color: kPrimaryColor)),
                  ],
                ),
                (item.unit != null && item.unit!.length > 0)
                    ? TextSpan(
                        children: [
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: "maintenance.system_report_replacements.unit.label".tr() + ": ", style: TextStyle(color: kTextColor)),
                          TextSpan(text: "${item.unit}", style: TextStyle(color: kPrimaryColor)),
                        ],
                      )
                    : WidgetSpan(child: SizedBox.shrink()),
                (item.model != null && item.model!.length > 0)
                    ? TextSpan(
                        children: [
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: "maintenance.system_report_replacements.model.label".tr() + ": ", style: TextStyle(color: kTextColor)),
                          TextSpan(text: "${item.model}", style: TextStyle(color: kPrimaryColor)),
                        ],
                      )
                    : WidgetSpan(child: SizedBox.shrink()),
              ],
            ),
          ),
          Visibility(
              visible: (item.specifications != null && item.specifications!.length > 0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
                          children: [
                            TextSpan(text: "maintenance.system_report_replacements.specifications.label".tr() + ": ", style: TextStyle(color: kTextColor)),
                            TextSpan(text: "${item.specifications}", style: TextStyle(color: kPrimaryColor)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => SystemReportReplacementsUpdateScreen(id: item.id),
      ).then((value) async => _refresh()),
    );
  }
}
