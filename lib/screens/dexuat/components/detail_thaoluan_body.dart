// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:ntesco_smart_monitoring/models/dx/PhieuDeXuatDetail.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DetailThaoLuanBody extends StatefulWidget {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;
  const DetailThaoLuanBody({Key? key, required this.id, this.phieuDeXuat}) : super(key: key);

  @override
  _DetailThaoLuanBodyPageState createState() => new _DetailThaoLuanBodyPageState(id, phieuDeXuat);
}

class _DetailThaoLuanBodyPageState extends State<DetailThaoLuanBody> {
  final int id;
  final PhieuDeXuatDetailModel? phieuDeXuat;
  _DetailThaoLuanBodyPageState(this.id, this.phieuDeXuat);

  var messageList = [
    {
      "author": {
        "firstName": "John",
        "id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
        "lastName": "Doe",
        "imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
      },
      "createdAt": 1655648404000,
      "id": "c67ed376-52bf-4d4e-ba2a-7a0f8467b22a",
      "status": "seen",
      "text": "Ooowww ☺️",
      "type": "text"
    },
    {
      "author": {
        "firstName": "Janice",
        "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
        "imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
        "lastName": "King",
      },
      "createdAt": 1655648403000,
      "height": 1280,
      "id": "02797655-4d73-402e-a319-50fde79e2bc4",
      "name": "madrid",
      "size": 585000,
      "status": "seen",
      "type": "image",
      "uri": "https://source.unsplash.com/WBGjg0DsO_g/1920x1280",
      "width": 1920
    },
    {
      "author": {
        "firstName": "Janice",
        "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
        "imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
        "lastName": "King",
      },
      "createdAt": 1655648402000,
      "id": "4e048753-2d60-4144-bc28-9967050aaf12",
      "status": "seen",
      "text": "What a ~nice~ _wonderful_ sunset! 😻",
      "type": "text"
    },
    {
      "author": {
        "firstName": "Matthew",
        "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
        "lastName": "White",
      },
      "createdAt": 1655648401000,
      "id": "64747b28-df19-4a0c-8c47-316dc3546e3c",
      "status": "seen",
      "text": "Here you go buddy! 💪",
      "type": "text"
    },
    {
      "author": {
        "firstName": "Matthew",
        "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
        "lastName": "White",
      },
      "createdAt": 1655648400000,
      "id": "6a1a4351-cf05-4d0c-9d0f-47ed378b6112",
      "mimeType": "application/pdf",
      "name": "city_guide-madrid.pdf",
      "size": 10550000,
      //"status": "seen",
      "type": "file",
      "uri": "https://www.esmadrid.com/sites/default/files/documentos/madrid_imprescindible_2016_ing_web_0.pdf"
    },
    {
      "author": {
        "firstName": "John",
        "id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
        "lastName": "Doe",
      },
      "createdAt": 1655624464000,
      "id": "38681a33-2563-42aa-957b-cfc12f791d16",
      "status": "seen",
      "text": "Matt, where is my Madrid guide?",
      "type": "text"
    },
  ];
  List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  void initState() {
    final messages = messageList.map((e) => types.Message.fromJson(e)).toList();
    setState(() {
      _messages = messages;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Chat(
      //   showUserAvatars: true,
      //   showUserNames: true,
      //   messages: _messages,
      //   // onAttachmentPressed: _handleAttachmentPressed,
      //   // onMessageTap: _handleMessageTap,
      //   // onPreviewDataFetched: _handlePreviewDataFetched,
      //   onSendPressed: (p0) {},
      //   user: _user,
      //   theme: const DefaultChatTheme(),
      // ),
      child: Center(child: Text("Đang cập nhật...")),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
