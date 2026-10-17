import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
Future<void> main() async { WidgetsFlutterBinding.ensureInitialized(); await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform); SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); runApp(const JoudiaApp()); }
class JoudiaApp extends StatelessWidget { const JoudiaApp({super.key}); @override Widget build(BuildContext c)=>MaterialApp(title:'طلبات مناديب الجوديا',debugShowCheckedModeBanner:false,locale:const Locale('ar'),theme:ThemeData(useMaterial3:true,colorSchemeSeed:const Color(0xff146c94),scaffoldBackgroundColor:const Color(0xfff7fafc),textTheme:GoogleFonts.cairoTextTheme(),inputDecorationTheme:const InputDecorationTheme(border:OutlineInputBorder(),filled:true,fillColor:Colors.white),),home:const LoginScreen()); }