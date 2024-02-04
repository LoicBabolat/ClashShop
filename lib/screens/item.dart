import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:testproject/data/cart_model.dart';
import 'package:testproject/widgets/inner_shadow_ui.dart';
import 'package:testproject/widgets/loading_widget.dart';
import 'package:testproject/widgets/text_ui.dart';

import '../widgets/button_CR.dart';
import '../widgets/row_infos.dart';

class Item extends StatefulWidget {
  const Item({super.key, required this.item});

  final int item;

  @override
  State<Item> createState() => _ItemState();
}

Future<bool> myLoadAsset(String path) async {
  try {
    await rootBundle.load(path);
    return true;
  } catch (_) {
    return false;
  }
}

class _ItemState extends State<Item> {
  Map<String, dynamic> itemData = {};
  bool isLoaded = false;
  bool isFile = false;

  Future<void> loadAsset() async {
    final String jsonString = await rootBundle.loadString('assets/items.json');
    setState(() {
      itemData = jsonDecode(jsonString)[widget.item];
    });
    isFile = await myLoadAsset(
        'assets/chr/${itemData["key"].replaceAll(RegExp(r'-'), '_')}.png');
    setState(() {
      isFile;
    });
    isLoaded = true;
  }

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(156, 0, 0, 0),
        body: LoadingWidget(
          isLoaded: isLoaded,
          child: Center(
            child: Column(
              mainAxisAlignment:
                  isFile ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (isFile) ...[
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        GoRouter.of(context).pop();
                      },
                      child: Stack(children: [
                        Container(
                          color: Colors.transparent,
                          width: double.maxFinite,
                          height: double.maxFinite,
                        ),
                        Positioned(
                          height: 200,
                          bottom: -32,
                          left: 0,
                          right: 0,
                          child: Image(
                            image: AssetImage(
                                'assets/chr/${itemData["key"].replaceAll(RegExp(r'-'), '_')}.png'),
                            fit: BoxFit.contain,
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      const Spacer(flex: 1),
                      Flexible(
                        flex: 15,
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InnerShadow(
                                blur: 4,
                                color: const Color.fromARGB(100, 0, 0, 0),
                                offset: const Offset(5, 5),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Column(
                                    children: [
                                      RowInfos(
                                        itemData: itemData,
                                        onTapIcon: () {
                                          GoRouter.of(context).pop();
                                        },
                                        iconColor:
                                            Theme.of(context).colorScheme.error,
                                        iconData: Icons.close,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.fromLTRB(20, 25, 20, 25),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 205, 205, 205),
                                                width: 4)),
                                        child: Center(
                                          child: TextUI(
                                            fontSize: 10,
                                            textColor:
                                                const Color.fromARGB(255, 65, 65, 65),
                                            isShadow: false,
                                            text: itemData["description"] ?? "",
                                          ),
                                        ),
                                      ),
                                      Consumer<CartModel>(builder:
                                          (BuildContext context, CartModel cart,
                                              Widget? child) {
                                        return ButtonCR(
                                          onTapFunction:
                                              !cart.isInCart(widget.item)
                                                  ? () {
                                                      cart.add(widget.item);
                                                    }
                                                  : () {
                                                      cart.remove(widget.item);
                                                    },
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          child: TextUI(
                                              text: !cart.isInCart(widget.item)
                                                  ? "Select"
                                                  : "Deselect"),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
