import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCoffeesWidget extends StatefulWidget {
  const FavoriteCoffeesWidget({
    required this.favouriteCoffees,
    super.key,
  });

  final List<Coffee> favouriteCoffees;

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
    final l10n = context.l10n;
    if (widget.favouriteCoffees.isEmpty) {
      return Center(child: Text(l10n.coffeesEmpty));
    }
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.favouriteCoffees.length,
      itemBuilder: (context, index) {
        final coffee = widget.favouriteCoffees[index];
        final isFavourite = widget.favouriteCoffees.contains(coffee);
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  IconButton(
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                    ),
                    iconSize: 32,
                    onPressed: () {
                      context.read<FavouriteCoffeeBloc>().add(
                        ToggleFavouriteCoffeeEvent(coffee),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CachedNetworkImage(
                    imageUrl: coffee.url,
                    width: 300,
                    height: 400,
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
