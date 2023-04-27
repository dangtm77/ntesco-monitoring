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
    "required": "This field cannot be empty, please input information",
    "required_select": "This field cannot be empty, please select information",
    "string_length": "This field must have at least {length} symbols",
    "pattern": "This field invalid"
  },
  "menu": {
    "home": "Home",
    "phieudexuat": "Requests",
    "maintenance": "Maintenance",
    "log_out": "Log out",
    "settings": "Settings",
    "alarm": "Alarm",
    "contact_us": "Contact us",
    "contact_us_subtitle": "Contact us - Support - Feedback"
  },
  "phieudexuat": {
    "title": "Requests",
    "subtitle": "Requests Tracking",
    "detail_title": "Detail of request",
    "detail_subtitle": "Information of request",
    "create_title": "Create new request",
    "create_subtitle": "Create and new information of request"
  },
  "maintenance": {
    "title": "Maintenance",
    "subtitle": "System maintenance of Projects",
    "plan_title": "Maintenance plan",
    "plan_subtitle": "Detailed maintenance plans of projects",
    "defect_analysis": {
      "title": "Defect analysis",
      "subtitle": "Analysis and report defect of projects",
      "update_title": "Update defect analysis",
      "update_subtitle": "Update report defect of projects"
    },
    "defect_analysis_details": {
      "update_title": "Update defect analysis details",
      "update_subtitle": "Update detail defect of projects"
    }
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
    "error_subtitle": "Please contact to administrator to support...",
    "no_connection": "No connection to internet",
    "no_connection_subtitle": "Please check your device's internet connection status..."
  }
};
static const Map<String,dynamic> vi_VN = {
  "common": {
    "hint_text_input": "Vui lòng nhập thông tin...",
    "hint_text_select": "Vui lòng chọn thông tin..."
  },
  "login": {
    "username_label": "Tên đăng nhập",
    "password_label": "Mật khẩu",
    "username_hint": "Nhập tên đăng nhập của bạn...",
    "password_hint": "Nhập mật khẩu của bạn...",
    "signin_button": "Đăng nhập",
    "forgot_password_button": "Bạn quên mật khẩu?"
  },
  "validation": {
    "required": "Trường này không được bỏ trống, vui lòng nhập thông tin",
    "required_select": "Trường này không được bỏ trống, vui lòng chọn thông tin",
    "string_length": "Trường này phải có ít nhất {length} ký tự",
    "pattern": "Trường này không hợp lệ"
  },
  "menu": {
    "home": "Trang chủ",
    "phieudexuat": "Phiếu đề xuất",
    "maintenance": "Bảo trì dự án",
    "log_out": "Đăng xuất",
    "settings": "Cài đặt",
    "alarm": "Cảnh báo",
    "contact_us": "Liên hệ chúng tôi",
    "contact_us_subtitle": "Liên hệ - Hỗ trợ - Góp ý"
  },
  "phieudexuat": {
    "title": "Phiếu đề xuất",
    "subtitle": "Theo dõi tình trạng các phiếu đề xuất",
    "detail_title": "Chi tiết phiếu đề xuất",
    "detail_subtitle": "Thông tin chi tiết của phiếu đề xuất",
    "create_title": "Tạo mới phiếu đề xuất",
    "create_subtitle": "Khởi tạo và gửi phiếu đề xuất"
  },
  "maintenance": {
    "title": "Bảo trì dự án",
    "subtitle": "Bảo trì các hệ thống của dự án",
    "plan_title": "Kế hoạch bảo trì",
    "plan_subtitle": "Chi tiết kế hoạch bảo trì của các dự án",
    "defect_analysis": {
      "title": "Phân tích sự cố",
      "subtitle": "Phân tích và báo cáo sự cố của hệ thống",
      "update_title": "Cập nhật phân tích sự cố",
      "update_subtitle": "Cập nhật thông tin báo cáo sự cố của hệ thống"
    },
    "defect_analysis_details": {
      "update_title": "Cập nhật chi tiết sự cố",
      "update_subtitle": "Cập nhật thông tin chi tiết sự cố của hệ thống"
    }
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
    "error_subtitle": "Vui lòng liên hệ đến quản trị viên để khắc phục...",
    "no_connection": "Không có kết nối internet",
    "no_connection_subtitle": "Vui lòng kiểm tra lại kết nối internet của thiết bị..."
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_US": en_US, "vi_VN": vi_VN};
}
