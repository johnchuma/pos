 import 'package:url_launcher/url_launcher.dart';

void launchGoogleMaps({latitude,longitude}) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      launchUrl(Uri.parse(googleMapsUrl));
    
    }