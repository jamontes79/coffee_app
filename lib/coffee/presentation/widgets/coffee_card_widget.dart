import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeCardWidget extends StatelessWidget {
  const CoffeeCardWidget({
    required this.isFavourite,
    required this.coffee,
    super.key,
  });

  final bool isFavourite;
  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<FavouriteCoffeeBloc, FavouriteCoffeeState>(
      listener: (context, state) {
        if (state.status == FavouriteCoffeeStatus.toggleError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.toggleFavouriteCoffeeError,
              ),
            ),
          );
        }
      },
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
                    ToggleFavouriteCoffeeEvent(
                      coffee,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 400),
                child: CachedNetworkImage(
                  imageUrl: coffee.url,
                  width: 300,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: ColoredBox(color: Colors.grey),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
