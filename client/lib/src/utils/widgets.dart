import 'package:client/src/controllers/user_controller.dart';
import 'package:client/src/models/product_model.dart';
import 'package:client/src/pages/product/update_product_page.dart';
import 'package:client/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyText extends StatelessWidget {
  final String data;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? letterSpacing;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;

  const MyText(
    this.data, {
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.letterSpacing,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: overflow,
        letterSpacing: letterSpacing,
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enableBorder;
  final int? maxLines;
  final bool autofocus;
  final void Function(String value)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.autovalidateMode,
    this.suffixIcon,
    this.obscureText = false,
    this.autofocus = false,
    this.enableBorder = true,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      autovalidateMode: autovalidateMode,
      obscureText: obscureText,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      validator: (value) {
        if (value!.isEmpty) {
          return "Masih kosong...";
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withOpacity(.25)),
        ),
        enabledBorder: enableBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black.withOpacity(.25)),
              )
            : InputBorder.none,
        suffixIcon: suffixIcon,
      ),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onChanged: onChanged,
    );
  }
}

class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isPrimary;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const MyButton({
    super.key,
    required this.onPressed,
    this.isPrimary = false,
    this.padding,
    this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: backgroundColor ??
            (isPrimary ? Theme.of(context).colorScheme.primary : Colors.white),
        foregroundColor:
            isPrimary ? Colors.black : Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: child,
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel productModel;
  final void Function()? onDelete;
  final void Function()? onEdit;

  const ProductCard({
    super.key,
    required this.productModel,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.parse(productModel.createdAt);
    final userGet = Get.put(UserController());

    final imageUrl = productModel.image.replaceAll("uploads/", "");
    final createdAt =
        "${dateTime.day}-${MONTHS[dateTime.month - 1]}-${dateTime.year}";

    return Column(
      children: [
        Ink(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              // Get.to(ProductDetailPage(productId: productModel.id));
              showDialog(
                context: context,
                builder: (context) => MyDialog.content(
                  context,
                  title: "Product Detail",
                  content: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  InteractiveViewer(
                                    child: Image.network("$BASE_URL/$imageUrl"),
                                  ),
                                );
                              },
                              child: Ink.image(
                                image: NetworkImage("$BASE_URL/$imageUrl"),
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            )),
                        const SizedBox(height: 10),
                        Text("Name\t\t\t\t\t\t\t\t\t: ${productModel.name}"),
                        MyText(
                            "Quantity\t\t\t\t\t: ${productModel.quantity}pcs"),
                        MyText("Created At\t: $createdAt"),
                      ],
                    ),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 5, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // @ Product image
                        Container(
                          height: double.infinity,
                          width: 150 - 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage("$BASE_URL/$imageUrl"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // @ Product name and quantity
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                productModel.name,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              MyText(
                                "${productModel.quantity}pcs",
                                color: Colors.black.withOpacity(.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      if (onEdit == null && onDelete == null) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // @ Edit Button
                          IconButton(
                            onPressed: () {
                              Get.to(UpdateProductPage(
                                user: userGet.currentUser,
                                productModel: productModel,
                                onEdit: onEdit!,
                              ));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          // @ Delete Button
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MyDialog {
  // @ Loading  dialog
  static Widget loading(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  // @ Alert dialog
  static Widget alert(
    BuildContext context, {
    required String alertMessage,
    required void Function()? onYes,
  }) {
    return AlertDialog(
      title: MyText(alertMessage),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const MyText("No", color: Colors.black),
        ),
        MyButton(
          onPressed: onYes,
          isPrimary: true,
          padding: EdgeInsets.zero,
          child: const MyText("Yes", color: Colors.black),
        ),
      ],
    );
  }

  // @ Content dialog
  static Widget content(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(title, fontSize: 20, fontWeight: FontWeight.bold),
            content,
          ],
        ),
      ),
    );
  }
}

Route pageRoute(Widget page, BuildContext context) {
  return MaterialPageRoute(
    builder: (context) => page,
  );
}
