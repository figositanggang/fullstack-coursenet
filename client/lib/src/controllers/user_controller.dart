import 'package:client/src/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final Rx<UserModel> _currentUser = UserModel(
    id: 0,
    username: "",
    password: "",
    image: "",
    createdAt: "",
    updatedAt: "",
  ).obs;

  UserModel get currentUser => _currentUser.value;

  void setCurrentUser(UserModel user) {
    _currentUser.value = user;
  }
}
