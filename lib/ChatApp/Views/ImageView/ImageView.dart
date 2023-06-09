import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';

class ImageView extends StatefulWidget {
  final String? ImagePath;
  const ImageView({required this.ImagePath, Key? key}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  List<Widget> buttomList = [
    const Icon(
      Icons.download,
      color: Colors.white,
    ),
    //const Icon(Icons.print),
    // const Icon(Icons.share),
  ];

  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20.0), // Add margin to the boundary for better zooming experience
          minScale: 0.5, // Set the minimum scale level
          maxScale: 4.0, // Set the maximum scale level
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                fit: BoxFit.contain,
                // image: FileImage(File(widget.ImagePath!))
                image: NetworkImage(widget.ImagePath!),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(
            buttomList.length,
            (index) {
              return FloatingActionButton(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  heroTag: "$index",
                  onPressed: () async {
                    switch (index) {
                      case 0:
                        log('download image');
                        try {
                          log('Image Url: ${widget.ImagePath!}');
                          await GallerySaver.saveImage(widget.ImagePath!,
                                  albumName: 'Chat With Me')
                              .then((success) {
                            if (success != null && success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Download Successfully ")));
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                        break;
                      case 1:
                        log('Print image');
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Can't Print")));
                        break;
                      case 2:
                        log('Share image');
                        imagePaths.add(widget.ImagePath!);
                        Share.shareFiles(imagePaths);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Can't Share")));
                        break;
                    }
                  },
                  child: buttomList[index]);
            },
          ),
        ),
      ),
    );
  }
}
