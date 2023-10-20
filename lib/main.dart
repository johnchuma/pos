import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pos/controllers/app_controller.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/pages/splash_screen.dart';
import 'package:pos/pages/way_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/utils/colors.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
     Get.put(AppController());
     OneSignal.shared.setAppId("b7029800-f6e6-4ce5-a312-438e0d2ea029");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Powered POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.dmSansTextTheme()
      ),
      home: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light
        ),
        child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
                  return Container();
            }
            Get.put(AuthController()); 
            return FutureBuilder(
             future: Future.delayed(Duration(seconds: 3)),
              builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return SplashScreen();
                }
                return const WayPage();
              }
            );
          }
        ),
      ),
    );
  }
}


