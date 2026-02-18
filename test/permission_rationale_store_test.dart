import 'package:flutter_test/flutter_test.dart';
import 'package:mower_bot/core/platform/permission_rationale_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('PermissionRationaleStore marks rationale as shown once', () async {
    SharedPreferences.setMockInitialValues({});

    final store = PermissionRationaleStore();
    const key = 'location_when_in_use';

    expect(await store.wasShown(key), isFalse);

    await store.markShown(key);
    expect(await store.wasShown(key), isTrue);

    await store.reset(key);
    expect(await store.wasShown(key), isFalse);
  });
}

