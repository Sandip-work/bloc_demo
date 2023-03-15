import 'dart:convert';

import 'package:bloc_demo/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  late final SharedPreferences _instance;
  // More abstraction
  static const String usersPref = "usersPref";

  Future<SharedPreferences> init() async =>
      _instance = await SharedPreferences.getInstance();

  Future<bool> saveUserInfo(User userData)  {
    String user = json.encode(userData.toJson());
    return _instance.setString(usersPref, user);
  }

  User? getUserDataInfo()  {
    if (_instance.getString(usersPref) != null) {
      Map<String, dynamic> userDataMap = jsonDecode(_instance.getString(usersPref)!);
      User userDataModel = User.fromJson(userDataMap);
      return userDataModel;
    } else {
      return null;
    }
  }

  Future<bool> removeUserDataInfo() async {
    if (_instance.getString(usersPref) != null) {
      return _instance.remove(usersPref);
    } else {
      return false;
    }
  }

  bool getIsLogin() {
    return _instance.containsKey(usersPref);
  }

}