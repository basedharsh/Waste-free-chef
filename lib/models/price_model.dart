import 'package:equatable/equatable.dart';

class Price extends Equatable {
  final int id;
  final String price;

  Price({
    required this.id,
    required this.price,
  });

  @override
  List<Object?> get props => [id, price];

  static List<Price> prices = [
    Price(id: 1, price: '\0'),
    Price(id: 2, price: 'rs-rs'),
    Price(id: 3, price: 'rs-rs'),
  ];
}
