import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ntesco_smart_monitoring/components/state_widget.dart';
import 'package:ntesco_smart_monitoring/constants.dart';
import 'package:ntesco_smart_monitoring/core/contact_us.dart';
import 'package:ntesco_smart_monitoring/models/ContactUs.dart';
import 'package:ntesco_smart_monitoring/models/LoadOptions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ntesco_smart_monitoring/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/top_header.dart';
import '../../home/home_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => new _BodyPageState();
}

class _BodyPageState extends State<Body> {
  late Future<ContactUsModels> listContactUs;

  @override
  void initState() {
    super.initState();
  }

  Future<ContactUsModels> _getListContactUs(String lang) async {
    var options = new LoadOptionsModel(
        take: 0,
        skip: 0,
        sort: "[{\"selector\":\"sortIndex\", \"desc\":\"false\"}]",
        filter: "[[\"code\",\"=\",\"$lang\"],\"and\",[\"type\",\"=\",1]]",
        requireTotalCount: 'true');
    var response = await funcGetListContactUs(options);
    if (response.statusCode == 200) {
      print(response.body);
      return ContactUsModels.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401)
      throw response.statusCode;
    else
      throw Exception('StatusCode: ${response.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      listContactUs = _getListContactUs(context.locale.languageCode);
    });
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopHeaderSub(
                title: "menu.contact_us".tr(),
                subtitle: "menu.contact_us_subtitle".tr(),
                buttonRight: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () =>
                      Navigator.pushNamed(context, HomeScreen.routeName),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          color: kPrimaryColor, size: 40)
                    ],
                  ),
                )),
            Expanded(
              child: new RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    listContactUs =
                        _getListContactUs(context.locale.languageCode);
                  });
                },
                child: FutureBuilder<ContactUsModels>(
                  future: listContactUs,
                  builder: (BuildContext context,
                      AsyncSnapshot<ContactUsModels> snapshot) {
                    if (snapshot.hasError)
                      return DataErrorWidget(error: snapshot.error.toString());
                    else {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return LoadingWidget();
                      else {
                        if (snapshot.hasData && snapshot.data!.totalCount > 0) {
                          return Column(children: [
                            Expanded(
                              child: AnimationLimiter(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item =
                                        snapshot.data!.data.elementAt(index);
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        child: FadeInAnimation(
                                            child: contactUsItem(item)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]);
                        } else {
                          return NoDataWidget(
                              message: "Không tìm thấy bất kỳ thông tin nào");
                        }
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile contactUsItem(ContactUsModel item) {
    return ListTile(
      title: Text(item.title,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
      subtitle: Text(item.value,
          style:
              TextStyle(color: kSecondaryColor, fontWeight: FontWeight.w600)),
      trailing: Icon(Icons.arrow_right_rounded),
      leading: Container(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              item.option002!.toString(),
              height: getProportionateScreenWidth(20),
            )
          ],
        ),
      ),
      onTap: () async {
        var uri = Uri.parse(item.option001.toString());
        if (await canLaunchUrl(uri)) await canLaunchUrl(uri);
      },
    );
  }
}
