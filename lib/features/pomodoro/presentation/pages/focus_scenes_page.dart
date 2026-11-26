import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../controllers/focus_scenes.dart';

class FocusScenesPage extends ConsumerStatefulWidget {
  const FocusScenesPage({super.key});

  @override
  ConsumerState<FocusScenesPage> createState() => _FocusScenesPageState();
}

class _FocusScenesPageState extends ConsumerState<FocusScenesPage> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _quote = TextEditingController();
  String? _imagePath;
  Color _accent = const Color(0xFF718CFF);
  bool _saving = false;

  static const _palette = <Color>[
    Color(0xFF718CFF),
    Color(0xFF55C6B8),
    Color(0xFFB18CFF),
    Color(0xFFE6A75B),
    Color(0xFFE47783),
    Color(0xFFE5A0BB),
    Color(0xFF72D5E5),
    Color(0xFFA993FF),
    Color(0xFFF29A83),
    Color(0xFF9CC6A5),
  ];

  bool get _isArabic =>
      WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ar';

  String _t(String ar, String en) => _isArabic ? ar : en;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _quote.dispose();
    super.dispose();
  }

  Future<void> _chooseImage() async {
    final path = await ref.read(focusScenesProvider.notifier).pickImage();
    if (path != null && mounted) setState(() => _imagePath = path);
  }

  Future<void> _save() async {
    if (_imagePath == null || _title.text.trim().isEmpty || _saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(focusScenesProvider.notifier).saveScene(
        title: _title.text,
        description: _description.text,
        quote: _quote.text,
        imagePath: _imagePath!,
        accentColor: _accent,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_t('تم حفظ المشهد وتفعيله', 'Scene saved and activated'))),
      );
      _title.clear();
      _description.clear();
      _quote.clear();
      setState(() {
        _imagePath = null;
        _accent = _palette.first;
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scenes = ref.watch(focusScenesProvider);
    final active = scenes.activeScene;
    return AppScaffold(
      transparentBackground: true,
      appBar: AppAppBar(title: _t('مشاهد التركيز', 'Focus Scenes')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppText(
            _t('اصنع شاشة التركيز التي تشبهك. اختر صورة ولوناً واكتب عنوانك واقتباسك.', 'Create a focus space that feels like yours. Choose an image, an accent, a title and a quote.'),
            variant: AppTextVariant.body,
          ),
          const SizedBox(height: AppSpacing.md),
          if (active != null) ...[
            _section(_t('المشهد النشط', 'Active scene')),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () => ref.read(focusScenesProvider.notifier).select(null),
                icon: const Icon(Icons.wallpaper_outlined),
                label: Text(_t('استخدام خلفية التطبيق', 'Use app background')),
              ),
            ),
            _SceneTile(
              scene: active,
              selected: true,
              onTap: () {},
              onDelete: () => ref.read(focusScenesProvider.notifier).delete(active.id),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          _section(_t('إنشاء مشهد جديد', 'Create a new scene')),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            onTap: _chooseImage,
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .55),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                image: _imagePath == null
                    ? null
                    : DecorationImage(image: FileImage(File(_imagePath!)), fit: BoxFit.cover),
              ),
              child: _imagePath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_photo_alternate_outlined, size: 34),
                        const SizedBox(height: AppSpacing.xs),
                        Text(_t('اختر صورة من جهازك', 'Choose a photo from your device')),
                      ],
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        color: Colors.black54,
                        child: Text(_t('اضغط لتغيير الصورة', 'Tap to change image'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _field(_title, _t('عنوان المشهد *', 'Scene title *'), _t('مثلاً: Midnight Study', 'e.g. Midnight Study')),
          _field(_description, _t('الوصف', 'Description'), _t('ما الذي يمثله هذا المشهد؟', 'What does this scene mean to you?')),
          _field(_quote, _t('الاقتباس', 'Quote'), _t('اكتب عبارة تلهمك', 'Write a line that inspires you'), maxLines: 2),
          const SizedBox(height: AppSpacing.sm),
          _section(_t('اللون الأساسي', 'Accent color')),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final color in _palette)
                InkWell(
                  onTap: () => setState(() => _accent = color),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _accent == color ? Colors.white : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: _accent == color
                          ? [BoxShadow(color: color.withValues(alpha: .4), blurRadius: 12)]
                          : null,
                    ),
                    child: _accent == color ? const Icon(Icons.check, size: 17, color: Colors.white) : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _saving || _imagePath == null || _title.text.trim().isEmpty ? null : _save,
            icon: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined),
            label: Text(_t('حفظ وتفعيل المشهد', 'Save and activate scene')),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (scenes.scenes.isNotEmpty) ...[
            _section(_t('مشاهدك المحفوظة', 'Your saved scenes')),
            const SizedBox(height: AppSpacing.sm),
            for (final scene in scenes.scenes)
              _SceneTile(
                scene: scene,
                selected: scene.id == scenes.activeSceneId,
                onTap: () => ref.read(focusScenesProvider.notifier).select(scene.id),
                onDelete: () => ref.read(focusScenesProvider.notifier).delete(scene.id),
              ),
          ],
        ],
      ),
    );
  }

  Widget _section(String text) => AppText(text, variant: AppTextVariant.title);

  Widget _field(TextEditingController controller, String label, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
        onChanged: (_) => setState(() {}),
      decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }
}

class _SceneTile extends StatelessWidget {
  const _SceneTile({
    required this.scene,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  final FocusScene scene;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(scene.imagePath), width: 52, height: 58, fit: BoxFit.cover),
        ),
        title: Text(scene.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(scene.quote.isEmpty ? scene.description : scene.quote, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: scene.accentColor, shape: BoxShape.circle)),
            if (selected) const Padding(padding: EdgeInsets.only(left: 8), child: Icon(Icons.check_circle, color: Colors.green)),
            IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Delete scene', onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
