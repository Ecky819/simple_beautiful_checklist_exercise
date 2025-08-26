import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  static const String _itemsKey = 'checklist_items';

  List<String>? _cachedItems;

  @override
  Future<List<String>> _loadItems() async {
    if (_cachedItems != null) {
      return _cachedItems!;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedItems = prefs.getStringList(_itemsKey) ?? [];
    return _cachedItems!;
  }
}
