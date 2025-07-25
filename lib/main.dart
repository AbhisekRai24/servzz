import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:servzz/app/app.dart';
import 'package:servzz/app/service_locator/service_locator.dart';
import 'package:servzz/core/network/hive_service.dart';
import 'package:servzz/features/product/data/data_source/product_remote_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  // init Hive service
  await HiveService().init();
  // Delete database
  // await HiveService().clearAll();
  setupLogging();
  Logger('Main').info('App started');
  runApp(
    OverlaySupport.global(
      
      child: App(),
    ),
  );
}
