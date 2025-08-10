import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_card_widget.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeIndividualWidget extends StatelessWidget {
  const CoffeeIndividualWidget({
    required this.coffee,

    super.key,
  });

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<CoffeeBloc, CoffeeState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CoffeeCardWidget(coffee: coffee),
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
    );
  }
}
