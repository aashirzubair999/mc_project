import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_final/Screens/camera.dart';

class MapScreen extends StatefulWidget {
  final double long;
  final double lat;
  const MapScreen({super.key, required this.long, required this.lat});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (context) => cameraAccess()));
      //     },
      //   ),
      // ),
        body: Column(
          children: [
            // IconButton(
            //   icon: Icon(Icons.arrow_back, color: Colors.black),
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => cameraAccess()));
            //   },
            // ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Pesticides Shop Near You ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'RobotoMono'),
            ),
            const SizedBox(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 647,
                width: 350,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600, width: 2),
                ),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.lat, widget.long),
                    zoom: 16,
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
              ),
            )
          ],
        ));
  }
}
