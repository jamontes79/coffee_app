import 'package:coffee_app/core/failure/failure.dart';

abstract class CoffeeFailure extends Failure {}

class CoffeeNotFoundFailure extends CoffeeFailure {}

class AddFavouriteCoffeeFailure extends CoffeeFailure {}

class LoadFavouritesFailure extends CoffeeFailure {}

class RemoveFavouriteCoffeeFailure extends CoffeeFailure {}
