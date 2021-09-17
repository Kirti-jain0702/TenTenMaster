import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final Function onTap;
  final Color color;
  final BoxShadow boxShadow;
  final void Function(String) onSubmitted;
  final bool readOnly, autofocus;
  final TextEditingController editingController;

  CustomSearchBar(
      {this.hint,
      this.onTap,
      this.color,
      this.boxShadow,
      this.onSubmitted,
      this.readOnly = false,
      this.autofocus = false,
      this.editingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow ?? BoxShadow(color: Theme.of(context).cardColor),
        ],
        borderRadius: BorderRadius.circular(30.0),
        color: color ?? Theme.of(context).cardColor,
      ),
      child: TextField(
          controller: editingController,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: kMainColor,
          readOnly: readOnly,
          decoration: InputDecoration(
            isDense: true,
            icon: ImageIcon(
              AssetImage('images/icons/ic_search.png'),
              color: Theme.of(context).secondaryHeaderColor,
              size: 16,
            ),
            hintText: hint,
            hintStyle: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: kHintColor),
            border: InputBorder.none,
          ),
          onChanged: onSubmitted,
          onTap: onTap,
          autofocus: autofocus),
    );
  }
}
