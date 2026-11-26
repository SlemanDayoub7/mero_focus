import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_context.dart';

/// Asks for confirmation with the item's name and returns true only when the
/// user explicitly confirms.
/// Every delete in the app goes through this, so nothing is removed by an
/// accidental tap.
Future<bool> confirmDelete(BuildContext context, {required String name}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.delete_outline),
      title: Text(l10n.confirmDeleteTitle),
      content: Text(l10n.confirmDeleteBody(name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
            foregroundColor: Theme.of(dialogContext).colorScheme.onError,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.actionDelete),
        ),
      ],
    ),
  );
  return result ?? false;
}
