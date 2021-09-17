import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(20.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
        ),
        itemCount: 6,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) =>
            Container(color: Theme.of(context).cardColor),
      ),
    );
  }
}
