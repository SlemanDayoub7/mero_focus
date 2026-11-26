import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/core_providers.dart';
import '../../../../core/theme/app_accent.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../pomodoro/presentation/controllers/timer_extras_settings.dart';

/// The ten Focus Identities agreed for the app. Until dedicated artwork is
/// added, each persona uses a bundled atmospheric wallpaper with its own
/// accent, description and quote.
class _FocusIdentity {
  const _FocusIdentity({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.role,
    required this.roleAr,
    required this.description,
    required this.descriptionAr,
    required this.quote,
    required this.quoteAr,
    required this.color,
    required this.icon,
    required this.backgroundId,
    required this.category,
  });

  final String id;
  final String name;
  final String nameAr;
  final String role;
  final String roleAr;
  final String description;
  final String descriptionAr;
  final String quote;
  final String quoteAr;
  final Color color;
  final IconData icon;
  final String backgroundId;
  final bool category;

  String get title => category ? '$name · $role' : '$name · $roleAr';
}

const _identities = <_FocusIdentity>[
  _FocusIdentity(
    id: 'strategist', name: 'The Strategist', nameAr: 'المخطّط',
    role: 'Male identity', roleAr: 'شخصية رجالية',
    description: 'Plans with clarity and uses energy with intention.',
    descriptionAr: 'يفكر بوضوح ويعرف أين يضع طاقته.',
    quote: 'Think clearly. Act wisely.', quoteAr: 'فكّر بوضوح، وتصرّف بحكمة.',
    color: Color(0xFF718CFF), icon: Icons.insights, backgroundId: 'slate', category: true,
  ),
  _FocusIdentity(
    id: 'scholar', name: 'The Scholar', nameAr: 'الباحث',
    role: 'Male identity', roleAr: 'شخصية رجالية',
    description: 'Curious by nature, always searching for answers.',
    descriptionAr: 'فضولي بطبعه، يحب التعلم والبحث عن الإجابات.',
    quote: 'Knowledge is power.', quoteAr: 'المعرفة قوّة.',
    color: Color(0xFF55C6B8), icon: Icons.menu_book, backgroundId: 'forest', category: true,
  ),
  _FocusIdentity(
    id: 'creator', name: 'The Creator', nameAr: 'المبدع',
    role: 'Male identity', roleAr: 'شخصية رجالية',
    description: 'Sees possibilities where others see limits.',
    descriptionAr: 'يرى الإمكانيات فيما لا يراه الآخرون.',
    quote: 'Create beyond limits.', quoteAr: 'أبدع بلا حدود.',
    color: Color(0xFFB18CFF), icon: Icons.brush, backgroundId: 'nebula', category: true,
  ),
  _FocusIdentity(
    id: 'explorer', name: 'The Explorer', nameAr: 'المستكشف',
    role: 'Male identity', roleAr: 'شخصية رجالية',
    description: 'Welcomes the unknown and keeps moving forward.',
    descriptionAr: 'لا يخشى المجهول ويحب اكتشاف آفاق جديدة.',
    quote: 'Go beyond the ordinary.', quoteAr: 'تجاوز حدود المعتاد.',
    color: Color(0xFFE6A75B), icon: Icons.terrain, backgroundId: 'sand', category: true,
  ),
  _FocusIdentity(
    id: 'guardian', name: 'The Guardian', nameAr: 'الحارس',
    role: 'Male identity', roleAr: 'شخصية رجالية',
    description: 'Calm, steady and committed to the goal.',
    descriptionAr: 'هادئ وثابت ولا يتراجع عن أهدافه.',
    quote: 'Stay strong. Stay steady.', quoteAr: 'اثبت بقوة واستمر بثبات.',
    color: Color(0xFFE47783), icon: Icons.shield, backgroundId: 'rose', category: true,
  ),
  _FocusIdentity(
    id: 'architect', name: 'The Architect', nameAr: 'المهندسة',
    role: 'Female identity', roleAr: 'شخصية نسائية',
    description: 'Turns ideas into reality with thoughtful details.',
    descriptionAr: 'تحوّل الأفكار إلى واقع بتفاصيل مدروسة.',
    quote: 'Design your own future.', quoteAr: 'صمّمي مستقبلك بنفسك.',
    color: Color(0xFFE5A0BB), icon: Icons.architecture, backgroundId: 'dawn', category: false,
  ),
  _FocusIdentity(
    id: 'scientist', name: 'The Scientist', nameAr: 'العالمة',
    role: 'Female identity', roleAr: 'شخصية نسائية',
    description: 'Keeps asking questions and discovering what is next.',
    descriptionAr: 'لا تتوقف عن طرح الأسئلة واكتشاف الجديد.',
    quote: 'Stay curious.', quoteAr: 'حافظي على فضولك.',
    color: Color(0xFF72D5E5), icon: Icons.science, backgroundId: 'aurora', category: false,
  ),
  _FocusIdentity(
    id: 'warrior', name: 'The Warrior', nameAr: 'المحاربة',
    role: 'Female identity', roleAr: 'شخصية نسائية',
    description: 'Meets challenges with courage and determination.',
    descriptionAr: 'قوية الإرادة وتواجه الصعوبات بشجاعة.',
    quote: 'Courage over comfort.', quoteAr: 'الشجاعة قبل الراحة.',
    color: Color(0xFFA993FF), icon: Icons.bolt, backgroundId: 'nebula', category: false,
  ),
  _FocusIdentity(
    id: 'writer', name: 'The Writer', nameAr: 'الكاتبة',
    role: 'Female identity', roleAr: 'شخصية نسائية',
    description: 'Turns thoughts and feelings into words.',
    descriptionAr: 'تحوّل الأفكار والمشاعر إلى كلمات.',
    quote: 'Every idea begins somewhere.', quoteAr: 'لكل فكرة بداية.',
    color: Color(0xFFF29A83), icon: Icons.edit_note, backgroundId: 'rose', category: false,
  ),
  _FocusIdentity(
    id: 'sage', name: 'The Sage', nameAr: 'الحكيمة',
    role: 'Female identity', roleAr: 'شخصية نسائية',
    description: 'Finds strength in calm, focus and balance.',
    descriptionAr: 'تعرف قيمة الهدوء والتركيز والتوازن.',
    quote: 'Find calm. Find clarity.', quoteAr: 'اعثري على الهدوء والوضوح.',
    color: Color(0xFF9CC6A5), icon: Icons.self_improvement, backgroundId: 'ocean', category: false,
  ),
];

