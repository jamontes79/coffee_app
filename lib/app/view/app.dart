import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/injection/injection.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/routes/routes.dart';
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
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: CoffeeRoutes.generateRoutes,
      ),
    );
  }
}
