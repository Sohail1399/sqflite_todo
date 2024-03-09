import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite_todo/user_model.dart';
import 'db_helper_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseHelper _databaseHelper;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late List<ProductModel> productList;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    titleController.clear();
    descriptionController.clear();
    _databaseHelper = DatabaseHelper();
    productList = [];
    _refreshProductList();
  }

  void _refreshProductList() async {
    List<ProductModel> products = await _databaseHelper.getData();
    setState(() {
      productList = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "SqfLite Crud",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(productList[index].title),
                    subtitle: Text(productList[index].description),
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(productList[index].image)),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String value) {
                        if (value == 'edit') {
                          _showAddDialog(product: productList[index]);
                        } else if (value == 'delete') {
                          _deleteProduct(productList[index]);
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog({ProductModel? product}) {
    if (product != null) {
      titleController.text = product.title;
      descriptionController.text = product.description;
      if (product.image.isNotEmpty) {
        imageFile = File(product.image);
      }
    } else {
      titleController.clear();
      descriptionController.clear();
      imageFile = null;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        imagePicker().then((value) {
                          setState(() {});
                        });
                      },
                      child: imageFile == null
                          ? Icon(Icons.photo, size: 50)
                          : CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child: Image.file(
                            imageFile!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Enter Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        if (product == null) {
                          _saveProduct();
                        } else {
                          _updateProduct(product);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(product == null ? 'Save' : 'Update'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveProduct() async {
    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      String imagePath = '';
      if (imageFile != null) {
        imagePath = imageFile!.path;
      }
      ProductModel product = ProductModel(
        title: titleController.text,
        description: descriptionController.text,
        image: imagePath,
        id: null,
      );
      await _databaseHelper.inset(product);
      titleController.clear();
      descriptionController.clear();
      _refreshProductList();
    }
  }

  void _updateProduct(ProductModel product) async {
    if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      String imagePath = '';
      if (imageFile != null) {
        imagePath = imageFile!.path;
      }
      ProductModel updatedProduct = ProductModel(
        title: titleController.text,
        description: descriptionController.text,
        image: imagePath,
        id: product.id,
      );
      await _databaseHelper.updateData(updatedProduct);
      setState(() {
        titleController.clear();
        descriptionController.clear();
        _refreshProductList();
      });
    }
  }

  Future<void> imagePicker() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image picked successfully')));
    } else {
      print("Image Selection Failed");
    }
  }

  void _deleteProduct(ProductModel product) async {
    await _databaseHelper.deleteData(product.id!);
    _refreshProductList();
  }
}
