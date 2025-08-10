import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_card_widget.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCoffeesWidget extends StatefulWidget {
  const FavoriteCoffeesWidget({
    super.key,
  });

  @override
  State<FavoriteCoffeesWidget> createState() => _FavoriteCoffeesWidgetState();
}

class _FavoriteCoffeesWidgetState extends State<FavoriteCoffeesWidget> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      FavouriteCoffeeBloc,
      FavouriteCoffeeState,
      List<Coffee>
    >(
      selector: (state) => state.favouriteCoffees,
      builder: (context, favouriteCoffees) {
        final l10n = context.l10n;
        if (favouriteCoffees.isEmpty) {
          return Center(
            child: Text(l10n.coffeesEmpty),
          );
        }
        return PageView.builder(
          controller: _pageController,
          itemCount: favouriteCoffees.length,
          itemBuilder: (context, index) {
            final coffee = favouriteCoffees[index];

            return Center(
              child: CoffeeCardWidget(coffee: coffee),
            );
          },
        );
      },
    );
  }
}
