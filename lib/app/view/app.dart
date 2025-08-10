import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/injection/injection.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:coffee_app/theme/application/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<FavouriteCoffeeBloc>()
                ..add(const LoadFavouriteCoffeesEvent()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<CoffeeBloc>()..add(const LoadCoffeeEvent()),
        ),
        BlocProvider(create: (context) => getIt<ThemeBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: state is ThemeLight ? ThemeMode.light : ThemeMode.dark,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: CoffeeRoutes.generateRoutes,
          );
        },
      ),
    );
  }
}
