import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/theme/app_spacing.dart';
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
  bool _saving = false;

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

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty || _saving) return;

    final existing = widget.subject;
    final index = _colorIndex;
    final colorHex = index != null
        ? SubjectPalette.toHex(SubjectPalette.colors[index])
        : (existing?.colorHex ??
              SubjectPalette.toHex(SubjectPalette.colors[0]));

    final actions = ref.read(plannerActionsProvider);
    final Future<void> result = existing == null
        ? actions.addSubject(name, colorHex)
        : actions.updateSubject(
            Subject(id: existing.id, name: name, colorHex: colorHex),
          );

    setState(() => _saving = true);
    try {
      await result;
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editing = widget.subject != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            editing ? l10n.subjectsEdit : l10n.subjectsNew,
            style: context.textStyles.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => unawaited(_save()),
            decoration: InputDecoration(labelText: l10n.subjectsNameHint),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (var index = 0; index < SubjectPalette.colors.length; index++)
                _Swatch(
                  color: SubjectPalette.colors[index],
                  selected: index == _colorIndex,
                  onTap: () => setState(() => _colorIndex = index),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppButton(
                label: l10n.actionCancel,
                isSecondary: true,
                onPressed: _saving ? null : () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              AppButton(
                label: _saving
                    ? l10n.statusSaving
                    : (editing ? l10n.actionSave : l10n.actionAdd),
                onPressed: _saving ? null : () => unawaited(_save()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A 48 dp colour choice with a selection mark that keeps its contrast on
/// every swatch: the check sits on a primary-container disc with an outline.
class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          width: AppSpacing.minTouchTarget,
          height: AppSpacing.minTouchTarget,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: Center(
            child: selected
                ? Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: context.colors.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.colors.outline),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 18,
                      color: context.colors.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
