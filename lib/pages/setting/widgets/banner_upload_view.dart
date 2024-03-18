import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../../../firebase/user_controller.dart';
import '../../../widgets/app_input.dart';
import '../../../widgets/app_network_image.dart';
import '../../../widgets/app_text.dart';

class BannerAddView extends StatefulWidget {
  const BannerAddView({super.key});

  @override
  State<BannerAddView> createState() => _BannerAddViewState();
}

class _BannerAddViewState extends State<BannerAddView> {

  Uint8List? _unitCarImage;

  final _formKey = GlobalKey<FormState>();
  var image;


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
                  appTitle(text: "App Banner Management", context: context),
                  ElevatedButton(
                    onPressed: (){
                      _showMyDialog(context, null);
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
                                        onPressed: ()=>_showMyDialog(context, data),
                                        icon: Icon(Icons.edit, color: Colors.blue,),
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          _showDeletePopup(data);
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


  //delete popup
  Future<void> _showDeletePopup(data) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure? Do you want to delete this social media?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                UserController.deleteSocialMedia(data.id, context);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog(context, data) async {
    if(data != null){
      image = data["image"];
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data != null ? "Edit social media" : "Add Social media links"),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
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
                                : image != null ? AppNetworkImage(imageUrl: image) : Center(child: Icon(Icons.cloud_upload, color: Colors.black, size: 50,),),
                          ),
                        ),
                        SizedBox(height: 30,),
                        ElevatedButton(
                          onPressed: (){
                            if(_formKey.currentState!.validate()){
                              if(data != null){

                              }else{
                                UserController.addBanner(status: "Active", image: _unitCarImage!, context: context).then((value){
                                  _unitCarImage = null;

                                });
                              }

                            }
                          },
                          child: Text("${data != null ? "Update" : "Add"}", style: TextStyle(color: Colors.white),),
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
