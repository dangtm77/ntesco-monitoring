// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:badges/badges.dart' as badge;
import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import '../../../../../components/photoview_gallery.dart';
import '../../../../../models/mt/DefectAnalysisDetailsModel.dart';
import '../../../../../repository/mt/defect_analysis_details.dart';
import 'details/create.dart';
import 'details/update.dart';

class DetailsPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisModel model;

  const DetailsPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  _DetailsPageViewState createState() => new _DetailsPageViewState(id, model);
}

class _DetailsPageViewState extends State<DetailsPageView> {
  final int id;
  final DefectAnalysisModel model;
  _DetailsPageViewState(this.id, this.model);

  late bool isLoading = false;
  late Future<DefectAnalysisDetailsModels> _listOfDefectAnalysisDetails;

  @override
  void initState() {
    isLoading = false;
    _listOfDefectAnalysisDetails = MaintenanceDefectAnalysisDetailsRepository.getList(model.id, null);
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = false;
      _listOfDefectAnalysisDetails = MaintenanceDefectAnalysisDetailsRepository.getList(model.id, null);
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
              child: FutureBuilder<DefectAnalysisDetailsModels>(
                future: _listOfDefectAnalysisDetails,
                builder: (BuildContext context, AsyncSnapshot<DefectAnalysisDetailsModels> snapshot) {
                  if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                  if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !isLoading) return LoadingWidget();
                  if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty)) return NoDataWidget();

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
                        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 7.0),
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
                text: 'Thêm thông tin sự cố',
                icon: Icons.add,
                press: () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => DefectAnalysisDetailsCreateScreen(id: id),
                ).then((value) async => _refresh),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _item(DefectAnalysisDetailsModel item) {
    return ListTile(
      onTap: () => showBarModalBottomSheet(
        context: context,
        builder: (_) => Material(
          child: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: [
                      Icon(Ionicons.create_outline, color: kPrimaryColor, size: 20),
                      SizedBox(width: 10.0),
                      Text("common.list_menu_button_update".tr(), style: TextStyle(color: kPrimaryColor, fontSize: kNormalFontSize)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, DefectAnalysisDetailsUpdateScreen.routeName, arguments: {'id': item.id, 'idDefectAnalysis': item.idDefectAnalysis, 'tabIndex': 0});
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Ionicons.trash_bin_outline, color: Colors.red, size: 20),
                      SizedBox(width: 10.0),
                      Text("common.list_menu_button_delete".tr(), style: TextStyle(color: Colors.red, fontSize: kNormalFontSize)),
                    ],
                  ),
                  onTap: () => deleteFunc(item.id),
                ),
              ],
            ),
          ),
        ),
      ),
      isThreeLine: true,
      leading: badge.Badge(
        showBadge: item.pictures!.length > 1,
        badgeContent: Text('${item.pictures!.length}', style: TextStyle(fontSize: 13, color: Colors.white)),
        badgeAnimation: badge.BadgeAnimation.scale(),
        badgeStyle: badge.BadgeStyle(badgeColor: Colors.red),
        child: CachedNetworkImage(
          imageUrl: Common.System_DowloadFile_ByID(((item.pictures != null && item.pictures!.length > 0) ? item.pictures!.first.id : 0), "view"),
          imageBuilder: (context, imageProvider) => GestureDetector(
            //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoViewGalleryScreen(imageUrls: imagesList, initialIndex: 0))),
            child: Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
          placeholder: (context, url) => SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => SizedBox(
            width: 100,
            height: 60,
            child: Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey.shade400,
              ),
              child: Center(child: Text('NO IMAGE', style: TextStyle(fontSize: kSmallFontSize, color: Colors.white))),
            ),
          ),
        ),
      ),
      title: Text(
        "${item.partName}",
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(color: kPrimaryColor, fontSize: kNormalFontSize, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
              children: [
                TextSpan(
                  children: [
                    TextSpan(text: "Số lượng: ", style: TextStyle(color: kTextColor)),
                    TextSpan(text: "${item.partQuantity}", style: TextStyle(color: kPrimaryColor)),
                  ],
                ),
                (item.partManufacturer != null && item.partManufacturer!.length > 0)
                    ? TextSpan(
                        children: [
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: " | ", style: TextStyle(color: kTextColor)),
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: "NSX: ", style: TextStyle(color: kTextColor)),
                          TextSpan(text: "${item.partManufacturer}", style: TextStyle(color: kPrimaryColor)),
                        ],
                      )
                    : WidgetSpan(child: SizedBox.shrink()),
                (item.partModel != null && item.partModel!.length > 0)
                    ? TextSpan(
                        children: [
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: " | ", style: TextStyle(color: kTextColor)),
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: "Model: ", style: TextStyle(color: kTextColor)),
                          TextSpan(text: "${item.partModel}", style: TextStyle(color: kPrimaryColor)),
                        ],
                      )
                    : WidgetSpan(child: SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteFunc(key) async {
    Navigator.of(context).pop();
    showOkCancelAlertDialog(
      context: context,
      title: "XÁC NHẬN THÔNG TIN",
      message: "Bạn có chắc chắn là muốn xóa bỏ thông tin này không?",
      okLabel: "Xóa bỏ",
      cancelLabel: "Đóng lại",
      isDestructiveAction: true,
    ).then((result) async {
      if (result == OkCancelResult.ok) {
        ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
        await Maintenance.DefectAnalysisDetails_Delete(key).then((response) async {
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Util.showNotification(context, 'Xóa bỏ thành công', response.body, ContentType.success, 3);
            _refresh();
          } else
            Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }).catchError((error, stackTrace) {
          ProgressHud.of(context)?.dismiss();
          Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
        });
      }
    });
  }
}
