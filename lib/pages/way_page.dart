// ignore_for_file: unnecessary_import, implementation_imports

import 'package:flutter/services.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/pages/home_page.dart';
import 'package:pos/pages/login_page.dart';
import 'package:pos/pages/onboarding_screen.dart';
import 'package:pos/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WayPage extends StatelessWidget {
  const WayPage({super.key});

  @override
  Widget build(BuildContext context) {
            
  
// SharedPreferencesUtil.setShowOnboarding(true);
    return GetX<AuthController>(
          init: AuthController(),
          builder: (find){
               return find.user != null? const HomePage():FutureBuilder(
                future: SharedPreferencesUtil.getShowOnboarding(),
                 builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Container();
                  }
                  var preference = snapshot.requireData;
                   return preference? const OnboardingScreen():LoginPage();
                 }
               );
        });
      }
    
  
}

