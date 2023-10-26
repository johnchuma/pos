import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/models/client.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: FutureBuilder(
            future: authController.findMyInfo(),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Container();
              }
              Client client = snapshot.requireData;
              return ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15)),
                child: AnimatedSize(
                  duration: Duration(seconds: 3),
                  child: Container(
                    color: mutedBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const SizedBox(height: 10,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(width: 80,height: 5,color: backgroundColor,))],),
                
                
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              child: Image.asset("assets/icons8-language-94.png")),
                              SizedBox(width: 10,),
                            heading2(text: translatedText("Change language", "Badilisha lugha")),
                            
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(children: [
                          Checkbox(value: client.language == "ENG"? true:false,activeColor: primaryColor, onChanged: (value){
                            setState(() {
                            authController.updateClientInfo({"language":"ENG"});
                            });
                          }),
                          SizedBox(width: 10,),
                          paragraph(text: "English"),
                          
                        ],),
                         const SizedBox(height: 0,),
                        Row(children: [
                          Checkbox(value: client.language == "SWH"? true:false, activeColor: primaryColor, onChanged: (value){
                              setState(() {
                            authController.updateClientInfo({"language":"SWH"});
                            });
                          }),
                          SizedBox(width: 10,),
                          paragraph(text: "Swahili"),
                          
                        ],),
                          SizedBox(height: 40,),

                
                        ]))),
                ));
            }
          ));
  }
}