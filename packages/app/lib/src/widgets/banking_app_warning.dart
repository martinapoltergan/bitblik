import 'package:flutter/material.dart';

import '../../i18n/gen/strings.g.dart';

/// Shown at every start while a surveilling banking app is installed.
///
/// Deliberately not dismissible-and-remembered: the warning's presence is itself the
/// signal the text refers to ("if you see this at startup, the banking apps can see
/// Bitblik"). Hiding it after the first acknowledgement would take that signal away
/// exactly when it still applies.
Future<void> showBankingAppWarning(BuildContext context) {
  final t = Translations.of(context);
  return showDialog<void>(
    context: context,
    builder:
        (context) => AlertDialog(
          icon: const Icon(Icons.privacy_tip_outlined),
          title: Text(t.bankingApps.title),
          content: SingleChildScrollView(
            child: Text(t.bankingApps.warning),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.buttons.close),
            ),
          ],
        ),
  );
}
