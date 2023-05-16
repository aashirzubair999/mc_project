import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ImageDisplay extends StatefulWidget {
  final String userId;

  const ImageDisplay({required this.userId});

  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('images')
            .where('UID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('Loading...');
          }
          return GridView.builder(

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data();
              print("Done");
              return Container(
                margin: EdgeInsets.all(5),
                child: (data as Map<String, dynamic>)?['imageUrl'] != null
                    ? Image.network(data['imageUrl'])
                    : SizedBox(), // Return an empty SizedBox if 'url' is null or if the cast to Map fails
              );


            },
          );
        },
      ),
    );
  }
}