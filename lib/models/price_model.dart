import 'dart:ui';

import 'package:equatable/equatable.dart';

Color diselectedPriceColor = Color.fromARGB(255, 200, 165, 253);
Color selectedPriceColor = Color.fromARGB(255, 250, 125, 253);

class Price extends Equatable {
  final int id;
  final String price;
  Color boxColor;

  Price({
    required this.id,
    required this.price,
    required this.boxColor
  });

  @override
  List<Object?> get props => [id, price, boxColor];

  static List<Price> prices = [
    Price(id: 1, price: '\0',boxColor: diselectedPriceColor),
    Price(id: 2, price: '<200',boxColor: diselectedPriceColor),
    Price(id: 3, price: '>200',boxColor: diselectedPriceColor),
  ];
}
