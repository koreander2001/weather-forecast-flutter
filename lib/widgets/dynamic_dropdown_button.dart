import 'package:flutter/material.dart';

class DynamicDropdownButton<T> extends StatelessWidget {
  final Stream<List<T>> getItemsStream;
  final Stream<T> holdingItemStream;
  final String hint;
  final ValueChanged<T> onChanged;
  final Widget widgetsWhenNoData;

  DynamicDropdownButton({
    Key key,
    this.getItemsStream,
    this.holdingItemStream,
    this.hint,
    this.onChanged,
    this.widgetsWhenNoData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: holdingItemStream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        return StreamBuilder(
          stream: getItemsStream,
          builder: (BuildContext context, AsyncSnapshot<List<T>> listSnapshot) {
            if (listSnapshot.hasData) {
              return DropdownButton(
                  value: snapshot.data,
                  hint: Text(hint),
                  isExpanded: true,
                  onChanged: onChanged,
                  items: _getMenuItemList(listSnapshot.data),
              );
            } else {
              return widgetsWhenNoData;
            }
          },
        );
      },
    );
  }

  List<DropdownMenuItem<T>> _getMenuItemList(List<T> items) {
    return items.map((item) {
      return DropdownMenuItem<T>(
        child: Text(item.toString()),
        value: item,
      );
    }).toList();
  }
}
