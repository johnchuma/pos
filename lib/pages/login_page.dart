// ignore_for_file: must_be_immutable, sort_child_properties_last


import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
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
      backgroundColor: backgroundColor,
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
                                    height: 100,
                                    width: 100,
                                    child: Image.asset("assets/icons/1024.png")),
                              ),
                            ),
                            // mutedText(text: "Trade point",fontSize: 25),
                        
                       
                       const SizedBox(height: 40,),
                        headingText(text: "Sign in to continue", textAlign: TextAlign.center,color: Colors.white,
                                fontSize: 20
                                ),
                                const SizedBox(height: 5,),
                                 mutedText(text: "To access all Trade Point features, please log in now. Press the button below to get started.",
                                 textAlign: TextAlign.center,
                                 color: Colors.white70,
                                 
                                 ),
                                 SizedBox(height: 20,),
                                //  ClipRRect(
                                //   borderRadius: BorderRadius.circular(0),
                                //    child: Container(
                                    
                                //     child: Padding(
                                //       padding: const EdgeInsets.all(0),
                                //       child: Wrap(children: ["Manage your businesses","Connect with customers","Connect with suppliers","Send & receive orders","Get business reports", "Share your products online","Online support"].map((item) => 
                                //       Container(child:mutedText(text: item),)).toList(),),
                                //     ),),
                                //  ),
                         
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
                                                      decoration: BoxDecoration(gradient:LinearGradient(colors: [primaryColor,primaryColor2])),
                                                         child: Padding(
                                                           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                                                           child: loading? Center(child: SizedBox(
                                                             height: 25,
                                                             width: 25,
                                                             child: CircularProgressIndicator(color: textColor))): Row(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             
                                                             children: [
                                                           Container(
                                                            
                                                           height: 20,
                                                           width: 20,
                                                           child: Row(
                                                             children: [
                                                               CachedNetworkImage(imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1024px-Google_%22G%22_Logo.svg.png"),
                                                            
                                                             ],
                                                           )),
                                                           
                                                           
                                       const SizedBox(width: 15,),
                                                               heading2(text: "Continue with google",color: textColor,fontSize: 13,)
                                                           
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
                                  TextSpan(text: "By pressing continue button, you agree with our",style: TextStyle(color: mutedColor,fontSize: 12)),
                                   TextSpan(text: " Terms & conditions ",  style: TextStyle(fontSize: 12,color: secondaryColor)),
                                   TextSpan(text: "and our",style: TextStyle(color: mutedColor,fontSize: 12)),
                                   TextSpan(text: " Privacy policy",style: TextStyle(fontSize: 12,color: secondaryColor))
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