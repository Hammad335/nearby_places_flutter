import 'package:flutter/material.dart';
import 'package:nearby_places_flutter/core/models/models.dart';
import 'package:nearby_places_flutter/core/widgets/widgets.dart';

class ReviewWidget extends StatelessWidget {
  final Review review;

  const ReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(review.profilePhotoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      review.authorName,
                      style: const TextStyle(
                          fontFamily: 'WorkSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 3),
                  PlaceRatings(rating: review.rating * 1.0),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            review.text,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Divider(color: Colors.grey.shade600, height: 1.0)
      ],
    );
  }
}
