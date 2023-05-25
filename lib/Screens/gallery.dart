import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImageDisplay extends StatefulWidget {
  final String userId;

  const ImageDisplay({required this.userId});

  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  String? selectedImageUrl;

  void onImageClicked(String imageUrl) {
    setState(() {
      selectedImageUrl = imageUrl;
    });
  }

  void closeImage() {
    setState(() {
      selectedImageUrl = null;
    });
  }

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
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0, // Set the desired aspect ratio
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data();
                      return GestureDetector(
                        onTap: () {
                          onImageClicked(data['imageUrl']);
                          IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('images')
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            },
                            icon: Icon(Icons.delete),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Container(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if ((data as Map<String, dynamic>)?['imageUrl'] != null)
                                  Positioned.fill(
                                    child: Image.network(
                                      data['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (selectedImageUrl != null)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: closeImage,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.all(20.0),
                          child: Image.network(selectedImageUrl!),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
