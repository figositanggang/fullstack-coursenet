import 'dart:math';

import 'package:client/src/helpers/category_helper.dart';
import 'package:client/src/models/category_model.dart';
import 'package:client/src/pages/category/category_products.dart';
import 'package:client/src/utils/constants.dart';
import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future getCategories;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {
    setState(() {
      getCategories = CategoryHelper.getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: FutureBuilder(
        future: getCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final categories = snapshot.data["body"];
          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: categories.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                final category = CategoryModel.fromMap(categories[index]);

                return InkWell(
                  onTap: () {
                    Get.to(CategoryProduct(categoryId: category.id));
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: const Alignment(0, -4),
                        colors: [
                          RANDOM_COLORS.elementAt(
                              Random().nextInt(RANDOM_COLORS.length)),
                          Colors.white,
                        ],
                      ),
                      // color: RANDOM_COLORS
                      //     .elementAt(Random().nextInt(RANDOM_COLORS.length)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: MyText(
                        category.name,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
