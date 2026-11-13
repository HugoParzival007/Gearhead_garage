import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../features/garage/garage_bloc.dart';
import '../features/garage/garage_page.dart';
import 'theme.dart';

/// Root widget. Expects the repositories above it (see `main.dart`).
class DiarioApp extends StatelessWidget {
  const DiarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GarageBloc(vehicles: context.read(), selection: context.read())
            ..add(const GarageStarted()),
      child: MaterialApp(
        title: 'Diário de Garagem',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        // pt-BR from the start: date picker text and its dd/mm/aaaa input.
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('pt', 'BR')],
        locale: const Locale('pt', 'BR'),
        home: const GaragePage(),
      ),
    );
  }
}
