import 'package:client/src/controllers/user_controller.dart';
import 'package:client/src/helpers/product_helper.dart';
import 'package:client/src/models/product_model.dart';
import 'package:client/src/pages/category/categories_page.dart';
import 'package:client/src/pages/product/add_product_page.dart';
import 'package:client/src/pages/user_page.dart';
import 'package:client/src/utils/constants.dart';
import 'package:client/src/utils/methods.dart';
import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final void Function() onLogout;
  final void Function()? onUserEdit;

  const HomePage({
    super.key,
    required this.onLogout,
    this.onUserEdit,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future getProducts;

  final userGet = Get.put(UserController());

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {
    setState(() {
      getProducts = ProductHelper.getProducts();
    });
  }

  void deleteProduct(ProductModel productModel) async {
    final response = await ProductHelper.deleteProduct(
      id: productModel.id,
      imageUrl: productModel.image,
    );

    Get.back();

    if (response["status"] != "SUCCESS") {
      return null;
    }

    if (mounted) Methods.showSnackBar(context, content: "Product Deleted");
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            Ink(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: userGet.currentUser.image != ""
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "$BASE_URL/${userGet.currentUser.image.replaceAll("uploads/", "")}"),
                      )
                    : null,
              ),
              child: InkWell(
                onTap: () {
                  Get.to(UserPage(
                    userId: userGet.currentUser.id,
                    onEdit: widget.onUserEdit,
                    onLogout: widget.onLogout,
                  ));
                },
                customBorder: const CircleBorder(),
                child: userGet.currentUser.image == ""
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
          ],
        ),
        title: const Text("Storage Management"),
        actions: [
          PopupMenuButton(
            offset: const Offset(-10, 0),
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("Categories"),
                  onTap: () {
                    Get.to(const CategoriesPage());
                  },
                ),
                PopupMenuItem(
                  child: const Text("Add Product"),
                  onTap: () {
                    Methods.navigateTo(
                        AddProductPage(
                          user: userGet.currentUser,
                          onAdded: () {
                            refresh();
                          },
                        ),
                        context);
                  },
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text("An error occurred"),
            );
          }

          if (snapshot.data["body"].length == 0) {
            return const Center(
              child: Text("No products found"),
            );
          }

          final products = snapshot.data["body"] as List;

          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final productModel = ProductModel.fromMap(products[index]);

                  return ProductCard(
                    productModel: productModel,
                    onEdit: refresh,
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) => MyDialog.alert(
                          context,
                          alertMessage: "Are you sure?",
                          onYes: () {
                            deleteProduct(productModel);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
