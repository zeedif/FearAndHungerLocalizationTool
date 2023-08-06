import 'dart:math';
import 'package:fear_and_hunger_localization_tool/presentation/widgets/resize_widgets/priority_size.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResizableHorizontalWidget extends StatefulWidget {
  final Widget child;
  final List<Widget> nextElements;
  final double width;
  final double minSize;
  final double maxSize;
  final String? widthKey;
  final double minSizeInPercentage;
  final double maxSizeInPercentage;
  final Priority priorityInMinSize;
  final Priority priorityInMaxSize;

  const ResizableHorizontalWidget({
    super.key,
    required this.child,
    this.width = 100,
    this.minSize = 50,
    this.maxSize = 100,
    this.minSizeInPercentage = 0,
    this.maxSizeInPercentage = 100,
    this.priorityInMinSize = Priority.pixel,
    this.priorityInMaxSize = Priority.pixel,
    required this.nextElements,
    this.widthKey,
  });

  @override
  State<ResizableHorizontalWidget> createState() => _ResizableHorizontalWidgetState();
}

class _ResizableHorizontalWidgetState extends State<ResizableHorizontalWidget> {
  double widthContainer = 0;
  late double minSize;
  late double maxSize;
  late double parentWidth;
  late SharedPreferences prefs;
  bool isResizing = false;

  @override
  void initState() {
    super.initState();
    loadSharedPreferencesAndWidth();
  }

  void loadSharedPreferencesAndWidth() async {
    if (widget.widthKey != null) {
      prefs = await SharedPreferences.getInstance();
      widthContainer = prefs.getDouble(widget.widthKey!) ?? widget.width;
      setState(() {});
    } else {
      widthContainer = widget.width;
    }
  }

  @override
  void didUpdateWidget(covariant ResizableHorizontalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isResizing ||
        oldWidget.minSize != widget.minSize ||
        oldWidget.maxSize != widget.maxSize ||
        oldWidget.minSizeInPercentage != widget.minSizeInPercentage ||
        oldWidget.maxSizeInPercentage != widget.maxSizeInPercentage ||
        oldWidget.priorityInMaxSize != widget.priorityInMaxSize ||
        oldWidget.priorityInMinSize != widget.priorityInMinSize) {
      calculateSizes();
    }
  }

  void calculateSizes() {
    final minSizeInPixels = widget.minSizeInPercentage * parentWidth / 100;
    final maxSizeInPixels = widget.maxSizeInPercentage * parentWidth / 100;

    switch (widget.priorityInMinSize) {
      case Priority.percentage:
        minSize = minSizeInPixels;
        break;
      case Priority.pixel:
        minSize = widget.minSize;
        break;
      case Priority.larger:
        minSize = max(widget.minSize, minSizeInPixels);
        break;
      case Priority.smaller:
        minSize = min(widget.minSize, minSizeInPixels);
        break;
    }
    switch (widget.priorityInMaxSize) {
      case Priority.percentage:
        maxSize = maxSizeInPixels;
        break;
      case Priority.pixel:
        maxSize = widget.maxSize;
        break;
      case Priority.larger:
        maxSize = max(widget.maxSize, maxSizeInPixels);
        break;
      case Priority.smaller:
        maxSize = min(widget.maxSize, maxSizeInPixels);
        break;
    }

    minSize = minSize.clamp(0, parentWidth);
    maxSize = maxSize.clamp(minSize, parentWidth);

    if (widthContainer > maxSize) {
      widthContainer = maxSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        parentWidth = constraints.maxWidth;
        if (parentWidth == double.infinity) {
          parentWidth = MediaQuery.of(context).size.width;
        }
        if (!isResizing) {
          calculateSizes();
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: widthContainer,
              child: widget.child,
            ),
            GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  isResizing = true;
                  widthContainer += details.delta.dx;
                  widthContainer = widthContainer.clamp(minSize, maxSize);
                });
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                isResizing = false;
                if (widget.widthKey != null) {
                  prefs.setDouble(widget.widthKey!, widthContainer);
                }
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.resizeRight,
                child: VerticalDivider(
                  width: 4,
                  thickness: 1.5,
                ),
              ),
            ),
            ...widget.nextElements,
          ],
        );
      },
    );
  }
}
