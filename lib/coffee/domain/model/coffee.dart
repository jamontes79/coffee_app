import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee.g.dart';

@JsonSerializable()
class Coffee extends Equatable {
  const Coffee({required this.url});

  factory Coffee.fromJson(Map<String, dynamic> json) => _$CoffeeFromJson(json);
  factory Coffee.empty() => const Coffee(url: '');

  final String url;

  Map<String, dynamic> toJson() => _$CoffeeToJson(this);

  @override
  List<Object?> get props => [url];
}
