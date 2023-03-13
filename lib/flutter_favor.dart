
import 'flutter_favor_platform_interface.dart';

class FlutterFavor {
  Future<String?> getPlatformVersion() {
    return FlutterFavorPlatform.instance.getPlatformVersion();
  }
}
