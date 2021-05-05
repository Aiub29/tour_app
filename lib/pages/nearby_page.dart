import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class NearbyPage extends StatefulWidget {
  static final routName= '/nearby';
  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  bool isLoading =false;
  static final CameraPosition _myPosition = CameraPosition(
    target: LatLng(23.8069, 90.3687),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Near Me', style: TextStyle(color: Colors.black),),
      ),
      body: Stack(
        children: [
          isLoading ? Center(child: CircularProgressIndicator(),) :
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: _myPosition,

          ),
        ],
      ),


    );
  }
}
