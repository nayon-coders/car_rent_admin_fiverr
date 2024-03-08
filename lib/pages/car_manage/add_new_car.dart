import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dashboard/firebase/car_controller/car_controller.dart';
import 'package:flutter_dashboard/widgets/app_input.dart';
import 'package:flutter_dashboard/widgets/app_network_image.dart';
import 'package:flutter_dashboard/widgets/app_toast.dart';
import 'package:flutter_dashboard/widgets/image_controller.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import '../../Responsive.dart';
import '../../widgets/app_text.dart';
import '../home/widgets/header_widget.dart';

class AddNewCar extends StatefulWidget {
  final DocumentSnapshot<Object?>? document;

  const AddNewCar({super.key, this.document});

  @override
  State<AddNewCar> createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _carKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _descriptions = TextEditingController();
  final _carType = TextEditingController();
  final _year = TextEditingController();
  final _transmission = TextEditingController();
  final _enginCapacity = TextEditingController();
  final _fuelType = TextEditingController();
  final _rentPrice = TextEditingController();

  Uint8List? _unitCarImage;

  bool _isLoading = false;

  final List<String> items = [
    "Hour", // "Day", "Week", "Month
    'Day',
    'Week',
    'Month',
  ];
  final List _categoryList = [];
  String? selectedValue;
var  selectedCategoryMap;
  String?  selectedCategory;

  List deliveryTime = [1];
  List<Map<String, dynamic>> _selectedRentTypeAndPrice = [];

  var exsitingData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCategoryList(); //get category list from firebase firestore

