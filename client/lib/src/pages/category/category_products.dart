import 'package:client/src/helpers/product_helper.dart';
import 'package:client/src/models/product_model.dart';
import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';

class CategoryProduct extends StatefulWidget {
  final int categoryId;
  const CategoryProduct({super.key, required this.categoryId});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  late Future getProductsByCategory;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {
    setState(() {
      getProductsByCategory =
          ProductHelper.getProductsByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Products"),
      ),
      body: FutureBuilder(
        future: getProductsByCategory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data['status'] == "FAILED") {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if (snapshot.data["body"].length == 0) {
            return const Center(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Text("No products found"),
              ),
            );
          }

          final products = snapshot.data["body"];
          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            // child: Text(products.toString()),
            child: ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final productModel = ProductModel.fromMap(products[index]);

                return ProductCard(
                  productModel: productModel,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
