// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ntesco_smart_monitoring/models/mt/SystemConfigModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ntesco_smart_monitoring/repository/mt/systems.dart';

import '../../../../components/state_widget.dart';
import '../../../../components/top_header.dart';
import '../../../../constants.dart';
import '../../../../models/common/ProjectModel.dart';
import '../../../../models/mt/SystemModel.dart';
import '../../../../models/mt/SystemReportReplacementModel.dart';
import '../../../../repository/common/projects.dart';
import '../../../../repository/mt/systemConfigs.dart';
import '../../../../size_config.dart';
import '../../../../theme.dart';

class MaintenanceCreateScreen extends StatelessWidget {
  final SystemModel systemModel;
  const MaintenanceCreateScreen({Key? key, required this.systemModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: _MaintenanceCreateBody(systemModel: systemModel));
  }
}

class _MaintenanceCreateBody extends StatefulWidget {
  final SystemModel systemModel;
  _MaintenanceCreateBody({Key? key, required this.systemModel}) : super(key: key);

  @override
  _MaintenanceCreateBodyState createState() => new _MaintenanceCreateBodyState(systemModel);
}

class _MaintenanceCreateBodyState extends State<_MaintenanceCreateBody> {
  final SystemModel systemModel;
  _MaintenanceCreateBodyState(this.systemModel);

  late int _currentIndex;
  late PageController _pageController;
  final _formKey = GlobalKey<FormBuilderState>();
  late Future<SystemConfigModels> _listOfSystemConfigs;
  late List<SystemReportReplacementModel> _listOfSystemReportReplacement;
  late int _projectCurrent = 0;

