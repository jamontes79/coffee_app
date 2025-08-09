import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeErrorWidget extends StatelessWidget {
  const CoffeeErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text(l10n.coffeeLoadError)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.read<CoffeeBloc>().add(const LoadCoffeeEvent());
          },
          child: Text(l10n.coffeeReload),
        ),
      ],
    );
  }
}
