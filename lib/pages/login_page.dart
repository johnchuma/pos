// ignore_for_file: must_be_immutable, sort_child_properties_last


import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/pages/way_page.dart';

import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/heading_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:flutter/material.dart';
import 'package:pos/widgets/pill.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final _formKey = GlobalKey<FormState>();

TextEditingController emailController = TextEditingController();

TextEditingController passwordController = TextEditingController();

bool loading = false;


 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-40,
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               ClipRRect(
                 borderRadius: BorderRadius.circular(15),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Hero(
                              tag: "logo",
                              child: ClipOval(
                                child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.asset("assets/icons/1024.png")),
                              ),
                            ),
                            // mutedText(text: "Powered POS",fontSize: 25),
                        
                       
                       const SizedBox(height: 30,),
                        headingText(text: "Login to continue", textAlign: TextAlign.center,
                                fontSize: 30
                                ),
                                const SizedBox(height: 5,),
                                 mutedText(text: "To access all Powered POS features, please log in now. Press the button below to get started.",
                                 textAlign: TextAlign.center,
                                
                                 
                                 ),
                                 SizedBox(height: 20,),
                               
                              const SizedBox(height: 60,),
                               GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     loading= true;
                                   });
                                   AuthController().registerClient().then((value) {
                                    Get.to(()=>const WayPage());
                                    setState(() {
                                       loading = false;
                                    });
                                   });
                                 },
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(15),
                                   child: Container(
                                                      color: primaryColor2,
                                                         child: Padding(
                                                           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                                                           child: loading? Center(child: SizedBox(
                                                             height: 25,
                                                             width: 25,
                                                             child: CircularProgressIndicator(color: backgroundColor))): Row(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             
                                                             children: [
                                                           
                                                           
                                                           Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: Image.asset("assets/google.png",)),
                                       const SizedBox(width: 15,),
                                                               heading2(text: "Continue with google",color: backgroundColor,fontSize:15,)
                                                           
                                                           ],),
                                                         ),),
                                 ),
                               ),
                               SizedBox(height: 20,),
                              GestureDetector(
                                onTap: (){
                                  launchUrl(Uri.parse("https://www.termsfeed.com/live/9e25b996-fb76-402e-bb23-59644ce3942d"));
                                },
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                
                                  children: [
                                  TextSpan(text: "By pressing continue button, you agree with our",style: GoogleFonts.openSans (color: mutedColor,fontSize: 16)),
                                   TextSpan(text: " Terms & conditions ",  style: GoogleFonts.openSans (fontSize: 16,color: primaryColor)),
                                   TextSpan(text: "and our",style: GoogleFonts.openSans (color: mutedColor,fontSize: 16)),
                                   TextSpan(text: " Privacy policy",style: GoogleFonts.openSans (fontSize: 16,color: primaryColor))
                                ])),
                              )
                               ],),
                       ),
                 ],),
               )
            
            ]),
          ),
        ),
      )
    );
  }
}