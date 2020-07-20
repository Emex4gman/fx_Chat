import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateManager {
  static StateManager _stateManager;
  StateManager.createInstance();
  static SharedPreferences _sharedPreferencesInstance;
  static Box _fxChatBox;

  static String isLoggedInKey = "ISLOGGEDIN";
  static String userNameKey = "USERNAME";
  static String emailKey = "USEREMAIL";

  String myname;
  factory StateManager() {
    if (_stateManager == null) {
      _stateManager = StateManager.createInstance();
    }
    return _stateManager;
  }
  Future<SharedPreferences> get sharedPref async {
    if (_sharedPreferencesInstance == null) {
      _sharedPreferencesInstance = await initsharedPreferences();
    }
    return _sharedPreferencesInstance;
  }

  Future<Box> get fxChatBox async {
    if (_fxChatBox == null) {
      _fxChatBox = await initHive();
      // return Hive.box('fx_chat');
    }
    return Hive.box('fx_chat');
  }

  Future<SharedPreferences> initsharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<Box> initHive() async {
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    return await Hive.openBox('fx_chat');
  }

  Future<bool> saveUserIsloggedin(bool isUserLoggedIn) async {
    (await this.fxChatBox).put(isLoggedInKey, isUserLoggedIn);
    return (await this.sharedPref).setBool(isLoggedInKey, isUserLoggedIn);
  }

  Future<bool> saveUserUserName(String userName) async {
    (await this.fxChatBox).put(userNameKey, userName);

    return (await this.sharedPref).setString(userNameKey, userName);
  }

  Future<bool> saveUserEmail(String email) async {
    (await this.fxChatBox).put(emailKey, email);

    return (await this.sharedPref).setString(emailKey, email);
  }

  // get data from local
  Future<bool> getUserIsloggedin() async {
    (await this.fxChatBox).get(isLoggedInKey);
    return (await this.sharedPref).getBool(isLoggedInKey);
  }

  // get data from local
  Future<String> getUserUserName() async {
    this.myname = (await this.fxChatBox).get(userNameKey);
    return (await this.sharedPref).getString(userNameKey);
  }

  // get data from local
  Future<String> getUserEmail() async {
    (await this.fxChatBox).get(emailKey);
    return (await this.sharedPref).getString(emailKey);
  }
}