    if(widget.document != null) {

     setState(() {
       exsitingData = widget.document;
       _name.text = exsitingData!['name'];
       _descriptions.text = exsitingData!['descriptions'];
       _carType.text = exsitingData!['carType'];
       _year.text = exsitingData!['year'];
       _rentPrice.text = exsitingData!['rentPrice'];
       _fuelType.text = exsitingData!['fuelType'];
        _enginCapacity.text = exsitingData!['enginCapacity'];

     });
    }

  }

  //get category list from firebase firestore
  _getCategoryList() async{
    await FirebaseFirestore.instance.collection("category").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categoryList.add(element.data());
        });
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    SizedBox _height(BuildContext context) => SizedBox(
      height: Responsive.isDesktop(context) ? 30 : 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Car",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isMobile(context) ? 15 : 18),
                child: Form(
                  key: _carKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Responsive.isMobile(context) ? 5 : 18,
                      ),

                      appTitle(text: "${widget.document != null ? "Edit car information" : "Add a new car"} ", context: context),
                      _height(context),
                      AppInput(title: "Car Name", hintText: "Car Name", controller: _name),
                      _height(context),
                      AppInput(title: "Descriptions", hintText: "Descriptions", controller: _descriptions),
                      _height(context),
                      AppInput(title: "Car Type", hintText: "Car Type", controller: _carType),
                      _height(context),
                     Row(
                       children: [
                         Expanded(child: AppInput(title: "Year", hintText: "Year", controller: _year)),
                         SizedBox(width: 10,),
                          Expanded(child: AppInput(title: "Transmission", hintText: "Transmission", controller: _transmission)),
                       ],
                     ),
                      _height(context),
                      Row(
                        children: [
                          Expanded(child: AppInput(title: "Engin Capacity", hintText: "Engin Capacity", controller: _enginCapacity)),
                          SizedBox(width: 10,),
                          Expanded(child: AppInput(title: "Fuel Type", hintText: "Fuel Type", controller: _fuelType)),
                        ],
                      ),
                      _height(context),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.document != null ?  Text("Current Category: ${exsitingData != null ? exsitingData!['category']["category"] : ""}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                fontSize: 14),
                          ) : Text("Select Category",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                fontSize: 14),
                          ),
                          SizedBox(height: 10,),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Category',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: _categoryList.map((item) => DropdownMenuItem<String>(
                                value: item.toString(),
                                child: Text(
                                  item["category"],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                                  .toList(),
                              value: selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                                print("selectedCategory == ${selectedCategory}");
                              },
                              buttonStyleData:  ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 45,
                                  width: MediaQuery.of(context).size.width*0.39,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Theme.of(context).hintColor),
                                  )
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 45,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _height(context),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text("Select Delivery Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 14),
                              ),
                              SizedBox(height: 10,),
                              Center(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Text(
                                      'Select Delivery Time',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    items: items
                                        .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                    buttonStyleData:  ButtonStyleData(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      height: 45,
                                      width: MediaQuery.of(context).size.width*0.39,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Theme.of(context).hintColor),
                                      )
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 45,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10,),
                          Expanded(child: AppInput(title: "Rent Price", hintText: "100.00\$", controller: _rentPrice)),
                          SizedBox(width: 15,),
                          ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  _selectedRentTypeAndPrice.add({
                                    "rent_type": selectedValue,
                                    "rent_price": _rentPrice.text
                                  });
                                });
                              },
                              child: Text("Add")
                          ),
                        ],
                      ),

                      _height(context),
                      Text("Rent Type and Price",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: 14),
                      ),
                      SizedBox(height: 10,),
                      _selectedRentTypeAndPrice.length > 0 ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _selectedRentTypeAndPrice.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text("Rent Type: ${_selectedRentTypeAndPrice[index]["rent_type"]}"),
                            subtitle: Text("Rent Price: ${_selectedRentTypeAndPrice[index]["rent_price"]}"),
                            trailing: IconButton(
                              onPressed: (){
                                setState(() {
                                  _selectedRentTypeAndPrice.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete, color: Colors.red,),
                            ),
                          );
                        },
                      ) : Text("No rent type and price selected", style: TextStyle(color: Colors.white),),
                      _height(context),
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
                                : widget.document != null && widget.document!["image"] != null
                                ? AppNetworkImage(imageUrl: widget.document!["image"], width: 200, height: 200,)
                                : Text("No image selected", style: TextStyle(color: Colors.black),)
                          ),
                        ),
                      ),
                      _height(context),
                      ElevatedButton(
                        onPressed: ()=>_isLoading ? null : widget.document != null ? _editCar() : _addNewCar(), style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.green)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),): Text('${ widget.document != null ? "Edit Car" : "Add new car"} '),
                        ),
                      ),
                      _height(context),

                    ],
                  ),
                ),
              )
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

  // add new car into fierbase firestore in car controller
  _addNewCar() async{
    setState(() => _isLoading = true);
    int id = DateTime.now().millisecondsSinceEpoch;
    if(_carKey.currentState!.validate()) {

      // Clean the string to make it a valid JSON
      String cleanedDataString = selectedCategory
          !.replaceAll("{", "{\"")
          .replaceAll(": ", "\":\"")
          .replaceAll(", ", "\", \"")
          .replaceAll("}", "\"}");

      // Parse the string into a map
      Map<String, dynamic> category = jsonDecode(cleanedDataString);



      if (_unitCarImage == null) {
        AppToast.showToast("Please select car image", Colors.red);
        setState(() => _isLoading = false);
        return;
      }

      var image;
      await ImageController.uploadImageToFirebaseStorage(_unitCarImage!, "car").then((value) {
        setState(() {
          image = value;
        });
      });
      final data = {
        "id": id.toString(),
        "name": _name.text,
        "descriptions": _descriptions.text,
        "rating": [
          {
            "id" : id.toString(),
            "star": 5,
            "total": 1,
            "user": {
              "name": "Admin",
              "email": FirebaseAuth.instance.currentUser!.email,
            }
          }
        ],
        "carType": _carType.text,
        "year": _year.text,
        "transmission": _transmission.text,
        "enginCapacity": _enginCapacity.text,
        "fuelType": _fuelType.text,
        "image" : image,
        "category": category ?? "Car",
        "status" : "active",
        "rent_type" : _selectedRentTypeAndPrice,
        "rentPrice" : _rentPrice.text,
        "createdAt": DateFormat("dd-mm-yyyy").format(DateTime.now()),
        "createBy": FirebaseAuth.instance.currentUser!.email
      };
      await CarController.addNewCar(data: data, context: context);
    }
    setState(() => _isLoading = false);
  }



  _editCar() async{
    int id = DateTime.now().millisecondsSinceEpoch;
    setState(() => _isLoading = true);
    if(_carKey.currentState!.validate()) {

      // Clean the string to make it a valid JSON
      String cleanedDataString = selectedCategory
      !.replaceAll("{", "{\"")
          .replaceAll(": ", "\":\"")
          .replaceAll(", ", "\", \"")
          .replaceAll("}", "\"}");

      // Parse the string into a map
      Map<String, dynamic> category = jsonDecode(cleanedDataString);


      var image;
      if (_unitCarImage != null) {
        await ImageController.uploadImageToFirebaseStorage(
            _unitCarImage!, "car").then((value) {
          setState(() {
            image = value;
          });
        });
      } else {
        setState(() {
          image = widget.document!["image"];
        });
      }
      final data = {
        "id": id.toString(),
        "name": _name.text,
        "descriptions": _descriptions.text,
        "category": category ?? "Car",
        "carType": _carType.text,
        "year": _year.text,
        "transmission": _transmission.text,
        "enginCapacity": _enginCapacity.text,
        "fuelType": _fuelType.text,
        "image": image,
        "status": "active",
        "rent_type": selectedValue ?? "Hour",
        "rentPrice": _rentPrice.text,
        "createdAt": DateFormat("dd-mm-yyyy").format(DateTime.now()),
        "createBy": FirebaseAuth.instance.currentUser!.email
      };
      await CarController.editCar(data: data, docId: widget.document!.id, context: context);
    }
    setState(() => _isLoading = false);

  }
}
