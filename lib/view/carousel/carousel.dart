import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  // TODO Add an index so the user can se how much elements are in the carousel
  final double? width;
  final double? height;
  final int visible;
  final List<Map> children;
  final void Function(int)? childClick;
  final double trailingChildWidth;
  final double borderRadius;
  final double spacing;
  final bool autoSlide;
  final int autoPlayDelay;
  final int slideAnimationDuration;
  final int titleFadeAnimationDuration;
  final double titleTextSize;

  const Carousel({
    super.key,
    this.width,
    this.height,
    this.visible = 2,
    required this.children,
    this.borderRadius = 10,
    this.childClick,
    this.trailingChildWidth = 50,
    this.spacing = 10.0,
    this.autoSlide = false,
    this.autoPlayDelay = 5000,
    this.slideAnimationDuration = 800,
    this.titleFadeAnimationDuration = 500,
    this.titleTextSize = 16,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late double useWidth;
  late double useHeight;
  List<Map> builtChildren = [];
  int activeIndex = 0;
  Timer? runner;
  bool isDragging = false;

  void updateSlabs(bool isInit, int direction) {
    // [0 = subtract, 1 = add]
    if (builtChildren.length == 1) {
      setState(() {
        builtChildren[0]['width'] = useWidth;
      });
      return;
    }
    if (builtChildren.length == widget.visible) {
      for (int a = 0; a < builtChildren.length; a++) {
        double cal1 = useWidth -
            (widget.trailingChildWidth +
                (widget.spacing * (builtChildren.length - 1)));
        builtChildren[a]['width'] = a == (builtChildren.length - 1)
            ? widget.trailingChildWidth
            : cal1 / (builtChildren.length - 1);
        builtChildren[a]['marginRight'] =
            a == (builtChildren.length - 1) ? 0 : widget.spacing;
        builtChildren[a]['opacity'] =
            a == (builtChildren.length - 1) ? 0.0 : 1.0;
      }
      return setState(() {});
    }
    for (int a = 0; a < builtChildren.length; a++) {
      builtChildren[a]['width'] = 0.0;
      builtChildren[a]['marginRight'] = 0.0;
      builtChildren[a]['opacity'] = 0.0;
    }
    if (activeIndex == ((builtChildren.length) - widget.visible)) {
      for (int a = 0; a < widget.visible; a++) {
        double cal1 = useWidth -
            (widget.trailingChildWidth +
                (widget.spacing * (widget.visible - 1)));
        builtChildren[activeIndex + a]['width'] =
            a == 0 ? widget.trailingChildWidth : cal1 / (widget.visible - 1);
        builtChildren[activeIndex + a]['marginRight'] =
            a == (widget.visible - 1) ? 0 : widget.spacing;
        builtChildren[activeIndex + a]['opacity'] = a == 0 ? 0.0 : 1.0;
        builtChildren[activeIndex + a]['direction'] = 0;
      }
    } else {
      for (int a = 0; a < widget.visible; a++) {
        double cal1 = useWidth -
            (widget.trailingChildWidth +
                (widget.spacing * (widget.visible - 1)));
        builtChildren[activeIndex + a]['width'] = a == (widget.visible - 1)
            ? widget.trailingChildWidth
            : cal1 / (widget.visible - 1);
        builtChildren[activeIndex + a]['marginRight'] =
            a == (widget.visible - 1) ? 0 : widget.spacing;
        builtChildren[activeIndex + a]['opacity'] =
            a == (widget.visible - 1) ? 0.0 : 1.0;
        builtChildren[activeIndex + a]['direction'] =
            a == (widget.visible - 1) ? 1 : 0;
      }
    }
    return setState(() {});
  }

  @override
  void initState() {
    super.initState();
    for (int a = 0; a < widget.children.length; a++) {
      builtChildren.add({
        "width": 0.0,
        "marginRight": 0.0,
        "opacity": 0.0,
        "direction": 0,
        "childData": widget.children[a],
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateSlabs(true, 0);
      if (widget.autoSlide) {
        runner = Timer.periodic(
            Duration(
              milliseconds: widget.autoPlayDelay,
            ), (timer) {
          if (isDragging) return;
          if ((builtChildren.length < 2) ||
              (builtChildren.length == widget.visible)) return;
          if ((activeIndex + 1) <= ((builtChildren.length) - widget.visible)) {
            activeIndex++;
            updateSlabs(false, 1);
          } else {
            activeIndex = 0;
            updateSlabs(false, 1);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    if (runner != null) {
      runner?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext ctx, BoxConstraints constraints) {
        useWidth = widget.width == null ? constraints.maxWidth : widget.width!;
        useHeight =
            widget.height == null ? constraints.maxHeight : widget.height!;
        return Column(
          children: [
            GestureDetector(
              onHorizontalDragStart: (details) {
                isDragging = true;
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                isDragging = false;
                if (details.primaryVelocity! > (kIsWeb ? 0 : 300)) {
                  // Swipe left
                  if ((builtChildren.length < 2) ||
                      (builtChildren.length == widget.visible)) return;
                  if ((activeIndex != 0) && ((activeIndex - 1) > -1)) {
                    activeIndex--;
                    updateSlabs(false, 0);
                  }
                } else if (details.primaryVelocity! < -(kIsWeb ? 0 : 300)) {
                  // Swipe right
                  if ((builtChildren.length < 2) ||
                      (builtChildren.length == widget.visible)) return;
                  if ((activeIndex + 1) <=
                      ((builtChildren.length) - widget.visible)) {
                    activeIndex++;
                    updateSlabs(false, 1);
                  }
                }
              },
              child: SizedBox(
                width: useWidth,
                height: useHeight - 28,
                child: Row(
                  children: builtChildren
                      .asMap()
                      .entries
                      .map<Widget>((listItem) => InkWell(
                            onTap: widget.childClick == null
                                ? null
                                : () {
                                    if (listItem.value['width'] ==
                                        widget.trailingChildWidth) {
                                      if (listItem.value['direction'] == 1) {
                                        activeIndex++;
                                        updateSlabs(false, 1);
                                      } else {
                                        activeIndex--;
                                        updateSlabs(false, 0);
                                      }
                                      return;
                                    }
                                    widget.childClick!(listItem.key);
                                  },
                            splashFactory: NoSplash.splashFactory,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: double.parse(
                                    listItem.value['marginRight'].toString()),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(widget.borderRadius)),
                                child: AnimatedContainer(
                                  duration: Duration(
                                    milliseconds: widget.slideAnimationDuration,
                                  ),
                                  width: double.parse(
                                      listItem.value['width'].toString()),
                                  height: useHeight,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: listItem.value['childData']
                                            ['image'],
                                        fit: BoxFit.cover,
                                        width: double.maxFinite,
                                        height: double.maxFinite,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.5)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: AnimatedOpacity(
                                            opacity: double.parse(listItem
                                                .value['opacity']
                                                .toString()),
                                            duration: Duration(
                                              milliseconds: widget
                                                  .titleFadeAnimationDuration,
                                            ),
                                            child: Text(
                                              listItem.value['childData']
                                                  ['title'],
                                              style: TextStyle(
                                                fontSize: widget.titleTextSize,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndex(),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildIndex() {
    List<Widget> indexBullets = List.empty(growable: true);
    for (final (index, _) in builtChildren.indexed) {
      bool isActive = activeIndex != builtChildren.length - widget.visible
          ? (activeIndex == index || activeIndex + 1 == index)
          : (activeIndex + 1 == index || activeIndex + 2 == index);
      double bulletSize = isActive ? 8 : 4;
      indexBullets.add(AnimatedSwitcher(
        duration: const Duration(milliseconds: 135),
        child: Padding(
          key: isActive
              ? const Key("activeBullet")
              : const Key("nonActiveBullet"),
          padding: const EdgeInsets.only(
            left: 4,
            right: 4,
            top: 20,
          ),
          child: Container(
            width: bulletSize,
            height: bulletSize,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ));
    }

    return indexBullets;
  }
}
