import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  void addCustomIcon() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(33.7130512, 73.0234573),
          zoom: 14,
        ),
        markers: {
          Marker(
              markerId: MarkerId("demo"),
              position: LatLng(30.375320, 69.345116),
              draggable: true,
              onDragEnd: (value) {
                //new location
              })
        },
      ),
    );
  }
}
