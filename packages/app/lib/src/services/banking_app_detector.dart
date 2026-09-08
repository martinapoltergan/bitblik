import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:ndk/shared/logger/logger.dart';

/// Slovak banking apps known to upload the device's installed-app list to their
/// servers. If any of these is present, the bank can see that Bitblik is installed
/// and may refuse a code withdrawal because of it.
///
/// The list is intentionally fixed and small: it is mirrored in the `<queries>`
/// block of AndroidManifest.xml, which is what makes the check possible without the
/// QUERY_ALL_PACKAGES permission. Adding an entry here without adding it there makes
/// that entry silently always-absent, so the two lists must be changed together.
const List<String> kSurveillingBankingPackages = <String>[
  'sk.tb.ib.tatraandroid',
  'sk.tb.emv.mobile',
  'com.slsp.mtoken',
  'sk.slsp.georgego',
  'sk.vub.banking',
  'sk.vub.mobile',
];

class BankingAppDetector {
  const BankingAppDetector({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('app.bitblik/installed_packages');

  final MethodChannel _channel;

  /// Which of [kSurveillingBankingPackages] are installed, in list order.
  ///
  /// Empty on every platform but Android, and empty on any failure: a broken or
  /// missing channel must never block startup or scare the user with a warning we
  /// cannot actually stand behind.
  Future<List<String>> installedBankingApps() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return const [];
    try {
      final found = await _channel.invokeListMethod<String>(
        'installedPackages',
        <String, Object?>{'packages': kSurveillingBankingPackages},
      );
      return found ?? const [];
    } catch (e) {
      Logger.log.w(() => 'banking app detection failed: $e');
      return const [];
    }
  }
}
