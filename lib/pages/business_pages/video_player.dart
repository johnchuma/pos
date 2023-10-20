// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos/models/tutorial.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  Tutorial tutorial;
   VideoPlayer(this.tutorial,{ super.key});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
   

 @override
  void dispose() {
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
   
    body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: Center(child:  YoutubePlayer(
                                showVideoProgressIndicator: true,
                                controller: YoutubePlayerController(
                                initialVideoId: widget.tutorial.video,  
                                                      
                                flags: const YoutubePlayerFlags(
                                    autoPlay: true,
                                    mute: false,
                                   hideControls: false,
                                   showLiveFullscreenButton: true
                                ),)),),
        ),
        GestureDetector(
          onTap: (){
              Get.back();
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20,top: 30),
            child: ClipOval(
              child: Container(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back,color: Colors.white,),
              ),color: Colors.black.withOpacity(0.7),),
            ),
          ),
        )
      ],
    ),
    );
  }
}