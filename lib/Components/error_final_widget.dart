import 'package:flutter/material.dart';

class ErrorFinalWidget {
  static Widget errorWithRetry(BuildContext context, String message,
      [String actionText, Function action]) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              if (actionText != null && action != null)
                FlatButton(
                  child: Text(
                    actionText,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () => action(),
                ),
            ],
          )),
    );
  }
}
