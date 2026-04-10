import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    (locale: Locale('en'), label: 'English', native: 'English'),
    (locale: Locale('ko'), label: '한국어', native: 'Korean'),
    (locale: Locale('ja'), label: '日本語', native: 'Japanese'),
    (locale: Locale('zh'), label: '简体中文', native: 'Chinese (Simplified)'),
    (locale: Locale('zh', 'TW'), label: '繁體中文', native: 'Chinese (Traditional)'),
    (locale: Locale('vi'), label: 'Tiếng Việt', native: 'Vietnamese'),
    (locale: Locale('id'), label: 'Bahasa Indonesia', native: 'Indonesian'),
    (locale: Locale('ms'), label: 'Bahasa Melayu', native: 'Malay'),
    (locale: Locale('ru'), label: 'Русский', native: 'Russian'),
    (locale: Locale('tr'), label: 'Türkçe', native: 'Turkish'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Icon(Icons.language, size: 48, color: cs.primary),
              const SizedBox(height: 16),
              Text(
                'Select Language',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '언어를 선택하세요 / 言語を選択 / 选择语言',
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final lang = _languages[i];
                    final isSelected = currentLocale.languageCode ==
                            lang.locale.languageCode &&
                        currentLocale.countryCode == lang.locale.countryCode;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        await ref
                            .read(localeProvider.notifier)
                            .setLocale(lang.locale);
                        if (context.mounted) {
                          // onboarding flow → go, settings push → pop
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/onboarding');
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primaryContainer
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: cs.primary, width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? cs.onPrimaryContainer
                                          : cs.onSurface,
                                    ),
                                  ),
                                  Text(
                                    lang.native,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? cs.onPrimaryContainer
                                              .withValues(alpha: 0.7)
                                          : cs.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle,
                                  color: cs.primary, size: 22),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
