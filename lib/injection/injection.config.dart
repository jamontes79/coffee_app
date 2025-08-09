// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:coffee_app/coffee/application/favourite/favourite_coffee_bloc.dart'
    as _i843;
import 'package:coffee_app/coffee/application/single/coffee_bloc.dart' as _i445;
import 'package:coffee_app/coffee/domain/use_case/add_favourite_coffee_use_case.dart'
    as _i998;
import 'package:coffee_app/coffee/domain/use_case/load_coffee_use_case.dart'
    as _i474;
import 'package:coffee_app/coffee/domain/use_case/load_favorite_coffees_use_case.dart'
    as _i521;
import 'package:coffee_app/coffee/domain/use_case/remove_favourite_coffee_use_case.dart'
    as _i608;
import 'package:coffee_app/coffee/infrastructure/repository/coffee_repository.dart'
    as _i920;
import 'package:coffee_app/coffee/infrastructure/use_case/add_favourite_coffee.dart'
    as _i331;
import 'package:coffee_app/coffee/infrastructure/use_case/load_coffee.dart'
    as _i498;
import 'package:coffee_app/coffee/infrastructure/use_case/load_favourite_coffees.dart'
    as _i219;
import 'package:coffee_app/coffee/infrastructure/use_case/remove_favourite_coffee.dart'
    as _i175;
import 'package:coffee_app/injection/modules/http_module_injection.dart'
    as _i33;
import 'package:coffee_app/injection/modules/shared_preferences_injection.dart'
    as _i625;
import 'package:get_it/get_it.dart' as _i174;
import 'package:get_storage/get_storage.dart' as _i792;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final httpModuleInjection = _$HttpModuleInjection();
    final getStorageInjection = _$GetStorageInjection();
    gh.factory<_i519.Client>(() => httpModuleInjection.client);
    gh.lazySingleton<_i792.GetStorage>(() => getStorageInjection.storage);
    gh.lazySingleton<_i920.CoffeeRepository>(
      () => _i920.CoffeeRepository(gh<_i519.Client>(), gh<_i792.GetStorage>()),
    );
    gh.lazySingleton<_i608.RemoveFavouriteCoffeeUseCase>(
      () => _i175.RemoveFavouriteCoffee(gh<_i920.CoffeeRepository>()),
    );
    gh.lazySingleton<_i474.LoadCoffeeUseCase>(
      () => _i498.LoadCoffee(gh<_i920.CoffeeRepository>()),
    );
    gh.lazySingleton<_i521.LoadFavoriteCoffeesUseCase>(
      () => _i219.LoadFavouriteCoffees(gh<_i920.CoffeeRepository>()),
    );
    gh.lazySingleton<_i998.AddFavouriteCoffeeUseCase>(
      () => _i331.AddFavouriteCoffee(gh<_i920.CoffeeRepository>()),
    );
    gh.factory<_i445.CoffeeBloc>(
      () => _i445.CoffeeBloc(
        gh<_i474.LoadCoffeeUseCase>(),
        gh<_i521.LoadFavoriteCoffeesUseCase>(),
      ),
    );
    gh.factory<_i843.FavouriteCoffeeBloc>(
      () => _i843.FavouriteCoffeeBloc(
        gh<_i521.LoadFavoriteCoffeesUseCase>(),
        gh<_i998.AddFavouriteCoffeeUseCase>(),
        gh<_i608.RemoveFavouriteCoffeeUseCase>(),
      ),
    );
    return this;
  }
}

class _$HttpModuleInjection extends _i33.HttpModuleInjection {}

class _$GetStorageInjection extends _i625.GetStorageInjection {}
