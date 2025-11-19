// Diffable state mixin + utility
mixin DiffableState {
  Map<String, dynamic> toDiffMap();
}

class StateDiffUtil {
  static List<String> diff(DiffableState prev, DiffableState next) {
    final prevMap = prev.toDiffMap();
    final nextMap = next.toDiffMap();
    final keys = <String>{...prevMap.keys, ...nextMap.keys}.toList()..sort();
    final changes = <String>[];
    for (final k in keys) {
      final a = prevMap[k];
      final b = nextMap[k];
      if (!_valueEquals(a, b)) {
        changes.add('$k: ${_short(a)} -> ${_short(b)}');
      }
    }
    return changes;
  }

  static bool _valueEquals(Object? a, Object? b) {
    if (a == b) return true;
    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (!_valueEquals(a[i], b[i])) return false;
      }
      return true;
    }
    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (final key in a.keys) {
        if (!b.containsKey(key) || !_valueEquals(a[key], b[key])) return false;
      }
      return true;
    }
    return false;
  }

  static String _short(Object? v, {int max = 60}) {
    if (v == null) return 'null';
    final s = v.toString();
    if (s.length <= max) return s;
    return '${s.substring(0, max)}…';
  }
}
