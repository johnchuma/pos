import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/auth_controller.dart';
import 'package:pos/controllers/business_controller.dart';
import 'package:pos/controllers/clients_controller.dart';
import 'package:pos/controllers/conversation_controller.dart';
import 'package:pos/controllers/unread_messages_controller.dart';
import 'package:pos/models/conversation.dart';
import 'package:pos/pages/client/client_business_chat_page.dart';
import 'package:pos/utils/colors.dart';
import 'package:pos/widgets/avatar.dart';
import 'package:pos/widgets/back.dart';
import 'package:pos/widgets/heading2_text.dart';
import 'package:pos/widgets/muted_text.dart';
import 'package:pos/widgets/paragraph.dart';
import 'package:pos/widgets/translatedText.dart';


class ClientsConversation extends StatelessWidget {
   ClientsConversation({super.key});
   BusinessController businessController = Get.find<BusinessController>();
   ClientsController clientsController = Get.find<ClientsController>();

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        backgroundColor: backgroundColor,
      appBar: AppBar(leading: back(),backgroundColor: backgroundColor,elevation: 0.3,
      title: Row(children: [
        
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heading2(text:translatedText("Conversations", "Maulizo ya bidhaa")),
          

          ],
        ))
      ],) 
      ,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder<ConversationController>(
                init: ConversationController(),
                builder: (find) {
                  return StreamBuilder(
                    stream: find.getConversationsAsBusiness(),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Container(child: Center(child: CircularProgressIndicator(color: textColor,)),);
                      }
                      List<Conversation> conversations = snapshot.requireData;
                      return ListView(children: conversations.map((item) => 
                      GestureDetector(
                        onTap: (){
                          find.selectedConversation.value = item;
                          clientsController.selectedClient.value = item.client;
                          UnreadMessagesController().updateAllUnreadMessages(messages:  item.unreadMessages.value);
                          Get.to(()=>ClientBusinessChatPage(false));
                          // find.updateAllNewConversations(item!);
                          // businessController.selectedSender.value = item;
                          // Get.to(()=>const BusinessToSupplierChatPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: mutedBackground,
                              child: 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [avatar(image: item?.client?.profileImageUrl),
                              const SizedBox(width: 14,),
                               Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    heading2(text:item?.client?.name,fontSize: 15),
                           item!.unreadMessages.value.isEmpty? mutedText(text: "No new messages for now"):
                                 Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     paragraph(text: item.unreadMessages.value.first.message,maxLines: 1),
                                    //  mutedText(text: timeago.format(item.unreadMessages.value.first.createdAt.toDate()),fontSize: 14)
                                   ],
                                 ),
                                  ],
                                ),   
                              ),
                            if(item.unreadMessages.value.isNotEmpty == true)  
                            ClipOval(
                              child: Container(
                                color: Colors.red,
                                height: 20,
                                width: 20,
                                child: Center(child: Text("${item.unreadMessages.value.length}",style: TextStyle(color: textColor),)),),
                            ),
                              ],),
                            )
                            
                            ,),
                          ),
                        ),
                      )).toList(),);
                    }
                  );
                }
              ),
      ),
    );
  }
}