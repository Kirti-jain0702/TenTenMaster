import 'package:delivoo/Themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EntryField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String image;
  final String initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final int maxLength;
  final int maxLines;
  final String hint;
  final bool onlyNumber ;

  final InputBorder border;
  final Widget suffixIcon;
  final Function onTap;
  final TextCapitalization textCapitalization;
  final Color imageColor;
  final bool isDense;
  Function onChanged;

  EntryField(
      {this.controller,
      this.label,
        this.onChanged,
      this.image,
      this.initialValue,
      this.readOnly,
      this.keyboardType,
      this.maxLength,
      this.hint,
      this.border,
        this.onlyNumber= false,

        this.maxLines,
      this.suffixIcon,
      this.onTap,
      this.textCapitalization,
      this.imageColor,
      this.isDense = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: TextFormField(
        onChanged:onChanged ,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        cursorColor: kMainColor,
        onTap: onTap,
        autofocus: false,
        inputFormatters:onlyNumber? <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[+()0-9]+')),
        ]:null,
        controller: controller,
        initialValue: initialValue,
        style: theme.textTheme.subtitle2
            .copyWith(color: theme.secondaryHeaderColor),
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        minLines: 1,
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          isDense: isDense,
          suffixIcon: suffixIcon,
          labelText: label,
          hintText: hint,
          hintStyle: theme.textTheme.caption.copyWith(color: theme.hintColor),
          border: border,
          counter: Offstage(),
          icon: (image != null)
              ? ImageIcon(
                  AssetImage(image),
                  color: imageColor ?? theme.primaryColor,
                  size: 20.0,
                )
              : null,
        ),
      ),
    );
  }
}
