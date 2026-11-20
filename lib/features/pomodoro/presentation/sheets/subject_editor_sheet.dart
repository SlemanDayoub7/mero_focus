import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_button.dart';
import '../constants/subject_palette.dart';
import '../controllers/planner_actions.dart';

/// Create a subject and pick its stable color from the shared palette.
class SubjectEditorSheet extends ConsumerStatefulWidget {
  const SubjectEditorSheet({super.key});

  @override
  ConsumerState<SubjectEditorSheet> createState() => _SubjectEditorSheetState();
}

class _SubjectEditorSheetState extends ConsumerState<SubjectEditorSheet> {
  final _controller = TextEditingController();
  int _colorIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    unawaited(
      ref
          .read(plannerActionsProvider)
          .addSubject(name, SubjectPalette.toHex(SubjectPalette.colors[_colorIndex]))
          .then((_) {
        if (mounted) Navigator.of(context).pop();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.subjectsNew, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              hintText: l10n.subjectsNameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (var index = 0; index < SubjectPalette.colors.length; index++)
                GestureDetector(
                  onTap: () => setState(() => _colorIndex = index),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: SubjectPalette.colors[index],
                    child: index == _colorIndex
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppButton(
                label: l10n.actionCancel,
                isSecondary: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              AppButton(label: l10n.actionAdd, onPressed: _save),
            ],
          ),
        ],
      ),
    );
  }
}
