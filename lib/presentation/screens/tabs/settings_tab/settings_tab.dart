import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/my_text_style.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../provider/provider.dart';

typedef OnChanged = void Function(String?);

class SettingsTab extends StatefulWidget {
  SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  late String selectedTheme;
  late String selectedLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var provider = Provider.of<SettingsProvider>(context, listen: false);

    selectedTheme = provider.currentTheme == ThemeMode.light
        ? AppLocalizations.of(context)!.lightMode
        : AppLocalizations.of(context)!.darkMode;

    selectedLang = provider.currentLanguage == 'en'
        ? AppLocalizations.of(context)!.englishApp
        : AppLocalizations.of(context)!.arabicApp;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SettingsProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.theme,
            style: MyTextStyle.settingsTabLabel,
          ),
          const SizedBox(height: 4),
          buildSettingsTabComponent(
            AppLocalizations.of(context)!.lightMode,
            AppLocalizations.of(context)!.darkMode,
            selectedTheme,
                (newTheme) {
              provider.setTheme(
                newTheme == AppLocalizations.of(context)!.lightMode
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
              setState(() {
                selectedTheme = newTheme!;
              });
            },
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.language,
            style: MyTextStyle.settingsTabLabel,
          ),
          const SizedBox(height: 4),
          buildSettingsTabComponent(
            AppLocalizations.of(context)!.englishApp,
            AppLocalizations.of(context)!.arabicApp,
            selectedLang,
                (newLang) {
              provider.setLanguage(
                newLang == AppLocalizations.of(context)!.englishApp
                    ? 'en'
                    : 'ar',
              );
              setState(() {
                selectedLang = newLang!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildSettingsTabComponent(
      String item1, String item2, String textView, OnChanged onChanged) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(width: 1, color: ColorsManager.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(textView, style: MyTextStyle.selectedItemLabel),
          DropdownButton<String>(
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(12),
            value: textView,
            items: <String>[item1, item2].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
