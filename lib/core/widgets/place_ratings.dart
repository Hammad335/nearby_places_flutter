import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class PlaceRatings extends StatelessWidget {
  const PlaceRatings({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return RatingStars(
      value: rating,
      starCount: 5,
      starSize: 10,
      valueLabelColor: const Color(0xff9b9b9b),
      valueLabelTextStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 12.0,
      ),
      valueLabelRadius: 10,
      maxValue: 5,
      starSpacing: 2,
      maxValueVisibility: false,
      valueLabelVisibility: true,
      animationDuration: const Duration(milliseconds: 1000),
      valueLabelPadding: const EdgeInsets.symmetric(
        vertical: 1,
        horizontal: 8,
      ),
      valueLabelMargin: const EdgeInsets.only(right: 8),
      starOffColor: const Color(0xffe7e8ea),
      starColor: Colors.yellow,
    );
  }
}
