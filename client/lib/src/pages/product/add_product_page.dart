import 'dart:io';

import 'package:client/src/helpers/category_helper.dart';
import 'package:client/src/helpers/image_picker_helper.dart';
import 'package:client/src/helpers/product_helper.dart';
import 'package:client/src/models/category_model.dart';
import 'package:client/src/models/user_model.dart';
import 'package:client/src/utils/methods.dart';
import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddProductPage extends StatefulWidget {
  final UserModel user;
  final Function onAdded;

  const AddProductPage({
    super.key,
    required this.user,
    required this.onAdded,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late GlobalKey<FormState> formKey;

  late Future getCategories;
  CategoryModel? selectedCategory;

  File? image;

  int categoryId = 0;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    quantityController = TextEditingController();

    refresh();
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();

    super.dispose();
  }

  void refresh() {
    setState(() {
      getCategories = CategoryHelper.getCategories();
    });
  }

  // ! Pick image
  void pickImage() async {
    final pickedImage = await ImagePickerHelper.pickImage();

    if (pickedImage == null) {
      return;
    }

    setState(() {
      image = pickedImage;
    });
  }

  // ! Upload product
  void uploadProduct() async {
    showDialog(
      context: context,
      builder: (context) => MyDialog.loading(context),
    );

    final response = await ProductHelper.uploadProduct(
      image!,
      user: widget.user,
      categoryId: selectedCategory!.id,
      name: nameController.text.trim(),
      quantity: int.parse(quantityController.text.trim()),
    );

    if (response == null) {
      if (mounted) Methods.showSnackBar(context, content: "Failed Add Product");
    }

    await Future.delayed(const Duration(seconds: 1));

    if (response["status"] == "SUCCESS") {
      if (mounted) {
        widget.onAdded();
        Methods.showSnackBar(context, content: "Product Added");
        Get.back();
        Get.back();
      }
    } else {
      if (mounted) Methods.showSnackBar(context, content: "Failed Add Product");
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material();
        }

        final categories = snapshot.data!["body"] as List;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add Product"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // @ Product Category
                    _Section(
                      title: "Product Category",
                      child: DropdownMenu(
                          hintText: "Category",
                          onSelected: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                          dropdownMenuEntries: categories.map((e) {
                            final category = CategoryModel.fromMap(e);

                            return DropdownMenuEntry(
                              value: category,
                              label: category.name,
                            );
                          }).toList()),
                    ),

                    // @ Product Name Field
                    _Section(
                      title: "Product Name",
                      child: MyTextField(controller: nameController),
                    ),

                    // @ Product Name Field
                    _Section(
                      title: "Product Quantity",
                      child: MyTextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),

                    // @ Product Image
                    _Section(
                      title: "Product Image",
                      child: Container(
                        height: 200,
                        padding:
                            image != null ? const EdgeInsets.all(10) : null,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Builder(
                          builder: (context) {
                            if (image == null) {
                              return InkWell(
                                onTap: () {
                                  pickImage();
                                },
                                child: const Opacity(
                                  opacity: .75,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.upload_rounded),
                                        Text("Pick image"),
                                        MyText(
                                          "(Choose wisely image cannot be changed!)",
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.file(
                                  image!,
                                  fit: BoxFit.contain,
                                ),
                                MyButton(
                                  onPressed: () {
                                    pickImage();
                                  },
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  isPrimary: true,
                                  child: const Text("Change Image"),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // @ Add Button
                    SizedBox(
                      width: double.infinity,
                      child: MyButton(
                        onPressed: () {
                          if (selectedCategory == null) {
                            return Methods.showSnackBar(
                              context,
                              content: "Category not selected",
                              isDanger: true,
                            );
                          }
                          if (image == null) {
                            return Methods.showSnackBar(
                              context,
                              content: "Image is required",
                              isDanger: true,
                            );
                          }

                          if (formKey.currentState!.validate()) {
                            return uploadProduct();
                          }
                        },
                        isPrimary: true,
                        child: const MyText(
                          "Add",
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final String title;

  final Widget child;

  const _Section({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 5),
        child,
        const SizedBox(height: 25),
      ],
    );
  }
}
