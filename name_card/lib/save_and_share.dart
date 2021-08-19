import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class SaveAndShare extends StatelessWidget {
  static const routeName = '/save';

  final Uint8List imageFile;
  final String name;

  const SaveAndShare({Key? key, required this.imageFile, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Save And Share"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 320, child: Image.memory(imageFile)),
            SizedBox(height: 18),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 56),
                  ),
                    icon: Icon(Icons.save),
                    onPressed: () async {},
                    label: Text("Save to Gallery",
                        style: TextStyle(fontSize: 18))),
                SizedBox(height: 16),
                ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 56),
                    ),
                    icon: Icon(Icons.share),
                    onPressed: () async {
                      await saveAndShare(imageFile);
                    },
                    label: Text("Share", style: TextStyle(fontSize: 18))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/$name.png');
    image.writeAsBytes(bytes);

    final String text = "I made this from name card";
    await Share.shareFiles([image.path], text: text);
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();

    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", "_")
        .replaceAll(":", "_");
    final saveAs = "name_card_$name$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: saveAs);

    return result['filePath'];
  }
}
