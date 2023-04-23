// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ntesco_smart_monitoring/repository/mt/systems.dart';

import '../../../../components/state_widget.dart';
import '../../../../components/top_header.dart';
import '../../../../constants.dart';
import '../../../../models/common/ProjectModel.dart';
import '../../../../models/mt/SystemModel.dart';
import '../../../../repository/common/projects.dart';
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

  late Future<SystemModels> _listOfSystems;
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
      _listOfSystems = MaintenanceSystemTepository.getListSystemsByIDProject(_projectCurrent, null);
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
            _listAll(context),
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
            onTap: () {},
            child: Stack(
              clipBehavior: Clip.none,
              children: [Icon(Ionicons.save_outline, color: kPrimaryColor, size: 30.0)],
            ),
          ),
        ),
      );

  Widget _listAll(BuildContext context) {
    return Expanded(
      child: FutureBuilder<SystemModels>(
        future: _listOfSystems,
        builder: (BuildContext context, AsyncSnapshot<SystemModels> snapshot) {
          if (snapshot.hasError) return DataErrorWidget(error: snapshot.error.toString());
          if ((snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)) return LoadingWidget();
          if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: AnimationLimiter(
                child: ListView.separated(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = snapshot.data!.data.elementAt(index);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 400),
                      child: SlideAnimation(
                        child: FadeInAnimation(child: Text(item.name.toString())),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),
            );
          } else
            return NoDataWidget();
        },
      ),
    );
  }
}
