
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testproject/widgets/inner_shadow_ui.dart';
import '/data/cart_model.dart';
import '/widgets/text_ui.dart';
import 'button_CR.dart';

class ItemTile extends StatelessWidget {
  ItemTile(
      {super.key,
      required Map<String, dynamic> item,
      required this.overlayController,
      required int index,
      required this.onTapFunction,
      required this.itemInfoTap})
      : _item = item,
        _index = index;

  final Map<String, dynamic> _item;
  final int _index;
  final void Function()? itemInfoTap;
  final void Function()? onTapFunction;
  final OverlayPortalController overlayController;
  final LayerLink link = LayerLink();
  final double _imageWidth = 92;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Stack(
        children: [
          OverlayItemTile(
            item: _item,
            imageWidth: _imageWidth,
            link: link,
            index: _index,
            overlayController: overlayController,
            itemInfoTap: itemInfoTap,
            onOverlayTap: onTapFunction,
          ),
          Center(
            child: CompositedTransformTarget(
              link: link,
              child: Stack(
                  key: ValueKey(_item["key"]),
                  fit: StackFit.loose,
                  children: [
                    Stack(children: [
                      Image(
                        width: _imageWidth,
                        image: AssetImage('assets/cards/${_item["key"]}.png'),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Center(
                          child: TextUI(
                            text: overlayController.isShowing
                                ? ""
                                : _item["name"],
                            fontSize: 10,
                          ),
                        ),
                      )
                    ]),
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
                                child:
                                    TextUI(text: _item["elixir"].toString()))),
                      ]),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class OverlayItemTile extends StatelessWidget {
  const OverlayItemTile(
      {super.key,
      required Map<String, dynamic> item,
      required index,
      required this.overlayController,
      required double imageWidth,
      required this.itemInfoTap,
      required link,
      required this.onOverlayTap})
      : _index = index,
        _link = link,
        _imageWidth = imageWidth,
        _item = item;

  final int _index;
  final void Function()? itemInfoTap;
  final void Function()? onOverlayTap;
  final double _imageWidth;
  final Map<String, dynamic> _item;
  final OverlayPortalController overlayController;
  final LayerLink _link;

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
        controller: overlayController,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            showWhenUnlinked: false,
            targetAnchor: Alignment.topCenter,
            followerAnchor: Alignment.topCenter,
            link: _link,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: onOverlayTap,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 0.7),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: InnerShadow(
                    blur: 5,
                    color: Theme.of(context).colorScheme.background,
                    offset: const Offset(5, 5),
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Stack(children: [
                        SizedBox(
                          height: 210,
                          child: Column(
                            children: [
                              Stack(children: [
                                Image(
                                  width: _imageWidth,
                                  image: AssetImage(
                                      'assets/cards/${_item["key"]}.png'),
                                ),
                                Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: TextUI(
                                        text: _item["name"],
                                        fontSize: 10,
                                      ),
                                    )),
                              ]),
                              ButtonCR(
                                onTapFunction: itemInfoTap,
                                color: Theme.of(context).colorScheme.primary,
                                child: const TextUI(text: "Infos"),
                              ),
                              Consumer<CartModel>(builder:
                                  (BuildContext context, CartModel cart,
                                      Widget? child) {
                                return ButtonCR(
                                  onTapFunction: !cart.isInCart(_index)
                                      ? () {
                                          cart.add(_index);
                                        }
                                      : () {
                                          cart.remove(_index);
                                        },
                                  color: Theme.of(context).colorScheme.surface,
                                  child: TextUI(
                                      text: !cart.isInCart(_index)
                                          ? "Select"
                                          : "Deselect"),
                                );
                                /* MaterialButton(
                                    onPressed: !cart.isInCart(_index)
                                        ? () {
                                            cart.add(_index);
                                          }
                                        : () {
                                            cart.remove(_index);
                                          },
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    shape: const RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color.fromARGB(82, 0, 0, 0),
                                            width: 2),
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(5.5, 5.5))),
                                    child: TextUI(
                                      text: !cart.isInCart(_index)
                                          ? "Select"
                                          : "Deselect",
                                    )); */
                              }),
                            ],
                          ),
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
                                    child: TextUI(
                                        text: _item["elixir"].toString()))),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
