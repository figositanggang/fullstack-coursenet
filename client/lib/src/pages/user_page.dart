import 'dart:io';

import 'package:client/src/helpers/database_helper.dart';
import 'package:client/src/helpers/user_helper.dart';
import 'package:client/src/helpers/image_picker_helper.dart';
import 'package:client/src/models/image_model.dart';
import 'package:client/src/models/user_model.dart';
import 'package:client/src/utils/constants.dart';
import 'package:client/src/utils/methods.dart';
import 'package:client/src/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  final int userId;
  final void Function()? onEdit;
  final void Function() onLogout;

  const UserPage({
    super.key,
    required this.userId,
    this.onEdit,
    required this.onLogout,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future getUser;

  File? image;

  @override
  void initState() {
    super.initState();

    refresh();
  }

  void refresh() {
    setState(() {
      getUser = UserHelper.getUser(widget.userId);
    });
  }

  // ! Pick image
  void pickImage(UserModel userModel) async {
    final pickedImage = await ImagePickerHelper.pickImage();

    if (pickedImage == null) {
      return;
    }

    setState(() {
      image = pickedImage;
    });

    final uploadImage = await UserHelper.uploadImage(image!);

    if (uploadImage['status'] == "SUCCESS") {
      final uploadedImage = ImageModel.fromMap(uploadImage['body']);

      final updateUser = await UserHelper.updateUser(
        id: widget.userId,
        username: userModel.username,
        password: userModel.password,
        image: uploadedImage.path,
      );

      if (updateUser['status'] == "SUCCESS") {
        await DatabaseHelper.updateUser(
          UserModel(
            id: userModel.id,
            username: userModel.username,
            password: userModel.password,
            image: uploadedImage.path,
            createdAt: userModel.createdAt,
            updatedAt: userModel.updatedAt,
          ),
        ).then((value) {
          Methods.showSnackBar(context, content: "Profile Picture updated");
        });
      }

      widget.onEdit!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Page"),
      ),
      body: FutureBuilder(
        future: getUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material();
          }

          if (!snapshot.hasData || snapshot.data["status"] == "FAILED") {
            return const Center(
              child: Text("Failed to get user"),
            );
          }

          final UserModel userModel = UserModel.fromMap(snapshot.data["body"]);
          final createdAt = DateTime.parse(userModel.createdAt).toLocal();
          return RefreshIndicator(
            onRefresh: () async {
              refresh();
            },
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // @ User profile image
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Builder(
                          builder: (context) {
                            if (image == null && userModel.image == "") {
                              return IconButton(
                                onPressed: () {
                                  pickImage(userModel);
                                },
                                icon: const Center(
                                    child: Icon(
                                  Icons.person,
                                  size: 72,
                                )),
                              );
                            }
                            if (image == null) {
                              return IconButton(
                                onPressed: () {
                                  pickImage(userModel);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                icon: Image.network(
                                    "$BASE_URL/${userModel.image.replaceAll("uploads/", "")}"),
                              );
                            }

                            return Image.file(image!);
                          },
                        ),
                      ),

                      const SizedBox(width: 20),

                      // @ User details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userModel.username),
                          MyText(
                            "Join at ${createdAt.day} ${MONTHS[createdAt.month - 1]} ${createdAt.year}",
                            color: Colors.black.withOpacity(.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: MyButton(
          onPressed: () {
            UserHelper.logout().then((value) {
              widget.onLogout();
              Get.back();
            });
          },
          backgroundColor: Colors.red,
          child: const MyText("Logout", color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
