import 'package:delivoo/Components/cached_image.dart';
import 'package:delivoo/JsonFiles/Categories/category_data.dart';
import 'package:flutter/material.dart';

class CategoryGridItem extends StatelessWidget {
  final CategoryData category;
  final Function onCategoryClick;

  CategoryGridItem(this.category, this.onCategoryClick);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCategoryClick,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: CachedImage(
                category?.mediaUrls?.images?.first?.defaultImage,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 6),
            Text(
              category.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
