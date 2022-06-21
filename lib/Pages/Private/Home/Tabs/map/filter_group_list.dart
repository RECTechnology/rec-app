import 'package:flutter/material.dart';

class FilterGroupList extends StatelessWidget {
  final Widget title;
  final int itemCount;
  final bool isLoading;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context) loadingBuilder;

  const FilterGroupList({
    Key? key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    required this.loadingBuilder,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: title,
        ),
        if (isLoading) loadingBuilder(context),
        if (!isLoading) _buildFilterWrap(context),
      ],
    );
  }

  Widget _buildFilterWrap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: [
          for (int i = 0; i < itemCount; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: itemBuilder(context, i),
            ),
        ],
      ),
    );
  }
}
