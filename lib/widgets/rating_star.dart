import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int initialRating; // Default rating
  final void Function(int) onRatingChanged; // Callback when the rating changes
  final double starSize; // Size of each star
  final Color filledStarColor; // Color of filled stars
  final Color unfilledStarColor; // Color of unfilled stars

  const StarRating({
    super.key,
    this.initialRating = 0,
    required this.onRatingChanged,
    this.starSize = 40.0,
    this.filledStarColor = Colors.amber,
    this.unfilledStarColor = Colors.grey,
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  void _updateRating(int rating) {
    setState(() {
      currentRating = rating;
    });
    widget.onRatingChanged(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => _updateRating(index + 1),
          icon: Icon(
            Icons.star,
            color: index < currentRating
                ? widget.filledStarColor
                : widget.unfilledStarColor,
            size: widget.starSize,
          ),
        );
      }),
    );
  }
}
