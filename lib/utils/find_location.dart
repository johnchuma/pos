import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

 Future<LocationData?> findCurrentLocation()async{
  Location location = Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

_serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    
  }
}

_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
    
  }
}

_locationData = await location.getLocation();
print(_locationData.latitude);
print(_locationData.longitude);


return _locationData;
}
String distanceBetweenTwoCoordinates({lat1,long1,lat2,long2}){
  double value = (Geolocator.distanceBetween(lat1,long1,lat2,long2));
  if(value > 1000){
    return "${(Geolocator.distanceBetween(lat1,long1,lat2,long2)/1000).toStringAsFixed(2)}Km away";
  }
  
     return "${(Geolocator.distanceBetween(lat1,long1,lat2,long2)).toStringAsFixed(2)} Meters away";

}