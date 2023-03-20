import 'package:flutter/material.dart';

import '../models/price_model.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_alt, color: Color.fromARGB(255, 74, 61, 155)),
                SizedBox(width: 10),
                Text(
                  "Price",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            CustomFilterPrice(prices: Price.prices),
            Row(
              children: [
                Icon(Icons.swipe_left, color: Color.fromARGB(255, 74, 61, 155)),
                SizedBox(width: 10),
                Text(
                  "Preferences",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Veg",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'BebasNeue',
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
                Text(
                  "Non-Veg",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    color: Color.fromARGB(255, 18, 17, 18),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    color: Color.fromARGB(255, 74, 61, 155)),
                SizedBox(width: 10),
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Lunch',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Checkbox(value: false, onChanged: (value) {}),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Dinner',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Checkbox(value: false, onChanged: (value) {}),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Snacks',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Checkbox(value: false, onChanged: (value) {}),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Breakfast',
                  //       style: TextStyle(
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.bold,
                  //         fontFamily: 'Roboto',
                  //         color: Color.fromARGB(255, 0, 0, 0),
                  //       ),
                  //     ),
                  //     Checkbox(value: false, onChanged: (value) {}),
                  //   ],
                  // ),
                  SizedBox(height: 10),
                  //Location range enter manually container

                  // Apply Button Container
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 200, 165, 253),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomFilterPrice extends StatelessWidget {
  final List<Price> prices;
  const CustomFilterPrice({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: prices
          .map((price) => InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 200, 165, 253),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    price.price,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
