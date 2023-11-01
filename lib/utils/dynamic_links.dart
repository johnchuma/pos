import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> getDynamicLink({title,description,image,productId})async{
    final link = "https://www.tradepoint.hasotion.com/?productId=$productId";

  final dynamicLinkParams = DynamicLinkParameters(
  link: Uri.parse(link),
  uriPrefix: "https://hasotion.page.link",
  androidParameters: const AndroidParameters(
    packageName: "com.hasotion.pos",
    minimumVersion: 30,
  ),
  
  socialMetaTagParameters: SocialMetaTagParameters(
    title: title,
    description: description,
    imageUrl: Uri.parse(image),
  ),
);
var dynamicLink =
    await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

 return dynamicLink.shortUrl.toString();
}