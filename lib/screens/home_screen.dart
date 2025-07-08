import 'package:camera_gallery_image_picker/camera_gallery_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:B_Leaf_Detection/deteksi.dart';
import 'package:B_Leaf_Detection/riwayat.dart';
import 'dart:io';

import 'package:B_Leaf_Detection/warna.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

late ModelObjectDetection _objectModel;
final ImagePicker _picker = ImagePicker();
//load your model
Future loadModel() async {
  //String pathCustomModel = "assets/models/custom_model.ptl";
  String pathObjectDetectionModel = "assets/models/versi_final.torchscript";
  ;
  try {
    _objectModel = await PytorchLite.loadObjectDetectionModel(
        pathObjectDetectionModel, 3, 416, 416,
        labelPath: "assets/labels/data.txt");
  } catch (e) {
    if (e is PlatformException) {
      print("only supported for android, Error is $e");
    } else {
      print("Error is $e");
    }
  }
}

class _HalamanUtamaState extends State<HalamanUtama> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: baru,
          title: Text('B-Leaf Detection', style: TextStyle(fontSize: 30)),
          //centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 300.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/labels/Group44.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () async {
                            final File? image =
                                await CameraGalleryImagePicker.pickImage(
                                    context: context,
                                    source: ImagePickerSource.both,
                                    maxHeight: 416,
                                    maxWidth: 416);
                            if (image != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Deteksi(
                                          objmodelv1: _objectModel,
                                          gambar: image)));
                            }
                            ;
                          },
                          child: Container(
                            width: 300,
                            height: 60,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: baru,
                              border: Border.all(color: baru, width: 2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(45),
                              ),
                            ),
                            child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    Text(
                                      "Start detection",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                ]),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Riwayat()));
                          },
                          child: Container(
                            height: 60,
                            width: 300,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: baru, width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(45),
                              ),
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    Text(
                                      "History",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: baru,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                ]),
                          ))
                    ],
                  ),
                )),
            const SizedBox(
              height: 150,
            ),
            Container(
              height: 160.0,
              width: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/labels/keren.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
