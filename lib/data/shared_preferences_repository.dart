import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  static const String _itemsKey = 'checklist_items';

  List<String>? _cachedItems;

  Future<List<String>> _loadItems() async {
    if (_cachedItems != null) {
      return _cachedItems!;
    }

    final prefs = await SharedPreferences.getInstance();
    _cachedItems = prefs.getStringList(_itemsKey) ?? [];
    return _cachedItems!;
  }

  Future<void> _saveItems(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_itemsKey, items);
    _cachedItems = List.from(items);
  }

  @override
  Future<int> getItemCount() async {
    final items = await _loadItems();
    return items.length;
  }

  @override
  Future<List<String>> getItems() async {
    return await _loadItems();
  }

  @override
  Future<void> addItem(String item) async {
    if (item.trim().isEmpty) {
      return;
    }

    final items = await _loadItems();
    final trimmedItem = item.trim();

    if (!items.contains(trimmedItem)) {
      items.add(item);
      await _saveItems(items);
    }
  }

  @override
  Future<void> deleteItem(int index) async {
    final items = await _loadItems();

    if (index >= 0 && index < items.length) {
      items.removeAt(index);
      await _saveItems(items);
    }
  }

  @override
  Future<void> editItem(int index, String newItem) async {
    if (newItem.trim().isEmpty) return;

    final items = await _loadItems();
    final trimmedNewItem = newItem.trim();

    if (index >= 0 && index < items.length && !items.contains(trimmedNewItem)) {
      items[index] = trimmedNewItem;
      await _saveItems(items);
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_itemsKey);
    _cachedItems = [];
  }
}
