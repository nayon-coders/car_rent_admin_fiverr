import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/widgets/app_text.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

import '../../dashboard.dart';
import '../../firebase/car_controller/car_controller.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_toast.dart';
import '../../widgets/image_controller.dart';
class AddNewCategory extends StatefulWidget {
  const AddNewCategory({super.key});

  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}

class _AddNewCategoryState extends State<AddNewCategory> {
  Uint8List? _unitCarImage;

  final _firestore = FirebaseFirestore.instance;

  final _category = TextEditingController();

  bool _isAddNew = true;

  bool _isLoading = false;

  DocumentSnapshot? _existingCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Category",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xff383838),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _isAddNew? _creteNewCategoryForm() : _editCategory(document: _existingCategory!),
              ),
            ),
            SizedBox(width: 30,),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: _firestore.collection("category").snapshots(),
                    builder: (_, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      }else if(snapshot.hasData){
                        return ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: double.infinity),
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text("ID")),
                              DataColumn(label: Text("Image")),
                              DataColumn(label: Text("Name")),
                              DataColumn(label: Text("Date")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: snapshot.data!.docs.map<DataRow>((DocumentSnapshot document){
                              return DataRow(
                                //color: MaterialStateProperty.all(Colors.grey[200]),
                                  cells: [
                                    DataCell(Text( document["id"])),
                                    DataCell(AppNetworkImage(imageUrl: document['image'], width: 50, height: 50,)),
                                    DataCell(Text(document['category'])),
                                    DataCell(Text(document['createdAt'])),

                                    DataCell(Row(
                                      children: [ 
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.amber,),
                                          onPressed: (){
                                            setState(() {
                                              _existingCategory = document;
                                              _isAddNew = false;
                                            });
                                          },
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red,),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(
                                                            "Are you sure?"),
                                                        content: Text(
                                                            "Do you want to delete this category?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: ()=> CarController.deleteCategory(docId: document.id, context: context),
                                                            child: Text("Delete"),
                                                          )
                                                        ],
                                                      )
                                              );
                                            }
                                        ),

                                      ],
                                    ))
                                  ]
                              );
                            }).toList(),
                          ),
                        );
                      }else{
                        return Center(child: Text("No car found"));
                      }
                    },
                  )
              ),
            )
          ],
        )
      ),
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
          _unitCarImage =
              Base64Decoder().convert(reader.result.toString().split(",").last);
        });

      });
      reader.readAsDataUrl(file);

    });
  }

  //create new category form
  Widget _creteNewCategoryForm() {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appTitle(text: "Create new category", context: context),
        SizedBox(height: 20,),
        Text("Create New Category",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 14),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: _category,
          decoration: InputDecoration(
            hintText: "Add Category",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Text("Car image",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 14),
        ),
        SizedBox(height: 10,),
        InkWell(
          onTap: ()=>startWebFilePicker(),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
                child: _unitCarImage != null ? Image.memory(_unitCarImage!)
                    : Text("No image selected", style: TextStyle(color: Colors.black),)
            ),
          ),
        ),
        SizedBox(height: 20,),
        ElevatedButton(
          child: Text("Add Category"),
          onPressed: ()async{
            var image;
            await ImageController.uploadImageToFirebaseStorage(_unitCarImage!, "category_image").then((value) {
              setState(() {
                image = value;
              });
              CarController.addCategory(category: _category.text, image: image, context: context).then((value) {
                if(value){
                  _category.clear();
                  _unitCarImage?.clear();
                }
              });
            });

          },
        ),
      ],
    );
  }

  //edit new category form
  Widget _editCategory({required DocumentSnapshot document}) {
    _category.text = document['category'];
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appTitle(text: "Edit category", context: context),
        SizedBox(height: 20,),
        Text("Create New Category",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 14),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: _category,
          decoration: InputDecoration(
            hintText: "Edit Category",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        SizedBox(height: 20,),
        Text("Car image",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 14),
        ),
        SizedBox(height: 10,),
        InkWell(
          onTap: ()=>startWebFilePicker(),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
                child: _unitCarImage != null ? Image.memory(_unitCarImage!)
                    : document["image"].isNotEmpty ? AppNetworkImage(imageUrl: document["image"])
                    : Text("No image selected", style: TextStyle(color: Colors.black),)
            ),
          ),
        ),
        SizedBox(height: 20,),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
          ),
          child: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,)) : Text("Edit Category"),
          onPressed: ()async{
            setState(() => _isLoading = true);
            var image;
            if(_unitCarImage != null){
              await ImageController.uploadImageToFirebaseStorage(_unitCarImage!, "category_image").then((value) {
                setState(() {
                  image = value;
                });
              });
            }else{
              image = document["image"];
            }

           await CarController.editCategory(category: _category.text, image: image, docId: document.id, context: context).then((value) {
              if(value){
                _category.clear();
                _unitCarImage?.clear();
                _isAddNew = true;
              }
            });

            setState(() => _isLoading = false);
          },
        ),
      ],
    );
  }

}


