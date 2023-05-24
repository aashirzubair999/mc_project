import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_final/Screens/gallery.dart';
import 'package:project_final/Screens/signin_screen.dart';

import 'map.dart';

class cameraAccess extends StatefulWidget {
  @override
  State<cameraAccess> createState() => _cameraAccessState();
}

class _cameraAccessState extends State<cameraAccess> {

  File? imagefile;


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
          .add({'imageUrl': url,'UID':FirebaseAuth.instance.currentUser!.uid,'lonitude':long,'latitude':lat});
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




  Future<Position> _getCurrentLocation() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled)
      {
        return Future.error('Location Service are disabled');
      }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied)
      {
        permission=await Geolocator.requestPermission();
        if(permission==LocationPermission.denied)
          {
            return Future.error('Location Service are disabled');
          }
      }
    return await Geolocator.getCurrentPosition();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        // title:  Text(locationMessage.toString(),style: TextStyle(fontSize: 12),),
      ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(

                height: 200, // Adjust the height as per your requirement
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),


              ),

              ListTile(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => cameraAccess()));
               },
                leading: Icon(
                  Icons.home,
                ),
                title: Text('Home'),
              ),
              ListTile(
               onTap: (){
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageDisplay(userId: FirebaseAuth.instance.currentUser!.uid)));
               },
               leading: Icon(
                 Icons.browse_gallery,
               ),
                title: Text('Gallery'),
              ),
              ListTile(
                 onTap: (){
                   DialogueofBoxshow(context);
                 },
               leading: Icon(
                 Icons.book,
               ),
                title: Text('User Guide'),
              ),


              ListTile(
                onTap: (){
                  if(long.isNotEmpty)
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MapScreen(long: double.parse(long), lat: double.parse(lat),)));
                    }else
                      {
                        DialogueofBoxshowerror(context,'Please First Take the Picture OR Press the Get Location Button ');
                      }

                },
                leading: Icon(
                  Icons.map,
                ),
                title: Text('Pesticides Shops'),
              ),

               ListTile(
               leading: Icon(
                 Icons.logout,
               ),
                title: Text('Logout'),
                 onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SigninScreen()));
                },
              ),
            ],
          ),
        ),
      body: ListView(children: [
        // ElevatedButton(onPressed: (){
        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageDisplay(userId: FirebaseAuth.instance.currentUser!.uid)));
        // }, child: Text("Gallery")),
        // Text(locationMessage.toString()),
        SizedBox(
          height: 20,
          width: 10,
        ),
        // ElevatedButton(onPressed: (){
        //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MapScreen(long: double.parse(long), lat: double.parse(lat),)));
        // }, child: Text("Map")),
        // Text(locationMessage.toString()),
        SizedBox(
          height: 20,
          width: 10,
        ),
        imagefile != null
            ? Container(
          child: Image.file(imagefile!),
        )
            : Container(
            child: Text("Upload image",textAlign: TextAlign.center, style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 19
            ), )
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
              // _getlocation();
              _getCurrentLocation().then((value)
              {
                lat='${value.latitude}';
                long='${value.longitude}';
                setState(() {
                  locationMessage = 'latitute : $lat  ,longitude : $long';
                });
              });
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
              // _getlocation();
              _getCurrentLocation().then((value)
              {
                lat='${value.latitude}';
                long='${value.longitude}';
                setState(() {
                  locationMessage = 'latitute : $lat  ,longitude : $long';
                });
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

void DialogueofBoxshow(BuildContext context) async{

  String name="Null";



  showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(

      title: Column(
        children: [
          Text("Reversed:"),
          Text("--1. Click on + icon on the main screen take a new picture or upload from gallery "),
          Text("--Once you take a picture it will automatically uploaded to our storage "),
          Text("--We will then pass it on to our ML models and you will be able to see the result generated and our confidence in those results being true."),
          Text("--Based on that you can take a decision to proceed with our diagnosis or not. "),
          Text("--Once the disease has been recognized, you will also be shown a list of pesticide shops near you. For that we will need access to your location. "),
          Text("--You can then buy required remedies from these shops. "),
        ],
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Back")),



      ],
    );
  });
}






Future DislofBoxshow(BuildContext context) async{



  return Column(
    children: [
      Text("1. Click on + icon on the main screen ake a new picture or upload from gallery"),
  Text("Once you take a picture it will automatically uploaded to our storage"),
  Text("We will then pass it on to our ML models and you will be able to see the result generated and our confidence in those results being true."),
  Text("Based on that you can take a decision to proceed with our diagnosis or not."),
  Text("Once the disease has been recognized, you will also be shown a list of pesticide shops near you. For that we will need access to your location."),
  Text("You can then buy required remedies from these shops."),

    ],

  );

}









void DialogueofBoxshowerror(BuildContext context,String message) async{

  String name="Null";
  showDialog(context: context, builder: (BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(message),
        ],
      ),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: Text("Back")),



      ],
    );
  });
}