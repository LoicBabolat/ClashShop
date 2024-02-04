import 'package:flutter/material.dart';
import 'package:testproject/widgets/inner_shadow_ui.dart';

class ButtonCR extends StatelessWidget {
  const ButtonCR({
    super.key,
    required this.onTapFunction,
    required this.child,
    required this.color,
    this.width = 87,
    this.height = 37,
    this.marginTop = 4.4,
    this.marginBottom = 4.4,
    this.marginRight = 0,
    this.marginLeft = 0,
    this.paddingTop = 0,
    this.paddingBottom = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
  });

  final void Function()? onTapFunction;
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final double marginTop;
  final double marginBottom;
  final double marginRight;
  final double marginLeft;
  final double paddingTop;
  final double paddingBottom;
  final double paddingRight;
  final double paddingLeft;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        margin: EdgeInsets.fromLTRB(
            marginLeft, marginTop, marginRight, marginBottom),
        height: height,
        width: width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(5.5, 5.5)),
            color: Color.fromARGB(126, 49, 49, 49),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 1.5),
                  blurRadius: 0,
                  spreadRadius: 0,
                  color: Color.fromARGB(255, 0, 0, 0))
            ]),
        child: Stack(
          children: [
            InnerShadow(
              blur: 1,
              color: const Color.fromARGB(50, 0, 0, 0),
              offset: const Offset(3, 3),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Colors.black, width: 0.7),
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(5.5, 5.5)),
                ),
                child: Column(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Flexible(
                        flex: 3,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.elliptical(4, 4),
                                bottomRight: Radius.elliptical(4, 4)),
                            color: Color.fromARGB(15, 0, 0, 0),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Positioned.fill(child: Center(child: child)),
            if (onTapFunction == null) ...[
              Positioned.fill(
                  child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(5.5, 5.5)),
                  color: Color.fromARGB(110, 0, 0, 0),
                ),
              ))
            ]
          ],
        ),
      ),
    );
  }
}
