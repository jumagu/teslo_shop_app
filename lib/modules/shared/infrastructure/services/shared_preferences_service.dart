import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop/modules/shared/domain/domain.dart';

class SharedPreferencesService extends BaseLocalStorageService {
  @override
  Future<void> setItem<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (value) {
      case int _:
        prefs.setInt(key, value);
        break;

      case String _:
        prefs.setString(key, value);
        break;

      default:
        throw UnimplementedError(
          'Set operation not implemented for type: ${value.runtimeType}',
        );
    }
  }

  @override
  Future<T?> getItem<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();

    switch (T) {
      case const (int):
        return prefs.getInt(key) as T?;

      case const (String):
        return prefs.getString(key) as T?;

      default:
        throw UnimplementedError('Get operation not implemented for type $T');
    }
  }

  @override
  Future<bool> removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return await prefs.remove(key);
  }
}
