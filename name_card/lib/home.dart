import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:name_card/save_and_share.dart';
import 'package:screenshot/screenshot.dart';

import 'about.dart';

class EditCard extends StatefulWidget {
  static const routeName = '/edit';

  const EditCard({Key? key}) : super(key: key);

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  late Color cardColor;
  late Color textColor;
  late String name;
  late String syllables;
  late String connotation;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    name = "[Name]";
    syllables = "pro-nun-ci-a-tion";
    connotation = "name connotation or meaning";
    cardColor = Colors.yellowAccent;
    textColor = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.pushNamed(context, About.routeName);
            },
          )
        ],
        title: Text("Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text("Tap on text to change content"),
                Screenshot(
                    controller: screenshotController,
                    child: _nameCard(context)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                GestureDetector(
                  onTap: () {

                    setState(() {
                      if (textColor == Colors.black)
                        textColor = Colors.white;
                      else
                        textColor = Colors.black;
                    });
                  },
                  child: Column(
                    children: [
                      Text("Change Text Color",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.tonality, size: 48))),
                    ],
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      final Color newColor = await showColorPickerDialog(
                        context,
                        cardColor,
                        title: Text('Pick a color',
                            style: TextStyle(color: textColor)),
                        width: 40,
                        height: 40,
                        spacing: 8,
                        runSpacing: 8,
                        borderRadius: 4,
                        colorCodeHasColor: true,
                        enableShadesSelection: false,
                        pickersEnabled: <ColorPickerType, bool>{
                          ColorPickerType.accent: true,
                          ColorPickerType.primary: false,
                        },
                        actionButtons: const ColorPickerActionButtons(
                          okButton: true,
                          dialogActionButtons: false,
                        ),
                      );

                      setState(() {
                        cardColor = newColor;
                      });
                    },
                    child: Column(
                      children: [
                        Text("Change Color",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.palette,
                                    size: 48, color: cardColor))),
                      ],
                    )),
              ],
            ),
            SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                    onPressed: () async {
                      final Uint8List image = await screenshotController
                          .captureFromWidget(_nameCard(context));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SaveAndShare(imageFile: image, name: name)));
                    },
                    child: Text("Create Card", style: TextStyle(fontSize: 18))))
          ],
        ),
      ),
    );
  }

  Card _nameCard(BuildContext context) {
    return Card(
      color: cardColor,
      child: Container(
          width: 300,
          height: 300,
          child: Column(
            children: [
              Spacer(flex: 2),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () => _showMyDialog("Name", name,(String text) {
                            setState(() {
                              setState(() {
                                name = text;
                              });
                              Navigator.pop(context);
                            });
                          }),
                      child: Text(name.capitalize,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: textColor,
                              fontSize: 24, fontWeight: FontWeight.bold)))),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                      onTap: () =>
                          _showMyDialog("Pronunciation", syllables, (String text) {
                            setState(() {
                              setState(() {
                                syllables = text;
                              });
                              Navigator.pop(context);
                            });
                          }),
                      child: Text("/${syllables.toLowerCase()}/",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: textColor,fontSize: 16)))),
              Expanded(
                flex: 4,
                child: GestureDetector(
                    onTap: () => _showMyDialog("Connotation", connotation, (String text) {
                          setState(() {
                            setState(() {
                              connotation = text;
                            });
                            Navigator.pop(context);
                          });
                        }),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(connotation,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textColor,
                                fontSize: 18, fontWeight: FontWeight.bold)))),
              ),
              Spacer(flex: 1),
            ],
          )),
    );
  }

  Future<void> _showMyDialog(String title, String defaultText, Function(String) onSubmitted) async {
    TextEditingController _controller = TextEditingController();
    _controller.text = defaultText;
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change $title"),
            content: TextField(
              onSubmitted: onSubmitted,
              textAlign: TextAlign.center,
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: <Widget>[
              Center(
                  child: TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }))
            ],
          );
        });
  }
}
