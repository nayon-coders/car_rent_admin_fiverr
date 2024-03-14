import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/firebase/user_controller.dart';
import 'package:flutter_dashboard/widgets/app_input.dart';
import 'package:flutter_dashboard/widgets/app_network_image.dart';

import '../../../widgets/app_text.dart';

class SocialMediaView extends StatefulWidget {


  @override
  State<SocialMediaView> createState() => _SocialMediaViewState();
}

class _SocialMediaViewState extends State<SocialMediaView> {
  final _nameController = TextEditingController();

  final _urlController = TextEditingController();

  File? _image;

  Uint8List? _unitCarImage;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appTitle(text: "Social Media", context: context),
              ElevatedButton(
                onPressed: (){
                  _showMyDialog(context);
                },
                child: Text("Add New", style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
              ),

            ],
          ),
          SizedBox(height: 20,),
          SizedBox(
            height: 300,
            child: StreamBuilder(
              stream: UserController.getSocialMedia(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasData){
                  return snapshot.data!.docs != 0
                      ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          var data = snapshot.data!.docs[index]; //get data
                          return ListTile(
                            leading: AppNetworkImage(imageUrl: "${data["image"]}", width: 50, height: 50,),
                            title: appText(text: "${data["name"]}", context: context),
                            subtitle: appText(text: "${data["url"]}", context: context),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: (){},
                                    icon: Icon(Icons.edit, color: Colors.blue,),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      //show alert dialog
                                      AppAlertDialog.showAlertDialog(context, "Are you sure you want to delete this social media?", (){
                                        UserController.deleteSocialMedia(data.id, context);
                                      });
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red,),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ) : Center(child: Text("No data found",
                      style: TextStyle(color: Colors.white),),);
                }else{
                  return Center(child: Text("No data found"),);
                }
              }
            )
          )

        ]
      )
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add social media link'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      AppInput(
                        hintText: "Social Media Name",
                        controller: _nameController,
                        validator: (v){
                          if(v!.isEmpty){
                            return "Name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      AppInput(
                        hintText: "Social Media URL",
                        controller: _urlController,
                        validator: (v){
                          if(v!.isEmpty){
                            return "URL is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            startWebFilePicker();
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _unitCarImage != null
                              ? Image.memory(_unitCarImage!, fit: BoxFit.contain,)
                              : Center(child: Icon(Icons.cloud_upload, color: Colors.black, size: 50,),),
                        ),
                      ),
                      SizedBox(height: 30,),
                      ElevatedButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              UserController.addSocialMedia(name: _nameController.text, url: _urlController.text, image: _unitCarImage!, context: context).then((value){
                                _nameController.clear();
                                _urlController.clear();
                                _unitCarImage = null;

                              });
                            }
                          },
                          child: Text("Add")
                      )
                    ],
                  ),
                ),
              );
            }
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  startWebFilePicker() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      print("this is files === $files");
      final file = files![0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        setState(() {
          _unitCarImage = Base64Decoder().convert(reader.result.toString().split(",").last);
        });
      });
      reader.readAsDataUrl(file);


      print("_unitCarImage  ==== $file");
      print("_unitCarImage  ==== $_unitCarImage");

    });
    setState(() {

    });
  }
}
