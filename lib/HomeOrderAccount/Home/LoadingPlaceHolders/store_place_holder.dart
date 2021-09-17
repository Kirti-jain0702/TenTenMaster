import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StorePlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 20),
        itemCount: 10,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(left: 20.0, top: 20, right: 20.0),
          child: Row(
            children: [
              Container(
                height: 92,
                width: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Theme.of(context).cardColor,
                ),
              ),
              SizedBox(width: 13.3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 150,
                    color: Theme.of(context).cardColor,
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 40,
                    color: Theme.of(context).cardColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
