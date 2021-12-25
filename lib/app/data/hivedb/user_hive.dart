import 'package:flash_chat/app/data/model/user.dart';
import 'package:hive/hive.dart';

class UserHive {
  final box = Hive.box('userhive');
  static const String userHive = 'userhive';

  UserModel getdata(int index) {
    return box.getAt(index);
  }

  UserModel? getdataKey(String model) {
    return box.get(model);
  }

  void adddata(UserModel model) {
    if (getdataKey(model.userid!) != null) {
      null;
    } else {
      box.put(model.userid, model);
    }
  }

  void delete(int index) {
    box.deleteAt(index);
  }
}
