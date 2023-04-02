import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:ionicons/ionicons.dart';

import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/components/top_header.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/common.dart' as Common;
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:ntesco_smart_monitoring/models/common/ProjectModel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';

class MaintenanceDefectAnalysisCreateScreen extends StatelessWidget {
  static String routeName = "/maintenance/defect-analysis/create";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(drawerScrimColor: Colors.transparent, body: CreateBody());
  }
}

class CreateBody extends StatefulWidget {
  CreateBody({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => new _CreatePageState();
}

class _CreatePageState extends State<CreateBody> {
  final _formKey = GlobalKey<FormBuilderState>();

  late Future<ProjectModels> _listOfDefectAnalysis;
  Future<ProjectModels> _getListProjects() async {
    var sortOptions = [];
    var filterOptions = [];
    var options = new LoadOptionsModel(take: 0, skip: 0, sort: jsonEncode(sortOptions), filter: jsonEncode(filterOptions), requireTotalCount: 'true');
    var response = await Common.getListProjects(options);

    if (response.statusCode == 200) {
      var result = ProjectModels.fromJson(jsonDecode(response.body));
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  @override
  void initState() {
    _listOfDefectAnalysis = _getListProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_header(), _form(context)],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      child: TopHeaderSub(
        title: "maintenance.defect_analysis.create_title".tr(),
        subtitle: "maintenance.defect_analysis.create_subtitle",
        buttonLeft: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.pop(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [Icon(Ionicons.chevron_back_outline, color: kPrimaryColor, size: 30.0)],
          ),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return Expanded(
      child: Container(
        child: FormBuilder(
          key: _formKey,
          //enabled: false,
          //autovalidateMode: AutovalidateMode.always,
          //skipDisabled: true,
          initialValue: {
            'idProject': null,
            'idSystem': null,
            'code': null,
            'analysisDate': null,
            'analysisBy': null,
            'currentSuitation': null,
            'maintenanceStaff': null,
            'qcStaff': null,
            'cncStaff': null,
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                FutureBuilder(
                  future: _listOfDefectAnalysis,
                  builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
                    if (snapshot.hasError)
                      return DataErrorWidget(error: snapshot.error.toString());
                    else {
                      if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
                        return LoadingWidget();
                      else {
                        if (snapshot.hasData) {
                          return FormBuilderDropdown<String>(
                            name: 'idProject',
                            decoration: InputDecoration(
                              labelText: 'Dự án triển khai',
                              //suffix: _genderHasError ? const Icon(Icons.error) : const Icon(Icons.check),
                              hintText: 'Vui lòng chọn thông tin dự án',
                            ),
                            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                            items: snapshot.data!.data
                                .map((item) => DropdownMenuItem(
                                      alignment: AlignmentDirectional.center,
                                      value: item.name.toString(),
                                      child: Text(item.name!.toString()),
                                    ))
                                .toList(),
                            // onChanged: (val) {
                            //   setState(() {
                            //     _genderHasError = !(_formKey.currentState?.fields['gender']?.validate() ?? false);
                            //   });
                            // },
                            //valueTransformer: (val) => val?.toString(),
                          );
                        } else
                          return LoadingWidget();
                      }
                    }
                  },
                ),

                /*                
                const SizedBox(height: 15),
                FormBuilderDateTimePicker(
                  name: 'date',
                  initialEntryMode: DatePickerEntryMode.calendar,
                  //initialValue: DateTime.now(),
                  inputType: InputType.both,
                  decoration: InputDecoration(
                    labelText: 'Appointment Time',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['date']?.didChange(null);
                      },
                    ),
                  ),
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                  // locale: const Locale.fromSubtags(languageCode: 'fr'),
                ),
                FormBuilderDateRangePicker(
                  name: 'date_range',
                  firstDate: DateTime(1970),
                  lastDate: DateTime(2030),
                  format: DateFormat('yyyy-MM-dd'),
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    labelText: 'Date Range',
                    helperText: 'Helper text',
                    hintText: 'Hint text',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['date_range']?.didChange(null);
                      },
                    ),
                  ),
                ),
                FormBuilderSlider(
                  name: 'slider',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(6),
                  ]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 10.0,
                  initialValue: 7.0,
                  divisions: 20,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Number of things',
                  ),
                ),
                FormBuilderRangeSlider(
                  name: 'range_slider',
                  // validator: FormBuilderValidators.compose([FormBuilderValidators.min(context, 6)]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 100.0,
                  initialValue: const RangeValues(4, 7),
                  divisions: 20,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(labelText: 'Price Range'),
                ),
                FormBuilderCheckbox(
                  name: 'accept_terms',
                  initialValue: false,
                  onChanged: _onChanged,
                  title: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'I have read and agree to the ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: TextStyle(color: Colors.blue),
                          // Flutter doesn't allow a button inside a button
                          // https://github.com/flutter/flutter/issues/31437#issuecomment-492411086
                          /*
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('launch url');
                                    },
                                  */
                        ),
                      ],
                    ),
                  ),
                  validator: FormBuilderValidators.equal(
                    true,
                    errorText: 'You must accept terms and conditions to continue',
                  ),
                ),
                FormBuilderTextField(
                  autovalidateMode: AutovalidateMode.always,
                  name: 'age',
                  decoration: InputDecoration(
                    labelText: 'Age',
                    suffixIcon: _ageHasError ? const Icon(Icons.error, color: Colors.red) : const Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _ageHasError = !(_formKey.currentState?.fields['age']?.validate() ?? false);
                    });
                  },
                  // valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.max(70),
                  ]),
                  // initialValue: '12',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                FormBuilderDropdown<String>(
                  // autovalidate: true,
                  name: 'gender',
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    suffix: _genderHasError ? const Icon(Icons.error) : const Icon(Icons.check),
                    hintText: 'Select Gender',
                  ),
                  validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  items: genderOptions
                      .map((gender) => DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _genderHasError = !(_formKey.currentState?.fields['gender']?.validate() ?? false);
                    });
                  },
                  valueTransformer: (val) => val?.toString(),
                ),
                FormBuilderRadioGroup<String>(
                  decoration: const InputDecoration(
                    labelText: 'My chosen language',
                  ),
                  initialValue: null,
                  name: 'best_language',
                  onChanged: _onChanged,
                  validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  options: ['Dart', 'Kotlin', 'Java', 'Swift', 'Objective-C']
                      .map((lang) => FormBuilderFieldOption(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(growable: false),
                  controlAffinity: ControlAffinity.trailing,
                ),
                FormBuilderSegmentedControl(
                  decoration: const InputDecoration(
                    labelText: 'Movie Rating (Archer)',
                  ),
                  name: 'movie_rating',
                  // initialValue: 1,
                  // textStyle: TextStyle(fontWeight: FontWeight.bold),
                  options: List.generate(5, (i) => i + 1)
                      .map((number) => FormBuilderFieldOption(
                            value: number,
                            child: Text(
                              number.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ))
                      .toList(),
                  onChanged: _onChanged,
                ),
                FormBuilderSwitch(
                  title: const Text('I Accept the terms and conditions'),
                  name: 'accept_terms_switch',
                  initialValue: true,
                  onChanged: _onChanged,
                ),
                FormBuilderCheckboxGroup<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'The language of my people'),
                  name: 'languages',
                  // initialValue: const ['Dart'],
                  options: const [
                    FormBuilderFieldOption(value: 'Dart'),
                    FormBuilderFieldOption(value: 'Kotlin'),
                    FormBuilderFieldOption(value: 'Java'),
                    FormBuilderFieldOption(value: 'Swift'),
                    FormBuilderFieldOption(value: 'Objective-C'),
                  ],
                  onChanged: _onChanged,
                  separator: const VerticalDivider(
                    width: 10,
                    thickness: 5,
                    color: Colors.red,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(1),
                    FormBuilderValidators.maxLength(3),
                  ]),
                ),
                FormBuilderFilterChip<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'The language of my people'),
                  name: 'languages_filter',
                  selectedColor: Colors.red,
                  options: const [
                    FormBuilderChipOption(
                      value: 'Dart',
                      avatar: CircleAvatar(child: Text('D')),
                    ),
                    FormBuilderChipOption(
                      value: 'Kotlin',
                      avatar: CircleAvatar(child: Text('K')),
                    ),
                    FormBuilderChipOption(
                      value: 'Java',
                      avatar: CircleAvatar(child: Text('J')),
                    ),
                    FormBuilderChipOption(
                      value: 'Swift',
                      avatar: CircleAvatar(child: Text('S')),
                    ),
                    FormBuilderChipOption(
                      value: 'Objective-C',
                      avatar: CircleAvatar(child: Text('O')),
                    ),
                  ],
                  onChanged: _onChanged,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(1),
                    FormBuilderValidators.maxLength(3),
                  ]),
                ),
                FormBuilderChoiceChip<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Ok, if I had to choose one language, it would be:'),
                  name: 'languages_choice',
                  initialValue: 'Dart',
                  options: const [
                    FormBuilderChipOption(
                      value: 'Dart',
                      avatar: CircleAvatar(child: Text('D')),
                    ),
                    FormBuilderChipOption(
                      value: 'Kotlin',
                      avatar: CircleAvatar(child: Text('K')),
                    ),
                    FormBuilderChipOption(
                      value: 'Java',
                      avatar: CircleAvatar(child: Text('J')),
                    ),
                    FormBuilderChipOption(
                      value: 'Swift',
                      avatar: CircleAvatar(child: Text('S')),
                    ),
                    FormBuilderChipOption(
                      value: 'Objective-C',
                      avatar: CircleAvatar(child: Text('O')),
                    ),
                  ],
                  onChanged: _onChanged,
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      if (true) {
                        // Either invalidate using Form Key
                        _formKey.currentState?.invalidateField(name: 'email', errorText: 'Email already taken.');
                        // OR invalidate using Field Key
                        // _emailFieldKey.currentState?.invalidate('Email already taken.');
                      }

                      debugPrint('Valid');
                    } else {
                      debugPrint('Invalid');
                    }
                    debugPrint(_formKey.currentState?.value.toString());
                  },
                  child: const Text('Signup', style: TextStyle(color: Colors.white)),
                ),
                */
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ?? false) {
                            debugPrint(_formKey.currentState?.value.toString());
                          } else {
                            debugPrint(_formKey.currentState?.value.toString());
                            debugPrint('validation failed');
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                        },
                        // color: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Create2 extends StatelessWidget {
  Future<ProjectModels> _getListProjectForCreate() async {
    var sortOptions = [
      // {"selector": "nhomDanhMuc", "desc": "false"},
      // {"selector": "sapXep", "desc": "false"}
    ];
    var filterOptions = [];
    var options = new LoadOptionsModel(
      take: 0,
      skip: 0,
      sort: jsonEncode(sortOptions),
      filter: jsonEncode(filterOptions),
      requireTotalCount: 'true',
    );
    var response = await Common.getListProjects(options);

    if (response.statusCode == 200) {
      var result = ProjectModels.fromJson(jsonDecode(response.body));
      return result;
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Future<ProjectModels> listProject = _getListProjectForCreate();
    return Scrollbar(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "LỰA CHỌN DỰ ÁN - KHÁCH HÀNG",
                style: TextStyle(color: kPrimaryColor, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<ProjectModels>(
              future: listProject,
              builder: (BuildContext context, AsyncSnapshot<ProjectModels> snapshot) {
                if (snapshot.hasError)
                  return DataErrorWidget(error: snapshot.error.toString());
                else {
                  if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active)
                    return LoadingWidget();
                  else {
                    if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                      return AnimationLimiter(
                        child: GroupedListView<dynamic, String>(
                          elements: snapshot.data!.data,
                          groupBy: (element) => element.customer,
                          groupSeparatorBuilder: (String value) => Container(
                            width: MediaQuery.of(context).size.width,
                            color: kPrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    value.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(
                                    "Khách hàng",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemBuilder: (context, dynamic element) => ListTile(
                            title: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: element.name.toString(),
                                style: TextStyle(fontSize: 16.0, color: kPrimaryColor, fontWeight: FontWeight.bold),
                              ),
                            ])),
                            subtitle: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: "Mã hiệu : ${element.code}",
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                              ),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(text: "|"),
                              WidgetSpan(child: SizedBox(width: 5.0)),
                              TextSpan(
                                text: "Địa điểm: ${element.location}",
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                              )
                            ])),
                            trailing: Icon(Ionicons.arrow_redo_outline, color: kSecondaryColor, size: 18.0),
                            //onTap: () => Navigator.pushNamed(context, CreateDeXuatScreen.routeName, arguments: {'danhmuc': element}),
                          ), // optional
                          separator: const Divider(color: kPrimaryColor),
                          floatingHeader: true, useStickyGroupSeparators: true,
                        ),
                      );
                    } else
                      return NoDataWidget(message: "Không tìm thấy phiếu đề xuất liên quan nào !!!");
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
