import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riji_flutter/app.dart';
import 'package:riji_flutter/core/api/api_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ApiClient());
  runApp(const RijiApp());
}
