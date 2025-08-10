import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_error_widget.dart';
import 'package:coffee_app/coffee/presentation/widgets/favorite_coffees_widget.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteCoffeesPage extends StatelessWidget {
  const FavouriteCoffeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<FavouriteCoffeeBloc, FavouriteCoffeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.favouriteCoffeesTitle),
          ),
          body: switch (state.status) {
            FavouriteCoffeeStatus.loading ||
            FavouriteCoffeeStatus.initial => const Center(
              child: CircularProgressIndicator(),
            ),
            FavouriteCoffeeStatus.error => const CoffeeErrorWidget(),
            FavouriteCoffeeStatus.loaded ||
            FavouriteCoffeeStatus.toggleError => FavoriteCoffeesWidget(
              favouriteCoffees: state.favouriteCoffees,
            ),
          },
        );
      },
    );
  }
}
