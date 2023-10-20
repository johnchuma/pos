
// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/controllers/Product_controller.dart';
import 'package:pos/controllers/register_controller.dart';
import 'package:pos/controllers/tutorial_controller.dart';
import 'package:pos/pages/business_pages/video_player.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/utils/file_picker.dart';
import 'package:pos/utils/format_date.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/custom_button.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/text_form.dart';
import 'package:pos/widgets/translatedText.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;


class TutorialsPage extends StatefulWidget {
 
   TutorialsPage({super.key});
  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
   final _formKey = GlobalKey<FormState>();

   TextEditingController nameController = TextEditingController();
   TextEditingController descriptionController = TextEditingController();

  var path = "";
  bool loading = false;
  List relatedTo = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: back(),
        elevation: 0.3,
        backgroundColor: backgroundColor,
        title: heading2(text:translatedText("How to use this app", "Jinsi ya kutumia mfumo")),
      ),
      body: GetX<TutorialController>(
        init: TutorialController(),
        builder: (find) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: find.tutorials.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: (){
              // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

                      Get.to(()=>VideoPlayer(item));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          
                          children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 70,width: 80,
                                    child: YoutubePlayer(
                                      showVideoProgressIndicator: true,
                                       bufferIndicator: Container(),
                                      
                                      controller: YoutubePlayerController(
                                      initialVideoId: item.video,
                                        
                                      flags: const YoutubePlayerFlags(
                                          autoPlay: false,
                                          mute: false,
                                          useHybridComposition: true,
                                         hideControls: false,
                                         showLiveFullscreenButton: true
                                      ),)),
                                  ),
                                ),
                                  SizedBox(width: 5,),
                                   Expanded(
                                     child: Padding(
                                                             padding: const EdgeInsets.symmetric(horizontal: 5),
                                                             child: Column(
                                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                               children: [
                                                                 heading2(text: item.title,maxLines: 1),
                                                
                                                             mutedText(text:"Uploaded ${timeago.format(item.createdAt.toDate())}")
                                                           
                                                               ],
                                                             ),
                                                           ),
                                   ),
                              ],
                            ),
                          ),
                        
                                  
                        ],),
                      ),
                    ),
                  ),
                )).toList(),),
            ),
          );
        }
      ),
    );
  }
}