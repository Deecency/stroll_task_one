import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stroll/l10n/l10n.dart';
import 'package:stroll/shared/pods/locale_pod.dart';

///This widget can be used to change the local in a popup
class AppLocalePopUp extends ConsumerWidget {
  const AppLocalePopUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<Locale>(
      initialValue: AppLocalizations.supportedLocales.first,
      icon: const Icon(Icons.translate),
      // Callback that sets the selected popup menu item.
      onSelected: (locale) {
        ref.read(localePod.notifier).changeLocale(locale: locale);
      },
      itemBuilder: (BuildContext context) => AppLocalizations.supportedLocales.map(
        (e) {
          final currentLocale = ref.watch(localePod);
          return PopupMenuItem<Locale>(
            value: e,
            child: e == currentLocale
                ? SelectedLocaleItem(
                    locale: e,
                    key: ValueKey('selected ${e.languageCode}'),
                  )
                : UnselectedLocaleItem(
                    locale: e,
                    key: ValueKey('unselected ${e.languageCode}'),
                  ),
          );
        },
      ).toList(),
    );
  }
}

class SelectedLocaleItem extends StatelessWidget {
  const SelectedLocaleItem({
    required this.locale,
    super.key,
  });
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.check,
          color: Colors.green,
        ),
        Text(
          getLanguageName(locale),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class UnselectedLocaleItem extends StatelessWidget {
  const UnselectedLocaleItem({
    required this.locale,
    super.key,
  });
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return Text(
      getLanguageName(locale),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

String getLanguageName(Locale e) {
  final languageMap = {
    'en': 'English',
    'es': 'Spanish',
  };
  return languageMap[e.languageCode] ?? 'Unknown language';
}
