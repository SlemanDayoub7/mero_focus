import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/subject.dart';
import '../constants/subject_palette.dart';
import '../controllers/planner_actions.dart';

/// Create or edit a subject and pick its color from the shared palette.
/// Pass [subject] to edit an existing one.
class SubjectEditorSheet extends ConsumerStatefulWidget {
  const SubjectEditorSheet({super.key, this.subject});

  final Subject? subject;

  @override
  ConsumerState<SubjectEditorSheet> createState() => _SubjectEditorSheetState();
}

class _SubjectEditorSheetState extends ConsumerState<SubjectEditorSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.subject?.name ?? '',
  );
  late int? _colorIndex = _initialColorIndex();

  int? _initialColorIndex() {
    final subject = widget.subject;
    if (subject == null) return 0;
    final index = SubjectPalette.colors.indexWhere(
      (color) =>
          SubjectPalette.toHex(color).toLowerCase() ==
          subject.colorHex.toLowerCase(),
    );
    return index < 0 ? null : index;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final existing = widget.subject;
    final index = _colorIndex;
    final colorHex = index != null
        ? SubjectPalette.toHex(SubjectPalette.colors[index])
        : (existing?.colorHex ?? SubjectPalette.toHex(SubjectPalette.colors[0]));

    final actions = ref.read(plannerActionsProvider);
    final Future<void> result = existing == null
        ? actions.addSubject(name, colorHex)
        : actions.updateSubject(
            Subject(id: existing.id, name: name, colorHex: colorHex),
          );
    unawaited(
      result.then((_) {
        if (mounted) Navigator.of(context).pop();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editing = widget.subject != null;
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
          Text(
            editing ? l10n.subjectsEdit : l10n.subjectsNew,
            style: Theme.of(context).textTheme.titleLarge,
          ),
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
            runSpacing: 8,
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
              AppButton(
                label: editing ? l10n.actionSave : l10n.actionAdd,
                onPressed: _save,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
