import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constans.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:async/async.dart';
//  import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart' as http;
import '../models/subkategori.dart';
import 'dart:io';

class FormProdukPage extends StatefulWidget {
  const FormProdukPage({Key? key}) : super(key: key);

  @override
  _FormProdukPageState createState() => _FormProdukPageState();
}

class _FormProdukPageState extends State<FormProdukPage> {
  TextEditingController txtnama = TextEditingController();
  TextEditingController txtdeskripsi = TextEditingController();
  TextEditingController txtharga = TextEditingController();
  ImagePicker picker = ImagePicker();
  String? _valsubkategori;
  File? _image;
  List<Subkategori> subkategorilist = [];
  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  loadingProses(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<List<Subkategori>> fetchKategori() async {
    List<Subkategori> usersList = [];
    var params = "/subkategori";
    var sUrl = Uri.parse(Palette.sUrl + params);
    try {
      var jsonResponse = await http.get(sUrl);
      if (jsonResponse.statusCode == 200) {
        //dbHelper.deletekategori();
        final jsonItems =
            json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

        usersList = jsonItems.map<Subkategori>((json) {
          //dbHelper.insertkategori(Kategori.fromJson(json));
          return Subkategori.fromJson(json);
        }).toList();

        setState(() {
          subkategorilist = usersList;
        });
      }
    } catch (e) {
      usersList = subkategorilist;
    }
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Palette.bg1,
    ));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text('Form Produk', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.bg1,
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 0, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Kategori',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 10, left: 12.0, bottom: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                fillColor: Colors.black,
                                filled: false),
                            hint: const Text("Pilih Kategori"),
                            value: _valsubkategori,
                            items: subkategorilist.map((item) {
                              return DropdownMenuItem(
                                child: Text(item.kategori.toString() +
                                    ' - ' +
                                    item.nama.toString()),
                                value: item.id.toString(),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _valsubkategori = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Judul',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: txtnama,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 16),
                            enabled: true,
                            autofocus: true,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 10, left: 12.0, bottom: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                fillColor: Colors.black,
                                filled: false),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Deskripsi',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: txtdeskripsi,
                            keyboardType: TextInputType.multiline,
                            minLines: 4,
                            maxLines: 4,
                            style: const TextStyle(fontSize: 16),
                            enabled: true,
                            autofocus: true,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 10, left: 12.0, bottom: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                fillColor: Colors.black,
                                filled: false),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Harga',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: txtharga,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(fontSize: 16),
                            enabled: true,
                            autofocus: true,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                    top: 10, left: 12.0, bottom: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                fillColor: Colors.black,
                                filled: false),
                          ),
                        ],
                      ),
                    ),
                    // ignore: avoid_unnecessary_containers
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin:
                                const EdgeInsets.only(bottom: 10, right: 10.0),
                            height: 140.0,
                            width: MediaQuery.of(context).size.width,
                            child: _image == null
                                ? const Text('No image selected.')
                                : Image.file(_image!),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _imgFromCamera,
                                child: Container(
                                  width: 60.0,
                                  height: 40.0,
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: const Icon(Icons.add_a_photo,
                                      color: Colors.blue),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0) //
                                        ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: _imgFromGallery,
                                child: Container(
                                  width: 60.0,
                                  height: 40.0,
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: const Icon(Icons.image,
                                      color: Colors.blue),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0) //
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    InkWell(
                      onTap: () => _klikupload(context),
                      child: SizedBox(
                        height: 60.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          shadowColor: Colors.blue[800],
                          color: Palette.menuNiaga,
                          elevation: 7.0,
                          child: const Center(
                            child: Text(
                              'SIMPAN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext main, String msg, String flag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: flag == "Err"
              ? const Text("Peringatan")
              : const Text("Informasi"),
          content: SelectableText(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                if (flag == "Err") {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pop(main);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _klikupload(BuildContext context) async {
    if (txtnama.text.trim() == "") {
      _showDialog(context, 'Maaf, Judul Kosong', 'Err');
    } else if (txtdeskripsi.text.trim() == "") {
      _showDialog(context, 'Maaf, Deskripsi Kosong', 'Err');
    } else {
      loadingProses(context);
      var params = "/postimages";
      {
        var stream =
            http.ByteStream(DelegatingStream.typed(_image!.openRead()));
        //var stream = new http.ByteStream(_image.openRead()).cast();
        var length = await _image!.length();
        var uri = Uri.parse(Palette.sUrl + params);
        var request = http.MultipartRequest("POST", uri);

        request.fields['idsubkategori'] = _valsubkategori.toString();
        request.fields['judul'] = txtnama.text.trim();
        request.fields['deskripsi'] = txtdeskripsi.text.trim();
        request.fields['harga'] = txtharga.text.trim();

        if (_image.toString().isEmpty || _image == null) {
          request.fields["attachment"] = "";
        } else {
          request.fields["attachment"] = "1";
          var pic = await http.MultipartFile.fromPath("file", _image!.path);
          request.files.add(pic);
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);

          debugPrint(responseString.toString());

          // if (response.toString() == "OK") {
          if (responseString == "OK") {
            _showDialog(context, "Data Berhasil Di Simpan", 'Info');
          } else {
            _showDialog(context, responseString, 'Error');
          }
        }
      }
    }
  }
}
