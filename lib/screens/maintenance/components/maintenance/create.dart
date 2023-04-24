// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

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

  final _formKey = GlobalKey<FormBuilderState>();
  late Future<SystemConfigModels> _listOfSystemConfigs;
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
          children: <Widget>[
            _headers(context),
            _form(context),
          ],
        ),
      ),
    );
  }

  Widget _headers(BuildContext context) => Container(
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

  Widget _form(BuildContext context) {
    return Expanded(
      child: FutureBuilder<SystemConfigModels>(
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
                groupBy: (element) => "${element.specification.groupSortIndex}. ${element.specification.group}",
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: kPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        value.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                        child: editorForm(value as SystemConfigModel),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget editorForm(SystemConfigModel model) {
    if (model.specification!.dataType == "TextBox") {
      return FormBuilderTextField(
        name: 'fieldIndex-${model.id}',
        decoration: InputDecoration(
          label: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: model.specification?.title.toString()),
                WidgetSpan(child: SizedBox(width: 5.0)),
                TextSpan(
                  text: '(*)',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          hintText: "Vui lòng nhập thông tin...",
        ).applyDefaults(inputDecorationTheme()),
        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      );
    } else if (model.specification!.dataType == "CheckBox1" && model.specification!.dataValues != null) {
      return FormBuilderRadioGroup<String>(
        decoration: InputDecoration(
          labelText: model.specification?.title.toString(),
          labelStyle: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w600),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        name: 'fieldIndex-${model.id}',
        options: [
          ...model.specification!.dataValues!.split(',').map((value) {
            return FormBuilderFieldOption(value: value);
          }),
        ],
        separator: const VerticalDivider(width: 10, thickness: 5),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    } else if (model.specification!.dataType == "CheckBox2" && model.specification!.dataValues != null) {
      return FormBuilderFilterChip<String>(
        name: 'fieldIndex-${model.id}',
        decoration: InputDecoration(
          labelText: model.specification?.title.toString(),
          labelStyle: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w600),
          border: UnderlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
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
    } else
      return SizedBox.shrink();
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
