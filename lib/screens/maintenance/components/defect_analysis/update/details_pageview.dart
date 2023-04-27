// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:badges/badges.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:ntesco_smart_monitoring/components/default_button.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/core/maintenance.dart' as Maintenance;
import 'package:ntesco_smart_monitoring/helper/util.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/mt/DefectAnalysisModel.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import '../../../../../components/photoview_gallery.dart';
import '../../../../../models/mt/DefectAnalysisDetailsModel.dart';
import '../details/create.dart';
import '../details/update.dart';

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

  Future<DefectAnalysisDetailsModels> _getListDefectAnalysisDetails() async {
    try {
      List<dynamic> sortOptions = [];
      List<dynamic> filterOptions = [];
      LoadOptionsModel options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      Response response = await Maintenance.DefectAnalysisDetails_GetList(model.id, options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        DefectAnalysisDetailsModels result = DefectAnalysisDetailsModels.fromJson(jsonDecode(response.body));
        setState(() {
          isLoading = false;
        });
        return result;
      } else
        throw Exception(response.body);
    } catch (ex) {
      throw ex;
    }
  }

  @override
  void initState() {
    _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  isLoading = false;
                  _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
                });
              },
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
                text: 'THÊM THÔNG TIN SỰ CỐ',
                press: () => showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => DefectAnalysisDetailsCreateScreen(id: id),
                ).then((value) {
                  setState(() {
                    isLoading = false;
                    _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
                  });
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _item(DefectAnalysisDetailsModel item) {
    List<String> imagesList = (item.pictures != null && item.pictures!.length > 0) ? item.pictures!.map((e) => Common.System_DowloadFile_ByID(e.id, 'view')).toList() : [urlNoImage];

    return ListTile(
      onTap: () => showCupertinoModalBottomSheet(
        context: context,
        builder: (_) => Material(
          child: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  trailing: Icon(Ionicons.arrow_forward, color: kPrimaryColor),
                  title: Row(
                    children: [
                      Icon(Ionicons.create_outline, color: kPrimaryColor),
                      SizedBox(width: 10.0),
                      Text('Xem / Cập nhật / chỉnh sửa thông tin', style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, DefectAnalysisDetailsUpdateScreen.routeName, arguments: {'id': item.id, 'idDefectAnalysis': item.idDefectAnalysis, 'tabIndex': 0});
                  },
                ),
                ListTile(
                  trailing: Icon(Ionicons.arrow_forward, color: kPrimaryColor),
                  title: Row(
                    children: [
                      Icon(Ionicons.trash_bin_outline, color: kPrimaryColor),
                      SizedBox(width: 10.0),
                      Text('Xóa / Hủy bỏ thông tin', style: TextStyle(color: kPrimaryColor, fontSize: 18)),
                    ],
                  ),
                  onTap: () => deleteFunc(item.id),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: Badge(
        showBadge: imagesList.length > 1,
        badgeContent: Text('${imagesList.length}', style: TextStyle(fontSize: 15, color: Colors.white)),
        badgeAnimation: BadgeAnimation.scale(),
        badgeStyle: BadgeStyle(badgeColor: kPrimaryColor),
        child: CachedNetworkImage(
          imageUrl: imagesList.first,
          imageBuilder: (context, imageProvider) => GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoViewGalleryScreen(imageUrls: imagesList, initialIndex: 0))),
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
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${item.partName}", style: TextStyle(color: kPrimaryColor, fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal)),
          SizedBox(height: 5.0),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
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
                          TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
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
                          TextSpan(text: " | ", style: TextStyle(color: kPrimaryColor)),
                          WidgetSpan(child: SizedBox(width: 5.0)),
                          TextSpan(text: "Model: ", style: TextStyle(color: kTextColor)),
                          TextSpan(text: "${item.partModel}", style: TextStyle(color: kPrimaryColor)),
                        ],
                      )
                    : WidgetSpan(child: SizedBox.shrink()),
              ],
            ),
          ),
          Visibility(
              visible: (item.partSpecifications != null && item.partSpecifications!.length > 0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
                          children: [
                            TextSpan(text: "Thông số kỹ thuật: ", style: TextStyle(color: kTextColor)),
                            TextSpan(text: "${item.partSpecifications}", style: TextStyle(color: kPrimaryColor)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ))
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
        await Maintenance.DefectAnalysisDetails_Delete(key).then((response) {
          if (response.statusCode >= 200 && response.statusCode <= 299) {
            Util.showNotification(context, 'Xóa bỏ thành công', response.body, ContentType.success, 3);
            setState(() {
              isLoading = false;
              _listOfDefectAnalysisDetails = _getListDefectAnalysisDetails();
            });
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
