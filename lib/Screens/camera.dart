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

class CameraAccess extends StatefulWidget {
  @override
  State<CameraAccess> createState() => _CameraAccessState();
}

class _CameraAccessState extends State<CameraAccess> {
  int _currentIndex = 0;
  File? imageFile;
  late String locationMessage = '';
  late String long = "";
  late String lat = "";

  void _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    setState(() {
      this.imageFile = imageFile;
    });

    final path =
        'files/${DateTime.now().microsecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child(path);
    final uploadTask = mountainsRef.putFile(imageFile);

    uploadTask.whenComplete(() async {
      final url = await mountainsRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('images')
          .add({'imageUrl': url, 'UID': FirebaseAuth.instance.currentUser!.uid, 'longitude': long, 'latitude': lat});
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

    final imageFile = File(pickedFile.path);
    setState(() {
      this.imageFile = imageFile;
    });

    final path =
        'files/${DateTime.now().microsecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final storageRef = FirebaseStorage.instance.ref();
    final mountainsRef = storageRef.child(path);
    final uploadTask = mountainsRef.putFile(imageFile);

    uploadTask.whenComplete(() async {
      final url = await mountainsRef.getDownloadURL();
      print(url);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location Service is disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Service is disabled');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text('Pesticides Detection'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.greenAccent,
                Colors.green,
                Colors.greenAccent
              ],
              end: Alignment.bottomCenter,
            ),
          ),
        ),
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

                ],
              ),


            ),

            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CameraAccess()));
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
        imageFile != null
            ? Container(
          child: Image.file(imageFile!),
        )
            : Container(
          height: 250,
          width: 250,
          child: Center(
              child: Column(
                children: [
                  Image(image: AssetImage('assets/images/cameraplaceholder.png')),
                  Text('We are waiting for you to upload an Image',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold, ) ),

                ],
              )
          ),
        ),
      ]),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
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
          child: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                ),
                Text('Home'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.location_pin),
                  onPressed: () {
                    if(long.isNotEmpty)
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MapScreen(long: double.parse(long), lat: double.parse(lat),)));
                    }else
                    {
                      DialogueofBoxshowerror(context,'Please First Take the Picture OR Press the Get Location Button ');
                    }


                  },
                ),
                Text('Map'),
              ],
            ),
            SizedBox(width: 48), // Empty space for the center button
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.energy_savings_leaf),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ImageDisplay(userId: FirebaseAuth.instance.currentUser!.uid)));
                  },
                ),
              const  Text('My Plants'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                ),
               const  Text('Profile'),
              ],
            ),
          ],
        ),
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









