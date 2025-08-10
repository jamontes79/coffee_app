import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_error_widget.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_individual_widget.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:coffee_app/routes/routes.dart';
import 'package:coffee_app/theme/application/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const String favouriteCoffees = 'favouriteCoffees';
const String themeMode = 'themeMode';

class CoffeePage extends StatelessWidget {
  const CoffeePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.coffeePageTitle),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == favouriteCoffees) {
                    context.go(CoffeeRoutes.favouritesPage);
                  } else if (value == themeMode) {
                    context.read<ThemeBloc>().add(const ToggleThemeEvent());
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: favouriteCoffees,
                      child: Text(l10n.favouriteCoffeesTitle),
                    ),
                    PopupMenuItem<String>(
                      value: themeMode,
                      child: Text(l10n.themeModeTitle),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: switch (state.status) {
            CoffeeStatus.loading || CoffeeStatus.initial => const Center(
              child: CircularProgressIndicator(),
            ),
            CoffeeStatus.error => const CoffeeErrorWidget(),
            CoffeeStatus.loaded => CoffeeIndividualWidget(
              coffee: state.coffee,
            ),
          },
        );
      },
    );
  }
}
