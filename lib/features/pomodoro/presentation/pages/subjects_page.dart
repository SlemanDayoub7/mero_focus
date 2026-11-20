import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_context.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../domain/entities/subject.dart';
import '../constants/subject_palette.dart';
import '../controllers/planner_actions.dart';
import '../controllers/planner_providers.dart';
import '../sheets/subject_editor_sheet.dart';

/// Manage subjects once, then pick them when adding tasks or sessions.
class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final subjectsAsync = ref.watch(subjectsProvider);

    return AppScaffold(
      appBar: AppAppBar(title: l10n.subjects),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.actionAdd,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => const SubjectEditorSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: subjectsAsync is! AsyncData<List<Subject>>
          ? const Center(child: CircularProgressIndicator())
          : subjectsAsync.value.isEmpty
          ? Center(child: AppText(l10n.subjectsEmpty))
          : ListView.builder(
              itemCount: subjectsAsync.value.length,
              itemBuilder: (context, index) {
                final subject = subjectsAsync.value[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 10,
                    backgroundColor: SubjectPalette.fromHex(subject.colorHex),
                  ),
                  title: AppText(subject.name),
                  trailing: IconButton(
                    tooltip: l10n.actionDelete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref
                        .read(plannerActionsProvider)
                        .removeSubject(subject.id!),
                  ),
                );
              },
            ),
    );
  }
}