/// Select and personalize one of the ten Focus Identities.
class FocusScenesPage extends ConsumerStatefulWidget {
  const FocusScenesPage({super.key});

  @override
  ConsumerState<FocusScenesPage> createState() => _FocusScenesPageState();
}

class _FocusScenesPageState extends ConsumerState<FocusScenesPage> {
  static const _identityKey = 'focus_identity_id';
  static const _titleKey = 'focus_scene_title';
  static const _quoteKey = 'focus_scene_quote';

  late final TextEditingController _titleController;
  late final TextEditingController _quoteController;
  late String _selectedId;
  bool _saved = false;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';
  String _text(String ar, String en) => _isArabic ? ar : en;
  _FocusIdentity get _selected =>
      _identities.firstWhere((identity) => identity.id == _selectedId);

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    _selectedId = prefs.getString(_identityKey) ?? _identities.first.id;
    if (!_identities.any((identity) => identity.id == _selectedId)) {
      _selectedId = _identities.first.id;
    }
    _titleController = TextEditingController(
      text: prefs.getString(_titleKey) ?? '',
    );
    _quoteController = TextEditingController(
      text: prefs.getString(_quoteKey) ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  Future<void> _select(_FocusIdentity identity) async {
    setState(() {
      _selectedId = identity.id;
      _saved = false;
    });
    await ref.read(timerExtrasProvider.notifier).selectBuiltIn(
      BuiltInBackground.fromId(identity.backgroundId)!,
    );
    await ref.read(primaryAccentProvider.notifier).setAccent(
      _accentFor(identity),
    );
    await ref.read(sharedPreferencesProvider).setString(_identityKey, identity.id);
  }

  AppAccent _accentFor(_FocusIdentity identity) {
    // Use the nearest built-in accessible accent for the global app theme.
    return switch (identity.id) {
      'strategist' => AppAccent.indigo,
      'scholar' || 'sage' => AppAccent.teal,
      'creator' || 'warrior' => AppAccent.violet,
      'explorer' => AppAccent.amber,
      'guardian' || 'writer' => AppAccent.rose,
      'architect' => AppAccent.magenta,
      'scientist' => AppAccent.cyan,
      _ => AppAccent.defaultAccent,
    };
  }

  Future<void> _save() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_identityKey, _selectedId);
    await prefs.setString(_titleKey, _titleController.text.trim());
    await prefs.setString(_quoteKey, _quoteController.text.trim());
    if (mounted) setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    final identity = _selected;
    final scene = BuiltInBackground.fromId(identity.backgroundId)!;
    final title = _titleController.text.trim().isEmpty
        ? (_isArabic ? identity.nameAr : identity.name)
        : _titleController.text.trim();
    final quote = _quoteController.text.trim().isEmpty
        ? (_isArabic ? identity.quoteAr : identity.quote)
        : _quoteController.text.trim();

