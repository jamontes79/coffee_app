import 'package:coffee_app/coffee/presentation/coffee_page.dart';
import 'package:coffee_app/coffee/presentation/favourite_coffees_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoffeeRoutes {
  static const String homePage = '/';
  static const String favouritesPage = '/favourites';

  static RouterConfig<Object>? get generateRoutes {
    return GoRouter(
      initialLocation: homePage,
      routes: [
        GoRoute(
          path: homePage,
          builder: (context, state) {
            return const CoffeePage();
          },
          routes: [
            GoRoute(
              path: favouritesPage,
              builder: (context, state) {
                return const FavouriteCoffeesPage();
              },
            ),
          ],
        ),
      ],
    );
  }
}
