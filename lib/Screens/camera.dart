import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_final/Screens/gallery.dart';

import 'map.dart';

class cameraAccess extends StatefulWidget {
  @override
  State<cameraAccess> createState() => _cameraAccessState();
}

class _cameraAccessState extends State<cameraAccess> {
  File imagefile = File('assets/images/logo1.png');


  void _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (pickedFile == null) return;

    final imagefile = File(pickedFile.path);
    setState(() {
      this.imagefile = imagefile;
    });

    final path = 'files/${DateTime.now().microsecondsSinceEpoch}_${imagefile.path.split('/').last}';
    final storageref = FirebaseStorage.instance.ref();
    final mountainsRef = storageref.child(path);
    final uploadTask = mountainsRef.putFile(imagefile);

    uploadTask.whenComplete(() async {
      final url = await mountainsRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('images')
          .add({'imageUrl': url,'UID':FirebaseAuth.instance.currentUser!.uid});
      print(url);
    }).catchError((onError) {
      print(onError);
    });
  }

  void _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (pickedFile == null) return;

    final imagefile = File(pickedFile.path);
    setState(() {
      this.imagefile = imagefile;
    });

    final path = 'files/${DateTime.now().microsecondsSinceEpoch}_${imagefile.path.split('/').last}';
    final storageref = FirebaseStorage.instance.ref();
    final mountainsRef = storageref.child(path);
    final uploadTask = mountainsRef.putFile(imagefile);

    uploadTask.whenComplete(() async {
      final url = await mountainsRef.getDownloadURL();
      print(url);
    }).catchError((onError) {
      print(onError);
    });
  }

  //String filepath,
  late String locationMessage = '';
  late String long="";
  late String  lat="";

  Future<void> _getlocation() async {


    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    lat =  '${position.latitude}';
    long = '${position.longitude}';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:  Text(locationMessage.toString(),style: TextStyle(fontSize: 12),),
      ),

      body: ListView(children: [
        ElevatedButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageDisplay(userId: FirebaseAuth.instance.currentUser!.uid)));
        }, child: Text("Gallery")),
        Text(locationMessage.toString()),
        SizedBox(
          height: 20,
          width: 10,
        ),
        ElevatedButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MapScreen()));
        }, child: Text("Map")),
        Text(locationMessage.toString()),
        SizedBox(
          height: 20,
          width: 10,
        ),
        imagefile != null
            ? Container(
          child: Image.file(imagefile),
        )
            : Container(
          child: Icon(
            Icons.camera_enhance_rounded,
            color: Colors.green,
            size: MediaQuery.of(context).size.width * .6,
          ),
        ),
      ]),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        children: [
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.upload),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Upload From Gallery',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _getFromGallery();
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Open Camera',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _getFromCamera();
            },
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.location_on),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: 'Get Location ',
            labelStyle: TextStyle(fontSize: 18.0),

            onTap: () {
              _getlocation();
              setState(() {
                locationMessage = 'latitute : $lat  ,longitude : $long';
              });
            }
            ,
            onLongPress: () => print('THIRD CHILD LONG PRESS'),

          ),

        ],
      ),



    );
  }
}