  @override
  void initState() {
    _getLocalStore();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getLocalStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = 0;
      _pageController = PageController(initialPage: 0);
      _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;
      _listOfSystemConfigs = MaintenanceSystemConfigsRepository.getListSystemConfigs(systemModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_headers(context), _main(context)],
        ),
      ),
    );
  }

  Widget _headers(BuildContext context) {
    return Container(
      child: TopHeaderSub(
        title: "maintenance.maintenance.create_title".tr(),
        subtitle: systemModel.name.toString(),
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
          onTap: () async => submitFunc(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.save_outline, color: kPrimaryColor, size: 30.0)],
          ),
        ),
      ),
    );
  }

  Widget _main(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: ((value) => setState(() => _currentIndex = value)),
            children: <Widget>[_form(context), _list(context)],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          iconSize: 30,
          showElevation: true,
          itemCornerRadius: 20.0,
          containerHeight: 70.0,
          selectedIndex: _currentIndex,
          onItemSelected: (value) {
            setState(() => _currentIndex = value);
            _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Ionicons.reader_outline),
              textAlign: TextAlign.center,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thông tin', style: TextStyle(fontSize: 15)),
                    Text('CHUNG', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            BottomNavyBarItem(
              icon: Icon(Ionicons.git_branch_outline),
              textAlign: TextAlign.center,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vật liệu cần', style: TextStyle(fontSize: 15)),
                    Text('THAY THẾ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return FutureBuilder<SystemConfigModels>(
      future: _listOfSystemConfigs,
      builder: (BuildContext context, AsyncSnapshot<SystemConfigModels> snapshot) {
        if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
        if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)) return LoadingWidget();
        if (!(snapshot.hasData && snapshot.data!.data.isNotEmpty)) return NoDataWidget();
        return FormBuilder(
          key: _formKey,
          child: AnimationLimiter(
            child: GroupedListView<dynamic, String>(
              elements: snapshot.data!.data,
              groupBy: (element) => "${element.groupSortIndex}. ${element.groupTitle}",
              groupSeparatorBuilder: (String value) => Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: kPrimaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      value.toUpperCase(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              itemBuilder: (BuildContext context, dynamic value) {
                return AnimationConfiguration.staggeredList(
                  position: 0,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _formEditor(value as SystemConfigModel),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _formEditor(SystemConfigModel model) {
    Widget result = SizedBox.shrink();
    Widget _label = Text.rich(
      TextSpan(
        children: [
          TextSpan(text: model.specification!.title.toString()),
          WidgetSpan(child: Visibility(visible: model.isRequired, child: Text(' (*)', style: TextStyle(color: Colors.red)))),
        ],
      ),
    );
    String? _helperText;
    if (model.specification!.helpText != null) _helperText = "Ghi chú: ${model.specification!.helpText}";
    if (model.standardValues != null) _helperText = "${_helperText != null ? '$_helperText\r\n' : ''}Tiêu chuẩn: ${model.standardValues}";

    switch (model.specification!.dataType) {
      case "TextBox":
        result = FormBuilderTextField(
          name: 'fieldIndex-${model.id}',
          decoration: InputDecoration(
            label: _label,
            hintText: "common.hint_text_input".tr(),
            helperText: _helperText,
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
        break;
      case "TextArea":
        result = FormBuilderTextField(
          name: 'fieldIndex-${model.id}',
          maxLines: 5,
          decoration: InputDecoration(
            label: _label,
            hintText: "common.hint_text_input".tr(),
            helperText: _helperText,
          ).applyDefaults(inputDecorationTheme()),
          validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        );
        break;
      case "CheckBox1":
        if (model.specification!.dataValues != null)
          result = FormBuilderRadioGroup<String>(
            decoration: InputDecoration(
              labelText: model.specification?.title.toString(),
              hintText: "common.hint_text_select".tr(),
              helperText: _helperText,
            ).applyDefaults(inputDecorationTheme()),
            name: 'fieldIndex-${model.id}',
            options: [
              ...model.specification!.dataValues!.split(',').map((value) {
                return FormBuilderFieldOption(value: value);
              }),
            ],
            separator: const VerticalDivider(width: 10, thickness: 5),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        break;
      case "CheckBox2":
        if (model.specification!.dataValues != null)
          result = FormBuilderFilterChip<String>(
            name: 'fieldIndex-${model.id}',
            decoration: InputDecoration(
              labelText: model.specification?.title.toString(),
              hintText: "common.hint_text_select".tr(),
              helperText: _helperText,
            ).applyDefaults(inputDecorationTheme()),
            options: [
              ...model.specification!.dataValues!.split(',').map((value) {
                return FormBuilderChipOption(
                  value: value,
                  child: Text(value),
                );
              }),
            ],
            checkmarkColor: kPrimaryColor,
            elevation: 6,
            spacing: 10,
          );
        break;
      case "SelectBox1":
        if (model.specification!.dataValues != null)
          result = FormBuilderFilterChip(
            name: 'fieldIndex-${model.id}',
            decoration: InputDecoration(
              labelText: model.specification?.title.toString(),
              hintText: "common.hint_text_select".tr(),
              helperText: _helperText,
            ).applyDefaults(inputDecorationTheme()),
            options: [
              ...model.specification!.dataValues!.split(',').map((value) {
                return FormBuilderChipOption(
                  value: value,
                  child: Text(value),
                );
              }),
            ],
            checkmarkColor: kPrimaryColor,
            elevation: 6,
            spacing: 10,
            maxChips: 1,
          );
        break;
      case "SelectBox2":
        if (model.specification!.dataValues != null)
          result = FormBuilderFilterChip<String>(
            name: 'fieldIndex-${model.id}',
            decoration: InputDecoration(
              labelText: model.specification?.title.toString(),
              hintText: "common.hint_text_select".tr(),
              helperText: _helperText,
            ).applyDefaults(inputDecorationTheme()),
            options: [
              ...model.specification!.dataValues!.split(',').map((value) {
                return FormBuilderChipOption(
                  value: value,
                  child: Text(value),
                );
              }),
            ],
            checkmarkColor: kPrimaryColor,
            elevation: 6,
            spacing: 10,
          );
        break;
      default:
        break;
    }
    return result;
  }

  Widget _list(BuildContext context) {
    return Center(
      child: Text("1"),
    );
  }

  Future<void> submitFunc(BuildContext context) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {}
    final formState = _formKey.currentState;
    if (formState != null) {
      final fields = formState.fields;
      for (final field in fields.values) {
        print(field.value);
      }
    }
  }
}
