import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/state_widget.dart';
import '../../../../components/top_header.dart';
import '../../../../constants.dart';
import '../../../../models/common/ProjectModel.dart';
import '../../../../repository/common/projects.dart';
import '../../../../size_config.dart';
import '../../../../theme.dart';

class MaintenanceCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: _MaintenanceCreateBody());
  }
}

class _MaintenanceCreateBody extends StatefulWidget {
  _MaintenanceCreateBody({Key? key}) : super(key: key);

  @override
  _MaintenanceCreateBodyState createState() => new _MaintenanceCreateBodyState();
}

class _MaintenanceCreateBodyState extends State<_MaintenanceCreateBody> {
  final _formKey = GlobalKey<FormBuilderState>();
  late Future<ProjectModels> _listOfProjects;
  late int _projectCurrent = 0;

  Future<void> _getLocalStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _projectCurrent = prefs.getInt('MAINTENANCE-IDPROJECT') ?? 0;
    });
  }

  @override
  void initState() {
    _listOfProjects = CommonTepository.getListProjects(null);
    _getLocalStore();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          subtitle: "maintenance.maintenance.create_subtitle".tr(),
          buttonLeft: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => Navigator.pop(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
            ),
          ),
          // buttonRight: InkWell(
          //   borderRadius: BorderRadius.circular(15),
          //   onTap: () async => submitFunc(context),
          //   child: Stack(
          //     clipBehavior: Clip.none,
          //     children: [Icon(Ionicons.save_outline, color: kPrimaryColor, size: 30.0)],
          //   ),
          // ),
        ),
      );

  Widget _form(BuildContext context) => Expanded(
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
                    'idProject': _projectCurrent != 0 ? _projectCurrent : null,
                  },
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                        future: _listOfProjects,
                        builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
                          if (snapshot.hasError)
                            return DataErrorWidget(error: snapshot.error.toString());
                          else if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active && !snapshot.hasData))
                            return CircularProgressIndicator();
                          else
                            return FormBuilderDropdown<int>(
                              name: 'idProject',
                              menuMaxHeight: getProportionateScreenHeight(SizeConfig.screenHeight / 2),
                              decoration: InputDecoration(
                                label: Text.rich(TextSpan(children: [TextSpan(text: 'Dự án / Công trình'), WidgetSpan(child: SizedBox(width: 5.0)), TextSpan(text: '(*)', style: TextStyle(color: Colors.red))])),
                                hintText: "Vui lòng chọn thông tin...",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => _formKey.currentState!.fields['idProject']?.didChange(null),
                                ),
                              ).applyDefaults(inputDecorationTheme()),
                              items: snapshot.data!.data
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item.id,
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: "${item.name}", style: TextStyle(fontWeight: FontWeight.w600)),
                                            WidgetSpan(child: SizedBox(width: 5.0)),
                                            TextSpan(text: "(${item.location})", style: TextStyle(fontStyle: FontStyle.italic)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              // onChanged: (dynamic val) {
                              //   if (val != null)
                              //     setState(() {
                              //       idSystemIsEnable = true;
                              //       _listOfSystems = _getListSystems(val);
                              //     });
                              // },
                              valueTransformer: (val) => val,
                              validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                            );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
