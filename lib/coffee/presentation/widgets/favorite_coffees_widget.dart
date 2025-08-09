import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_card.dart';
import 'package:coffee_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

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
          child: CoffeeCard(isFavourite: isFavourite, coffee: coffee),
        );
      },
    );
  }
}
