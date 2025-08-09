import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart'
    as fav_coffee_bloc;
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_card.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeIndividualWidget extends StatelessWidget {
  const CoffeeIndividualWidget({
    required this.coffee,
    required this.favouriteCoffees,
    super.key,
  });

  final Coffee coffee;
  final List<Coffee> favouriteCoffees;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<
      fav_coffee_bloc.FavouriteCoffeeBloc,
      fav_coffee_bloc.FavouriteCoffeeState
    >(
      listenWhen: (previous, current) {
        return previous.status != current.status ||
            previous.favouriteCoffees != current.favouriteCoffees;
      },
      listener: (context, state) {
        if (state.status == fav_coffee_bloc.FavouriteCoffeeStatus.loaded) {
          context.read<CoffeeBloc>().add(const RefreshFavouriteCoffeeEvent());
        }
      },
      child: BlocBuilder<CoffeeBloc, CoffeeState>(
        builder: (context, state) {
          final isFavourite = state.favouriteCoffees.contains(coffee);
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CoffeeCard(isFavourite: isFavourite, coffee: coffee),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoffeeBloc>().add(const LoadCoffeeEvent());
                    },
                    child: Text(l10n.coffeeReload),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