    return AppScaffold(
      transparentBackground: true,
      applySafeArea: false,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.xl,
        ),
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: identity.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(Icons.auto_awesome, color: identity.color),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(_text('هويات التركيز', 'Focus identities'), variant: AppTextVariant.title),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      _text('اختر الشخصية التي تلهم جلستك.', 'Choose the persona that inspires your session.'),
                      variant: AppTextVariant.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _IdentityPreview(
            identity: identity,
            background: scene.asset,
            title: title,
            quote: quote,
            isArabic: _isArabic,
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeading(_text('الشخصيات الرجالية', 'Male identities')),
          const SizedBox(height: AppSpacing.sm),
          _identityGrid(_identities.take(5).toList()),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeading(_text('الشخصيات النسائية', 'Female identities')),
          const SizedBox(height: AppSpacing.sm),
          _identityGrid(_identities.skip(5).toList()),
          const SizedBox(height: AppSpacing.lg),
          _SectionHeading(_text('تخصيص الهوية', 'Personalize identity')),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            onChanged: (_) => setState(() => _saved = false),
            decoration: InputDecoration(
              labelText: _text('اسم المشهد', 'Scene title'),
              hintText: _text(identity.nameAr, identity.name),
              prefixIcon: const Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _quoteController,
            minLines: 2,
            maxLines: 3,
            onChanged: (_) => setState(() => _saved = false),
            decoration: InputDecoration(
              labelText: _text('اقتباس (اختياري)', 'Quote (optional)'),
              hintText: _text(identity.quoteAr, identity.quote),
              prefixIcon: const Icon(Icons.format_quote),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: _save,
            icon: Icon(_saved ? Icons.check : Icons.bookmark_outline),
            label: Text(_saved
                ? _text('تم الحفظ', 'Saved')
                : _text('حفظ الهوية', 'Save identity')),
          ),
        ],
      ),
    );
  }

  Widget _identityGrid(List<_FocusIdentity> identities) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: identities.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.sm,
      childAspectRatio: 0.92,
    ),
    itemBuilder: (context, index) {
      final identity = identities[index];
      return _IdentityTile(
        identity: identity,
        isArabic: _isArabic,
        selected: identity.id == _selectedId,
        onTap: () => _select(identity),
      );
    },
  );
}

class _IdentityPreview extends StatelessWidget {
  const _IdentityPreview({
    required this.identity,
    required this.background,
    required this.title,
    required this.quote,
    required this.isArabic,
  });

  final _FocusIdentity identity;
  final String background;
  final String title;
  final String quote;
  final bool isArabic;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
    child: SizedBox(
      height: 230,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(background, fit: BoxFit.cover),
          ColoredBox(color: Colors.black.withValues(alpha: 0.58)),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(identity.icon, size: 32, color: identity.color),
                const SizedBox(height: AppSpacing.sm),
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w700,
                )),
                const SizedBox(height: AppSpacing.xs),
                Text('“$quote”', maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  )),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _IdentityTile extends StatelessWidget {
  const _IdentityTile({
    required this.identity,
    required this.isArabic,
    required this.selected,
    required this.onTap,
  });

  final _FocusIdentity identity;
  final bool isArabic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: isArabic ? identity.nameAr : identity.name,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.glassSurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: selected ? identity.color : AppColors.glassInkMuted.withValues(alpha: 0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Image.asset(
                      BuiltInBackground.fromId(identity.backgroundId)!.asset,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ColoredBox(color: Colors.black.withValues(alpha: 0.48)),
                  Center(
                    child: Icon(identity.icon, size: 44, color: identity.color),
                  ),
                  if (selected)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(Icons.check_circle, color: identity.color),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              isArabic ? identity.nameAr : identity.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white, fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              isArabic ? identity.roleAr : identity.role,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.glassInkMuted,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => AppText(label, variant: AppTextVariant.title);
}
