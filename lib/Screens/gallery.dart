import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageDisplay extends StatefulWidget {
  final String userId;

  const ImageDisplay({required this.userId});

  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

void gogo(var data) {
  Image.network(data['imageUrl']);
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
    return SafeArea( // Wrap the Scaffold with SafeArea
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                GridView.builder(

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data();
                    print("Done");
                    return GestureDetector(
                      onTap: () => onImageClicked(data['imageUrl']),
                      child: Container(

                        margin: EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            (data as Map<String, dynamic>)?['imageUrl'] != null
                                ? Image.network(data['imageUrl'])
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
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
                            margin: EdgeInsets.all(1.0),
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
      ),
    );
  }
}
