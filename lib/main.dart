import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_riddles/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MathRiddlesApp());
}
