library sym_desktop_nav;

import 'package:flutter/material.dart';
import 'package:sym_desktop_nav/sym_desktop_nav/sym_desktop_nav_item.dart';
import 'package:sym_desktop_nav/sym_desktop_nav/sym_desktop_nav_selection.dart';

class SymDesktopNav extends StatefulWidget {
  final List<SymDesktopNavItem> items;
  final int initialIndex;
  final ValueChanged<int> onItemSelected;
  final Color? backgroundColor;
  final Color? itemBackgroundColor;
  final Color? lineColor;
  final TextStyle? textStyle;
  final Curve curve;
  final Duration duration;

  const SymDesktopNav(
      {Key? key,
      required this.items,
      required this.initialIndex,
      required this.onItemSelected,
      this.backgroundColor,
      this.textStyle,
      this.itemBackgroundColor,
      this.lineColor,
      this.curve = Curves.fastLinearToSlowEaseIn,
      this.duration = const Duration(milliseconds: 500)})
      : super(key: key);

  @override
  _SymDesktopNavState createState() => _SymDesktopNavState();
}

class _SymDesktopNavState extends State<SymDesktopNav> {
  @override
  Widget build(BuildContext context) {
    List<List<SymDesktopNavItem>> categorizedItems = [];
    categorizedItems.add(List.of(
        widget.items.where((element) => element.classify == Classify.top)));
    categorizedItems.add(List.of(
        widget.items.where((element) => element.classify == Classify.bottom)));

    return Material(
      color: widget.backgroundColor ?? const Color(0xFFF5F5F5),
      textStyle: widget.textStyle,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: widget.lineColor ?? const Color(0xFFE0E0E0),
              style: BorderStyle.solid,
              width: 0.5,
            ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: SymDesktopNavSelection(
                height: 44,
                width: 44,
                offsetY: _getYOffset(),
                color: const Color(0xFF212121),
                duration: widget.duration,
                curve: widget.curve,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categorizedItems
                  .asMap()
                  .map(
                    (groupIndex, groupValue) => MapEntry(
                      groupIndex,
                      Column(
                        children: groupValue
                            .asMap()
                            .map(
                              (itemIndex, itemValue) => MapEntry(
                                itemIndex,
                                _item(
                                  groupIndex,
                                  itemIndex,
                                  groupValue.length,
                                  itemValue,
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(int groupIndex, int valueIndex, int groupValuesLength,
      SymDesktopNavItem value) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: (value.classify == Classify.top && valueIndex == 0) ? 16 : 8,
            bottom: (value.classify == Classify.bottom &&
                    valueIndex == groupValuesLength - 1)
                ? 16
                : 8,
            left: 8,
            right: 8,
          ),
          child: InkWell(
            onTap: () {
              widget.onItemSelected.call(widget.items.indexOf(value));
            },
            borderRadius: BorderRadius.circular(8),
            hoverColor: widget.itemBackgroundColor?.withOpacity(0.5) ??
                const Color(0xFF000000).withOpacity(0.1),
            child: Ink(
              padding: const EdgeInsets.all(6),
              child: value,
            ),
          ),
        ),
        value.withSeparator
            ? Ink(
                width: 25,
                color: widget.lineColor ?? const Color(0xFFE0E0E0),
                height: 1.5,
              )
            : Ink()
      ],
    );
  }

  double _getYOffset() {
    double offsetY = (16.0 + 44.0) * widget.initialIndex;
    if (widget.items[widget.initialIndex].classify == Classify.bottom) {
      offsetY = ((MediaQuery.of(context).size.height - 16.0) -
          (44.0 + 16.0) * (widget.items.length - widget.initialIndex));
    }
    return offsetY;
  }
}
