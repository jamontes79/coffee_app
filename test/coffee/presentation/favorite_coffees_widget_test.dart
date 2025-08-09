import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/favorite_coffees_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../_mock/application/mocked_favourite_coffee_bloc.dart';
import '../../helpers/helpers.dart';

void main() {
  final mockedFavouriteCoffeesBloc = MockedFavouriteCoffeeBloc();

  group(FavoriteCoffeesWidget, () {
    testWidgets(
      'should render empty message when coffees list is empty',
      (tester) async {
        await tester.pumpApp(
          const FavoriteCoffeesWidget(favouriteCoffees: []),
        );

        final emptyMessageFinder = find.text('No coffees available');

        expect(emptyMessageFinder, findsOneWidget);
      },
    );

    testWidgets(
      'should render coffee card when coffees list is not empty',
      (tester) async {
        final coffees = [
          const Coffee(url: 'https://example.com/espresso.jpg'),
        ];

        await mockNetworkImages(
          () async => tester.pumpApp(
            FavoriteCoffeesWidget(favouriteCoffees: coffees),
          ),
        );

        expect(find.byType(Image), findsOneWidget);
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<CachedNetworkImageProvider>());
        expect(
          (image.image as CachedNetworkImageProvider).url,
          'https://example.com/espresso.jpg',
        );
      },
    );

    testWidgets(
      'should render multiple coffee cards when coffees list '
      'has multiple items and not call bloc to load more if there are '
      'more than 2 remaining items',
      (tester) async {
        final coffees = [
          const Coffee(url: 'https://example.com/espresso.jpg'),
          const Coffee(url: 'https://example.com/latte.jpg'),
          const Coffee(url: 'https://example.com/cappuccino.jpg'),
          const Coffee(url: 'https://example.com/americano.jpg'),
        ];

        mockedFavouriteCoffeesBloc.mockState(
          FavouriteCoffeeState(
            status: FavouriteCoffeeStatus.loaded,
            favouriteCoffees: coffees,
          ),
        );

        await mockNetworkImages(
          () async => tester.pumpApp(
            BlocProvider<FavouriteCoffeeBloc>.value(
              value: mockedFavouriteCoffeesBloc,
              child: FavoriteCoffeesWidget(
                favouriteCoffees: coffees,
              ),
            ),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                (widget.image as CachedNetworkImageProvider).url ==
                    'https://example.com/espresso.jpg',
          ),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                (widget.image as CachedNetworkImageProvider).url ==
                    'https://example.com/latte.jpg',
          ),
          findsNothing,
        );

        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pump(const Duration(seconds: 1));

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Image &&
                (widget.image as CachedNetworkImageProvider).url ==
                    'https://example.com/latte.jpg',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'should call toggle favourite coffee when heart icon '
      'is tapped and belong to favourites',
      (tester) async {
        final coffees = [
          const Coffee(url: 'https://example.com/espresso.jpg'),
        ];

        await mockNetworkImages(
          () async => tester.pumpApp(
            BlocProvider<FavouriteCoffeeBloc>.value(
              value: mockedFavouriteCoffeesBloc,
              child: FavoriteCoffeesWidget(
                favouriteCoffees: coffees,
              ),
            ),
          ),
        );

        expect(find.byType(IconButton), findsOneWidget);

        await tester.tap(find.byType(IconButton));
        await tester.pump(const Duration(seconds: 1));

        verify(
          () => mockedFavouriteCoffeesBloc.add(
            ToggleFavouriteCoffeeEvent(coffees.first),
          ),
        ).called(1);
      },
    );
  });
}
