import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart'
    as fav_coffee_bloc;
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart';
import 'package:coffee_app/coffee/domain/model/coffee.dart';
import 'package:coffee_app/coffee/presentation/widgets/coffee_individual_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../../_mock/application/mocked_coffee_bloc.dart';
import '../../../_mock/application/mocked_favourite_coffee_bloc.dart';
import '../../../helpers/helpers.dart';

void main() {
  const coffee = Coffee(url: 'https://example.com/espresso.jpg');
  final favouriteCoffees = [coffee];
  final mockedFavouriteCoffeesBloc = MockedFavouriteCoffeeBloc()
    ..mockState(
      fav_coffee_bloc.FavouriteCoffeeState(
        status: fav_coffee_bloc.FavouriteCoffeeStatus.loaded,
        favouriteCoffees: favouriteCoffees,
      ),
    );
  final mockedBloc = MockedCoffeeBloc()
    ..mockState(
      const CoffeeState(
        status: CoffeeStatus.loaded,
        coffee: coffee,
      ),
    );
  group(CoffeeIndividualWidget, () {
    testWidgets(
      'should render coffee card when coffee is not empty',
      (tester) async {
        await mockNetworkImages(
          () async => tester.pumpApp(
            _TesterWidget(
              mockedBloc,
              mockedFavouriteCoffeesBloc,
              coffee,
            ),
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
      'should call toggle favourite coffee when heart icon '
      'is tapped and belong to favourites',
      (tester) async {
        await mockNetworkImages(
          () async => tester.pumpApp(
            _TesterWidget(
              mockedBloc,
              mockedFavouriteCoffeesBloc,
              coffee,
            ),
          ),
        );

        expect(find.byType(IconButton), findsOneWidget);

        await tester.tap(find.byType(IconButton));
        await tester.pump(const Duration(seconds: 1));

        verify(
          () => mockedFavouriteCoffeesBloc.add(
            const fav_coffee_bloc.ToggleFavouriteCoffeeEvent(coffee),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should call load coffee when reload button is tapped',
      (tester) async {
        await mockNetworkImages(
          () async => tester.pumpApp(
            _TesterWidget(
              mockedBloc,
              mockedFavouriteCoffeesBloc,
              coffee,
            ),
          ),
        );

        expect(find.byType(IconButton), findsOneWidget);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        verify(
          () => mockedBloc.add(const LoadCoffeeEvent()),
        ).called(1);
      },
    );
  });
}

class _TesterWidget extends StatelessWidget {
  const _TesterWidget(
    this.coffeeBloc,
    this.favouriteCoffeeBloc,
    this.coffee,
  );
  final Coffee coffee;
  final CoffeeBloc coffeeBloc;
  final fav_coffee_bloc.FavouriteCoffeeBloc favouriteCoffeeBloc;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<fav_coffee_bloc.FavouriteCoffeeBloc>.value(
      value: favouriteCoffeeBloc,
      child: BlocProvider<CoffeeBloc>.value(
        value: coffeeBloc,
        child: CoffeeIndividualWidget(
          coffee: coffee,
        ),
      ),
    );
  }
}
