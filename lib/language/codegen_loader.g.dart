// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en_US = {
  "login": {
    "username_label": "Username",
    "password_label": "Password",
    "username_hint": "Enter your username...",
    "password_hint": "Enter your password...",
    "signin_button": "Sign In",
    "forgot_password_button": "Forgot Password?"
  },
  "validation": {
    "required": "Please enter your {}",
    "string_length": "{} must have at least {} symbols",
    "pattern": "{} invalid"
  },
  "menu": {
    "home": "Home",
    "dexuat": "Requests",
    "dexuat_subtitle": "Requests Tracking",
    "dexuat_detai_title": "Chi tiết thông tin phiếu đề xuất",
    "log_out": "Log out",
    "settings": "Settings",
    "alarm": "Alarm",
    "contact_us": "Contact us",
    "contact_us_subtitle": "Contact us - Support - Feedback"
  },
  "language_display": "Language display:",
  "hello_message": "Hi, {}\r\n",
  "welcome_message": "How are you today!",
  "state": {
    "loading": "Loading...",
    "loading_subtitle": "Loading",
    "nodata": "Not found",
    "nodata_subtitle": "Try again or contact to administrator...",
    "error": "An error is occurring",
    "error_subtitle": "Please contact to administrator to support..."
  }
};
static const Map<String,dynamic> vi_VN = {
  "login": {
    "username_label": "Tên đăng nhập",
    "password_label": "Mật khẩu",
    "username_hint": "Nhập tên đăng nhập của bạn...",
    "password_hint": "Nhập mật khẩu của bạn...",
    "signin_button": "Đăng nhập",
    "forgot_password_button": "Bạn quên mật khẩu?"
  },
  "validation": {
    "required": "Vui lòng nhập {}",
    "string_length": "{} phải có ít nhất {} ký hiệu",
    "pattern": "{} không hợp lệ"
  },
  "menu": {
    "home": "Trang chủ",
    "dexuat": "Phiếu đề xuất",
    "dexuat_subtitle": "Theo dõi phiếu đề xuất",
    "dexuat_detai_title": "Chi tiết thông tin phiếu đề xuất",
    "log_out": "Đăng xuất",
    "settings": "Cài đặt",
    "alarm": "Cảnh báo",
    "contact_us": "Liên hệ chúng tôi",
    "contact_us_subtitle": "Liên hệ - Hỗ trợ - Góp ý"
  },
  "language_display": "Ngôn ngữ hiển thị:",
  "hello_message": "Xin chào, {}\r\n",
  "welcome_message": "Hôm nay của bạn như thế nào!",
  "state": {
    "loading": "Đang tải...",
    "loading_subtitle": "Vui lòng chờ trong giây lát...",
    "nodata": "Không tìm thấy dữ liệu",
    "nodata_subtitle": "Vui lòng thử lại hoặc liên hệ quản trị viên...",
    "error": "Đang có lỗi xảy ra",
    "error_subtitle": "Vui lòng liên hệ đến quản trị viên để khắc phục..."
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_US": en_US, "vi_VN": vi_VN};
}
