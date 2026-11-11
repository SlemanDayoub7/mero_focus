import 'package:flutter/material.dart';

import 'package:mero_focus/features/review/domain/entities/review_entry.dart';

/// Card that shows a single entry inside the daily review list.
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.entry});

  final ReviewEntry entry;

  @override
  Widget build(BuildContext context) {
    // TODO: render the entry and the review actions.
    throw UnimplementedError();
  }
}
