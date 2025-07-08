import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:B_Leaf_Detection/database.dart';
import 'package:B_Leaf_Detection/profil.dart';
import 'package:B_Leaf_Detection/utama.dart';
import 'package:B_Leaf_Detection/warna.dart';
import 'package:recase/recase.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  State<Riwayat> createState() => _riwayatState();
}

class _riwayatState extends State<Riwayat> {
  Future pickImage() async {
    pList = await DatabaseHelper.getAllProfile();
    setState(() {});
  }

  Future hapus(index) async {
    await DatabaseHelper.deleteItem(index);
    pickImage();
  }

  List<ProfileModel> pList = [];

  String? byte64String;

  void _showAlertDialog(BuildContext context, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            //width: 500,
            height: 350,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: MemoryImage(const Base64Decoder()
                        .convert(pList[index].image64bit!)),
                    fit: BoxFit.cover)),
          ),
        );
      },
    );
  }

  void _konfir_delete(BuildContext context, index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Iya"),
      onPressed: () {
        Navigator.pop(context);

        hapus(pList[index].id!);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Peringatan"),
      content: Text("Hapus Gambar?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  initState() {
    DatabaseHelper.getAllProfile();
    pickImage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: baru,
          title: Text('B-Leaf Detection', style: TextStyle(fontSize: 30)),
          //centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "History",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: pList.isNotEmpty ? pList.length : 1,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: pList.isNotEmpty
                              ? TextButton(
                                  onPressed: () {
                                    print("tekan");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: baru, width: 1),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [
                                            GestureDetector(
                                                onTap: () {
                                                  _showAlertDialog(
                                                      context, index);
                                                },
                                                child: Image.memory(
                                                    const Base64Decoder()
                                                        .convert(pList[index]
                                                            .image64bit!))),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              pList[index].name!.titleCase,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ]),
                                          GestureDetector(
                                              onTap: () {
                                                _konfir_delete(context, index);
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                size: 30,
                                                color: baru,
                                              )),
                                        ]),
                                  ))
                              : Text("Empty"),
                        );
                      }),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HalamanUtama()));
                    },
                    child: Container(
                      height: 60,
                      width: 300,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: baru,
                        border: Border.all(color: baru, width: 1),
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
                                "Back",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                          ]),
                    ))
              ],
            ),
          ),
        ));
  }
}
