import 'package:flutter/material.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/translatedText.dart';


class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
           appBar: AppBar(
          leading: Container(),
          leadingWidth: 10,
          title: heading2(text:translatedText("Community", "Jumuiya")),
          backgroundColor: backgroundColor,
          elevation: 0.3
          ),
          body: Container(child: Center(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Container(
                height: 400,
                child: Image.asset("assets/25699260_7100664-removebg-preview.png")),
              heading2(text: translatedText("Comming soon...", "Inakuja punde...")),
              mutedText(text: translatedText("The Business community feature is on its way! Stay tuned for this incredible and powerful tool coming soon to enhance your business experience.", "Punde utakuwa na uwezo wa kujumuika na wafanyabiashara wengine kwa ajili ya mijadala mbalimbali. endelea kusubiri"),textAlign: TextAlign.center)
            ],),
          ),),),
          
          );
          
  }
}