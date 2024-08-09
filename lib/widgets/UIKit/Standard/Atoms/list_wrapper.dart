import 'package:flutter/widgets.dart';

class ListWrapper extends StatelessWidget {
  const ListWrapper({
    super.key,
    required this.child,
    required this.emptyWidget,
    required this.count,
  });

  final Widget child;
  final Widget emptyWidget;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return emptyWidget;
    }
    
    return child;
  }
}
