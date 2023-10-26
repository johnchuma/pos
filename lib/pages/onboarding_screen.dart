import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:get/get.dart';
import 'package:pos/pages/login_page.dart';
import 'package:pos/pages/way_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:pos/utils/shared_preference.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
   final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarIconBrightness: Brightness.dark, // Set the status bar items to white
    ));
    return  Scaffold(
      
      body:Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OnBoard(
        pageController: _pageController,
        imageHeight: 150,
       
        
        nextButton: Container(),
        skipButton: GestureDetector(
          onTap: (){
           SharedPreferencesUtil.setShowOnboarding(false);
            Get.to(()=>LoginPage());
            
          },
          child: heading2(text: "Start",color: Colors.white)),
        titleStyles: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),

        descriptionStyles: TextStyle(color: Colors.white70),
        pageIndicatorStyle: PageIndicatorStyle(activeColor: Colors.white,inactiveColor: Colors.white30,width: 200, activeSize: Size(30,30),inactiveSize: Size(15,15)),
        onBoardData: [
            const OnBoardModel(
      title: "Welcome to Trade Point",
      description: "Empowering Your Business with Smart Point of Sale Solutions",
      imgUrl: "assets/8690519_3951453-removebg-preview.png",
      ),
         const OnBoardModel(
      title: "Endless Possibilities with Trade Point",
      description: "Effortlessly Manage Sales, Inventory, Staff, and More",
      imgUrl: "assets/22378347_6595412-removebg-preview.png",
      ),
         const OnBoardModel(
      title: "Simplified Inventory Management",
      description: "Track Stock, Reorder Automatically, and Never Miss a Sale",
      imgUrl: "assets/10386544_4415074-removebg-preview.png",
      ),
         const OnBoardModel(
      title: "Efficient Staff Management",
      description: "Assign Roles, Track Performance, and Foster Team Collaboration",
      imgUrl: "assets/12556108_4996665-removebg-preview.png",
      ),
         const OnBoardModel(
      title: "Insightful Business Reporting",
      description: "Visualize Your Performance, Identify Trends, and Make Informed Decisions",
      imgUrl: "assets/8674921-removebg-preview.png",
      ),
         const OnBoardModel(
      title: "Join a Thriving Business Owners Community",
      description: "Connect, Share, and Learn from Like-Minded Entrepreneurs",
      imgUrl: "assets/29845426_7265372-removebg-preview.png",
      ),
        ],),
    ) ,backgroundColor: backgroundColor,);
  }
}