// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/screens/maintenance/components/defect_analysis/update.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

import '../../../../../../components/default_button.dart';
import '../../../../../../components/image_picker_options.dart';
import '../../../../../../components/photoview_gallery.dart';
import '../../../../../../components/state_widget.dart';
import '../../../../../../components/top_header.dart';
import '../../../../../../constants.dart';
import '../../../../../../core/common.dart' as Common;
import '../../../../../../core/maintenance.dart' as Maintenance;
import '../../../../../../helper/util.dart';
import '../../../../../../models/LoadOptions.dart';
import '../../../../../../models/common/FileDinhKemModel.dart';
import '../../../../../../models/mt/DefectAnalysisDetailsModel.dart';
import '../../../../../../theme.dart';

class DefectAnalysisDetailsUpdateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis-details/update";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    int id = int.parse(arguments['id'].toString());
    int idDefectAnalysis = int.parse(arguments['idDefectAnalysis'].toString());
    int tabIndex = int.parse(arguments['tabIndex'].toString());
    return Scaffold(drawerScrimColor: Colors.transparent, body: UpdateBody(id: id, idDefectAnalysis: idDefectAnalysis, tabIndex: tabIndex));
  }
}

class UpdateBody extends StatefulWidget {
  final int id;
  final int idDefectAnalysis;
  final int tabIndex;
  UpdateBody({Key? key, required this.id, required this.idDefectAnalysis, required this.tabIndex}) : super(key: key);

  @override
  _UpdateBodyState createState() => new _UpdateBodyState(id, idDefectAnalysis, tabIndex);
}

class _UpdateBodyState extends State<UpdateBody> {
  final int id;
  final int idDefectAnalysis;
  final int tabIndex;
  _UpdateBodyState(this.id, this.idDefectAnalysis, this.tabIndex);

  //Biến check thiết bị có kết nối với internet hay không
  late bool isOnline = false;
  late StreamSubscription<ConnectivityResult> subscription;

  late int _currentIndex = tabIndex;
  late PageController _pageController;
  late Future<DefectAnalysisDetailsModel> _defectAnalysisDetails;

