
import 'package:flutter/material.dart';

import 'button_CR.dart';
import 'text_ui.dart';

class RowInfos extends StatelessWidget {
  const RowInfos(
      {super.key,
      required this.itemData,
      required this.iconColor,
      required this.iconData,
      required this.onTapIcon,
      this.iconColor2,
      this.iconData2,
      this.onTapIcon2});

  final Map<String, dynamic> itemData;
  final Color iconColor;
  final IconData iconData;
  final void Function()? onTapIcon;
  final Color? iconColor2;
  final IconData? iconData2;
  final void Function()? onTapIcon2;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Stack(fit: StackFit.loose, children: [
              Image(
                width: 92,
                image: AssetImage('assets/cards/${itemData["key"]}.png'),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Stack(children: [
                  const Image(
                    width: 32,
                    image: AssetImage('assets/Icon_CR/elixir.png'),
                  ),
                  Positioned.fill(
                      child: Center(
                          child: TextUI(text: itemData["elixir"].toString()))),
                ]),
              ),
            ]),
          ),
        ),
        Flexible(
          flex: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextUI(
                  text: itemData["name"] ?? "",
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(110, 0, 0, 0),
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(12),
                        child: TextUI(
                            fontSize: 11, text: itemData["rarity"] ?? "")),
                    Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(110, 0, 0, 0),
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(12),
                        child:
                            TextUI(fontSize: 11, text: itemData["type"] ?? ""))
                  ],
                ),
              )
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ButtonCR(
                    onTapFunction: onTapIcon,
                    color: iconColor,
                    width: 30,
                    height: 30,
                    child: Icon(
                      iconData,
                      size: 24,
                      shadows: const [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-0.8, -0.8),
                            color: Colors.black),
                        Shadow(
                            // bottomRight
                            offset: Offset(0.8, -0.8),
                            color: Colors.black),
                        Shadow(
                            // topRight
                            offset: Offset(0.8, 2.0),
                            color: Colors.black),
                        Shadow(
                            // topLeft
                            offset: Offset(-0.8, 2.0),
                            color: Colors.black),
                      ],
                      color: const Color.fromARGB(255, 255, 255, 255),
                    )),
              ),
              if (iconColor2 != null) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: ButtonCR(
                      onTapFunction: onTapIcon2,
                      color: iconColor2!,
                      width: 30,
                      height: 30,
                      child: Icon(
                        iconData2!,
                        size: 24,
                        shadows: const [
                          Shadow(
                              // bottomLeft
                              offset: Offset(-0.8, -0.8),
                              color: Colors.black),
                          Shadow(
                              // bottomRight
                              offset: Offset(0.8, -0.8),
                              color: Colors.black),
                          Shadow(
                              // topRight
                              offset: Offset(0.8, 2.0),
                              color: Colors.black),
                          Shadow(
                              // topLeft
                              offset: Offset(-0.8, 2.0),
                              color: Colors.black),
                        ],
                        color: const Color.fromARGB(255, 255, 255, 255),
                      )),
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}
