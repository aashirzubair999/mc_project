import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_final/Screens/camera.dart';

class MapScreen extends StatefulWidget {

  final double long;
  final double lat;
  const MapScreen({super.key,required this.long,required this.lat});


  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat,widget.long),
          zoom: 14,
        ),
        markers: {
          Marker(
              markerId: MarkerId("demo"),
              position: LatLng(widget.lat, widget.long),
              draggable: true,
              onDragEnd: (value) {
                //new location
              })
        },
      ),
    );
  }
}