  @override
  void initState() {
    checkConnectivity(null);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) => checkConnectivity(result));
    super.initState();
  }

  Future<void> checkConnectivity(ConnectivityResult? result) async {
    Util.checkConnectivity(result, (status) {
      setState(() {
        isOnline = status;
        _currentIndex = tabIndex;
        _pageController = PageController(initialPage: tabIndex);
        _defectAnalysisDetails = _getDetailOfDefectAnalysisDetails();
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<DefectAnalysisDetailsModel> _getDetailOfDefectAnalysisDetails() async {
    var options = new Map<String, dynamic>();
    options.addAll({"id": id.toString()});
    Response response = await Maintenance.DefectAnalysisDetails_GetDetail(options);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      DefectAnalysisDetailsModel result = DefectAnalysisDetailsModel.fromJson(jsonDecode(response.body));
      return result;
    } else
      throw Exception(response.body);
  }

  @override
  Widget build(_) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _header(_),
            _main(_),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      child: TopHeaderSub(
        title: "common.title_page_update_info".tr().toUpperCase(),
        buttonLeft: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pushNamed(context, DefectAnalysisUpdateScreen.routeName, arguments: {'id': idDefectAnalysis, 'tabIndex': 1}),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
          ),
        ),
      ),
    );
  }

  Widget _main(BuildContext context) => Expanded(
        child: (isOnline)
            ? FutureBuilder<DefectAnalysisDetailsModel>(
                future: _defectAnalysisDetails,
                builder: (BuildContext context, AsyncSnapshot<DefectAnalysisDetailsModel> snapshot) {
                  if (snapshot.hasError) {
                    return DataErrorWidget(error: snapshot.error.toString());
                  } else {
                    if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
                      return LoadingWidget();
                    else {
                      if (snapshot.hasData && snapshot.data != null) {
                        var item = snapshot.data!;
                        return Scaffold(
                          body: SizedBox.expand(
                            child: PageView(
                              controller: _pageController,
                              physics: NeverScrollableScrollPhysics(),
                              onPageChanged: ((value) => setState(() => _currentIndex = value)),
                              children: <Widget>[
                                SummaryPageView(id: item.id, model: item),
                                AttachmentsPageView(id: item.id, model: item),
                              ],
                            ),
                          ),
                          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                          bottomNavigationBar: BottomNavyBar(
                            iconSize: 25,
                            showElevation: false,
                            itemCornerRadius: 10.0,
                            containerHeight: 50.0,
                            selectedIndex: _currentIndex,
                            onItemSelected: (value) {
                              setState(() => _currentIndex = value);
                              _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
                            },
                            items: <BottomNavyBarItem>[
                              BottomNavyBarItem(
                                title: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Thông tin', style: TextStyle(fontSize: kSmallerFontSize)),
                                      Text('CHUNG', style: TextStyle(fontSize: kSmallFontSize, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                icon: Icon(Ionicons.reader_outline),
                                textAlign: TextAlign.center,
                              ),
                              BottomNavyBarItem(
                                title: FittedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Hình ảnh', style: TextStyle(fontSize: kSmallerFontSize)),
                                      Text('Đính kèm', style: TextStyle(fontSize: kSmallFontSize, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                icon: Icon(Ionicons.images_outline),
                                textAlign: TextAlign.center,
                              ),
                              //BottomNavyBarItem(title: Text('Khác'), icon: Icon(Ionicons.ellipsis_horizontal_circle_outline), textAlign: TextAlign.center),
                            ],
                          ),
                        );
                      } else
                        return NoDataWidget();
                    }
                  }
                },
              )
            : NoConnectionWidget(),
      );
}

class SummaryPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisDetailsModel model;

  const SummaryPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<SummaryPageView> createState() => _SummaryPageViewState(id, model);
}

class _SummaryPageViewState extends State<SummaryPageView> {
  final int id;
  final DefectAnalysisDetailsModel model;

  _SummaryPageViewState(this.id, this.model);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                autoFocusOnValidationFailure: true,
                initialValue: {
                  'partName': model.partName,
                  'partQuantity': model.partQuantity.toString(),
                  'partManufacturer': model.partManufacturer,
                  'partModel': model.partModel,
                  'partSpecifications': model.partSpecifications,
                  'analysisProblemCause': model.analysisProblemCause,
                  'solution': model.solution,
                  'departmentInCharge': model.departmentInCharge,
                  'executionTime': model.executionTime,
                  'note': model.note,
                },
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    editorForm("partName"),
                    SizedBox(height: 20),
                    editorForm("partManufacturer"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: editorForm("partQuantity")),
                        SizedBox(width: 20),
                        Expanded(child: editorForm("partModel")),
                      ],
                    ),
                    SizedBox(height: 20),
                    editorForm("partSpecifications"),
                    SizedBox(height: 20),
                    editorForm("analysisProblemCause"),
                    SizedBox(height: 20),
                    editorForm("solution"),
                    SizedBox(height: 20),
                    editorForm("departmentInCharge"),
                    SizedBox(height: 20),
                    editorForm("executionTime"),
                    SizedBox(height: 20),
                    editorForm("note"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: DefaultButton(text: 'Hủy bỏ', icon: Icons.delete_forever, color: Colors.red, press: () async => deleteFunc(context, model))),
                        SizedBox(width: 10),
                        Expanded(child: DefaultButton(text: 'Cập nhật', icon: Icons.check_rounded, color: kPrimaryColor, press: () async => submitFunc(context))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editorForm(key) {
    switch (key) {
      case "partName":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Thông tin thiết bị'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "partManufacturer":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            labelText: 'Nhà sản xuất',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      case "partQuantity":
        return FormBuilderTextField(
          name: key,
          valueTransformer: (value) => int.parse(value!),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            labelText: 'Số lượng thiết bị',
          ).applyDefaults(inputDecorationTheme()),
        );
      case "partModel":
        return FormBuilderTextField(
          name: key,
          decoration: const InputDecoration(
            labelText: 'Loại',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      case "partSpecifications":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Thông số kỹ thuật',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      case "analysisProblemCause":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Phân tích sự cố'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "solution":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Giải pháp khắc phục sự cố'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "departmentInCharge":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Nhân sự / Phòng ban phụ trách'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "executionTime":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Vui lòng nhập thông tin...",
            label: Text.rich(TextSpan(
              children: [
                TextSpan(text: 'Thời gian thực hiện / xử lý'),
                TextSpan(text: ' (*)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            )),
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
      case "note":
        return FormBuilderTextField(
          name: key,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Ghi chú khác',
            hintText: "Vui lòng nhập thông tin...",
          ).applyDefaults(inputDecorationTheme()),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Future<void> submitFunc(BuildContext context) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
      var defectAnalysisDetailsModel = {
        'partName': _formKey.currentState?.fields['partName']?.value,
        'partQuantity': _formKey.currentState?.fields['partQuantity']?.value,
        'partManufacturer': _formKey.currentState?.fields['partManufacturer']?.value,
        'partModel': _formKey.currentState?.fields['partModel']?.value,
        'partSpecifications': _formKey.currentState?.fields['partSpecifications']?.value,
        'analysisProblemCause': _formKey.currentState?.fields['analysisProblemCause']?.value,
        'solution': _formKey.currentState?.fields['solution']?.value,
        'departmentInCharge': _formKey.currentState?.fields['departmentInCharge']?.value,
        'executionTime': _formKey.currentState?.fields['executionTime']?.value,
        'note': _formKey.currentState?.fields['note']?.value,
      };
      await Maintenance.DefectAnalysisDetails_Update(id, defectAnalysisDetailsModel).then((response) {
        ProgressHud.of(context)?.dismiss();
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Util.showNotification(context, null, "Đã thực hiện cập nhật thông tin thành công", ContentType.success, 3);
        } else {
          Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }
      }).catchError((error, stackTrace) {
        ProgressHud.of(context)?.dismiss();
        Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
      });
    }
  }

  Future<void> deleteFunc(BuildContext context, DefectAnalysisDetailsModel item) async {
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
        await Maintenance.DefectAnalysisDetails_Delete(model.id).then((response) {
          ProgressHud.of(context)?.dismiss();
          if (response.statusCode >= 200 && response.statusCode <= 299)
            Navigator.pushNamed(context, DefectAnalysisUpdateScreen.routeName, arguments: {'id': item.idDefectAnalysis, 'tabIndex': 1});
          else
            Util.showNotification(context, null, response.body, ContentType.failure, 5);
        }).catchError((error, stackTrace) {
          Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
        });
      }
    });
  }
}

class AttachmentsPageView extends StatefulWidget {
  final int id;
  final DefectAnalysisDetailsModel model;
  const AttachmentsPageView({Key? key, required this.id, required this.model}) : super(key: key);

  @override
  State<AttachmentsPageView> createState() => _AttachmentsPageViewState(id, model);
}

class _AttachmentsPageViewState extends State<AttachmentsPageView> {
  final int id;
  final DefectAnalysisDetailsModel model;

  _AttachmentsPageViewState(this.id, this.model);

  late int pageIndex = 1;
  late int itemPerPage = 15;
  late bool isLoading = false;
  late Future<FileDinhKemModels> _listOfFileDinhKems;

  Future<FileDinhKemModels> _getListFileDinhKems() async {
    try {
      List<dynamic> sortOptions = [];
      List<dynamic> filterOptions = [];
      LoadOptionsModel options = new LoadOptionsModel(take: itemPerPage * pageIndex, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
      Response response = await Maintenance.DefectAnalysisDetails_WithFileDinhKem_GetList(model.id, options.toMap());
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        FileDinhKemModels result = FileDinhKemModels.fromJson(jsonDecode(response.body));
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
    _listOfFileDinhKems = _getListFileDinhKems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  setState(() {
                    pageIndex = pageIndex + 1;
                    _listOfFileDinhKems = _getListFileDinhKems();
                    isLoading = true;
                  });
                }
                return true;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = false;
                    _listOfFileDinhKems = _getListFileDinhKems();
                  });
                },
                child: FutureBuilder<FileDinhKemModels>(
                  future: _listOfFileDinhKems,
                  builder: (BuildContext context, AsyncSnapshot<FileDinhKemModels> snapshot) {
                    if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
                    if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active) && !isLoading) return LoadingWidget();
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10.0),
                        horizontal: getProportionateScreenWidth(0.0),
                      ),
                      child: AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
                          itemCount: snapshot.data!.data.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              delay: const Duration(milliseconds: 100),
                              duration: const Duration(milliseconds: 500),
                              columnCount: 4,
                              child: SlideAnimation(
                                child: FadeInAnimation(child: _item(index, snapshot.data!.data)),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(int index, List<FileDinhKemModel> list) {
    if (index >= list.length)
      return GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ImagePickerOptions(
              callBack: (List<XFile> _image) {
                submitFunc(model.id, _image);
              },
            );
          },
        ),
        child: Card(
          elevation: 8,
          margin: EdgeInsets.all(7),
          color: kPrimaryColor,
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_outlined, size: 25.0, color: Colors.white),
                SizedBox(height: 5),
                Text("Chọn hình ảnh", style: TextStyle(color: Colors.white, fontSize: kSmallFontSize), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
    else {
      FileDinhKemModel item = list.elementAt(index);
      return Stack(children: [
        Card(
          elevation: 8,
          margin: EdgeInsets.all(7),
          child: CachedNetworkImage(
            imageUrl: Common.System_DowloadFile_ByID(item.id, 'view'),
            imageBuilder: (context, imageProvider) => GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoViewGalleryScreen(imageUrls: [Common.System_DowloadFile_ByID(item.id, 'view')], initialIndex: 0))),
              child: Container(
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
        Positioned(
          top: 0.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () async => deleteFunc(item.id),
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Color.fromARGB(228, 244, 67, 54),
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ]);
    }
  }

  Future<void> submitFunc(int key, List<XFile> _imageList) async {
    try {
      var pictures = [];
      for (XFile file in _imageList) {
        List<int> imageBytes = await file.readAsBytes();
        pictures.add(base64Encode(imageBytes));
      }

      var model = <String, dynamic>{
        'key': key,
        'pictures': pictures,
      };

      ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
      await Maintenance.DefectAnalysisDetails_WithFileDinhKem_Create(model).then((response) {
        ProgressHud.of(context)?.dismiss();
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Util.showNotification(context, null, 'Tải hình ảnh đính kèm thành công', ContentType.success, 3);
          setState(() {
            isLoading = false;
            _listOfFileDinhKems = _getListFileDinhKems();
          });
        } else
          Util.showNotification(context, null, response.body, ContentType.failure, 5);
      }).catchError((error, stackTrace) {
        ProgressHud.of(context)?.dismiss();
        Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
      });
    } on Exception catch (e) {
      ProgressHud.of(context)?.dismiss();
      Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: ${e.toString()}", ContentType.failure, 5);
    }
  }

  Future<void> deleteFunc(int key) async {
    try {
      ProgressHud.of(context)?.show(ProgressHudType.loading, "Vui lòng chờ...");
      await Maintenance.DefectAnalysisDetails_WithFileDinhKem_Delete(key).then((response) {
        ProgressHud.of(context)?.dismiss();
        if (response.statusCode >= 200 && response.statusCode <= 299) {
          Util.showNotification(context, null, 'Xóa bỏ hình ảnh đính kèm thành công', ContentType.success, 3);
          setState(() {
            isLoading = false;
            _listOfFileDinhKems = _getListFileDinhKems();
          });
        } else
          Util.showNotification(context, null, response.statusCode.toString(), ContentType.failure, 5);
      }).catchError((error, stackTrace) {
        ProgressHud.of(context)?.dismiss();
        Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: $error", ContentType.failure, 5);
      });
    } on Exception catch (e) {
      ProgressHud.of(context)?.dismiss();
      Util.showNotification(context, null, "Có lỗi xảy ra. Chi tiết: ${e.toString()}", ContentType.failure, 5);
    }
  }
}
