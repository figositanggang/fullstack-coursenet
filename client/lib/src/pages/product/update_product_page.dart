
import 'package:client/src/helpers/category_helper.dart';
import 'package:client/src/helpers/product_helper.dart';
import 'package:client/src/models/category_model.dart';
import 'package:client/src/models/product_model.dart';
import 'package:client/src/models/user_model.dart';
import 'package:client/src/utils/constants.dart';
import 'package:client/src/utils/methods.dart';
import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UpdateProductPage extends StatefulWidget {
  final UserModel user;
  final ProductModel productModel;
  final Function onEdit;

  const UpdateProductPage({
    super.key,
    required this.user,
    required this.productModel,
    required this.onEdit,
  });

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  late GlobalKey<FormState> formKey;

  late Future future;
  CategoryModel? selectedCategory;

  int categoryId = 0;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: widget.productModel.name);
    quantityController =
        TextEditingController(text: widget.productModel.quantity.toString());

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
      future = getAll();
    });
  }

  // ! Upload product
  void updateProduct() async {
    showDialog(
      context: context,
      builder: (context) => MyDialog.loading(context),
    );

    final response = await ProductHelper.updateProduct(
      id: widget.productModel.id,
      user: widget.user,
      categoryId: selectedCategory!.id,
      name: nameController.text.trim(),
      quantity: int.parse(quantityController.text.trim()),
    );

    await Future.delayed(const Duration(seconds: 1));
    Get.back();

    if (response == null) {
      if (mounted) {
        Methods.showSnackBar(context, content: "Failed Update Product");
      }
    }

    if (response["status"] == "SUCCESS") {
      if (mounted) {
        widget.onEdit();
        Methods.showSnackBar(context, content: "Product Updated");

        Get.back();
      }
    } else {
      if (mounted) {
        Methods.showSnackBar(context, content: "Failed Update Product");
      }
    }
  }

  Future getAll() async {
    final categories = await CategoryHelper.getCategories();
    final category =
        await CategoryHelper.getCategory(widget.productModel.categoryId);

    return {"category": category['body'], "categories": categories['body']};
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.productModel.image.replaceAll("uploads/", "");

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material();
        }

        final categories = snapshot.data!["categories"] as List;
        final category = CategoryModel.fromMap(snapshot.data!["category"]);
        final dropDownItems = categories.map((e) {
          final category0 = CategoryModel.fromMap(e);

          return DropdownMenuEntry(
            value: category0,
            label: category0.name,
          );
        }).toList();

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
                    // @ Product Image
                    SizedBox(
                      height: 200,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network("$BASE_URL/$imageUrl"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // @ Product Category
                    _Section(
                      title: "Product Category",
                      child: DropdownMenu<CategoryModel>(
                        hintText: category.name,
                        onSelected: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                        dropdownMenuEntries: dropDownItems,
                      ),
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

                    // @ Update Button
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

                          if (formKey.currentState!.validate()) {
                            return updateProduct();
                          }
                        },
                        isPrimary: true,
                        child: const MyText(
                          "Edit Product",
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
