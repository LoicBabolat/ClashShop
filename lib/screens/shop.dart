import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testproject/widgets/button_CR.dart';
import 'package:testproject/widgets/dropdown_filter.dart';
import 'package:testproject/widgets/text_ui.dart';

import '/widgets/item_tile.dart';
import '/widgets/loading_widget.dart';
import '/data/list_cards_model.dart';

class ShopList extends StatefulWidget {
  const ShopList({
    super.key,
  });

  @override
  State<ShopList> createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  List<dynamic> _itemsList = [];
  bool isLoaded = false;
  List<int>? _indexList;
  ListCardsModel listModel = ListCardsModel();
  Map<String, dynamic> filters = {
    "type": [null, "String"],
    "rarity": [null, "String"],
    "arena": [null, "int"]
  };
  Map<String, String?> orderFilters = {
    "By elixir": "elixir",
    "By rarity": "rarity",
    "By arena": "arena",
    "By type": "type"
  };
  bool isActiveFilter = true;
  bool isFilteredList = false;
  int? isOverlayed;
  List<OverlayPortalController> itemOverlaysControllers = [];
  final List<ScrollController> _scrollController = [
    ScrollController(),
    ScrollController()
  ];
  String orderListText = "By elixir";

  Future<void> loadAsset() async {
    await listModel.init();
    setState(() {
      listModel;
      _itemsList = listModel.listCards();
      _itemsList = listModel.orderList("elixir", _itemsList);
      for (int i = 0; i < _itemsList.length; i++) {
        itemOverlaysControllers.add(OverlayPortalController());
      }
      _indexList = listModel.getIndex(_itemsList);
    });
    isLoaded = true;
  }

  @override
  void initState() {
    _scrollController[0].addListener(_onScrollEvent);
    _scrollController[1].addListener(_onScrollEvent);
    loadAsset();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController[0].removeListener(_onScrollEvent);
    _scrollController[1].removeListener(_onScrollEvent);
    super.dispose();
  }

  void _onScrollEvent() {
    if (isOverlayed != null) {
      setState(() {
        itemOverlaysControllers[isOverlayed!].hide();
        isOverlayed = null;
      });
    }
  }

  void changeOrder() {
    if (isLoaded) {
      List<String> keys = orderFilters.keys.toList();
      int indexFilter = keys.indexOf(orderListText) < keys.length - 1
          ? keys.indexOf(orderListText)
          : -1;
      setState(() {
        isLoaded = false;
        if (isOverlayed != null) {
          itemOverlaysControllers[isOverlayed!].hide();
          isOverlayed = null;
        }
        itemOverlaysControllers = [];
        orderListText = keys[indexFilter + 1];
        _itemsList = listModel.orderList(
            orderFilters.values.toList()[indexFilter + 1], _itemsList);
        for (int i = 0; i < _itemsList.length; i++) {
          itemOverlaysControllers.add(OverlayPortalController());
        }
        _indexList = listModel.getIndex(_itemsList);
        isLoaded = true;
      });
    }
  }

  void Function()? filterListShop() {
    if (!isActiveFilter) {
      return () {
        setState(() {
          isLoaded = false;
          _itemsList = listModel.orderList(
              orderFilters[orderListText], listModel.filterList(filters));
          if (isOverlayed != null) {
            itemOverlaysControllers[isOverlayed!].hide();
            isOverlayed = null;
          }
          itemOverlaysControllers = [];
          for (int i = 0; i < _itemsList.length; i++) {
            itemOverlaysControllers.add(OverlayPortalController());
          }
          _indexList = listModel.getIndex(_itemsList);
          isLoaded = true;
          isFilteredList = true;
        });
      };
    } else {
      return null;
    }
  }

  void Function()? clearListSearch() {
    if (isFilteredList) {
      return () {
        setState(() {
          isLoaded = false;
          _itemsList = listModel.orderList(
              orderFilters[orderListText], listModel.listCards());
          if (isOverlayed != null) {
            itemOverlaysControllers[isOverlayed!].hide();
            isOverlayed = null;
          }
          itemOverlaysControllers = [];
          for (int i = 0; i < _itemsList.length; i++) {
            itemOverlaysControllers.add(OverlayPortalController());
          }
          _indexList = listModel.getIndex(_itemsList);
          isLoaded = true;
          isFilteredList = false;
          isActiveFilter = true;
          filters.forEach((key, value) => value[0] = null);
        });
      };
    } else {
      return null;
    }
  }

  void dropdownCallback(filter, value) {
    setState(() {
      filters[filter][0] = value;
      for (var element in filters.values) {
        if (element[0] != null) {
          isActiveFilter = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Shop"),
          actions: [
            ButtonCR(
              onTapFunction: changeOrder,
              color: const Color.fromARGB(255, 71, 117, 155),
              width: 150,
              marginRight: 10,
              child: TextUI(text: orderListText),
            ),
          ],
        ),
        body: LoadingWidget(
          isLoaded: isLoaded,
          child: GestureDetector(
            onTapDown: (details) {
              if (isOverlayed != null) {
                setState(() {
                  itemOverlaysControllers[isOverlayed!].hide();
                });
              }
            },
            child: Column(
              children: [
                FiltersSearch(
                    isFilteredList: isFilteredList,
                    filterKeys: filters.keys.toList(),
                    callBack: dropdownCallback,
                    filterValues: filters.values.toList(),
                    listModel: listModel,
                    filterListShop: filterListShop,
                    clearFilterList: clearListSearch),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    controller: _scrollController[0],
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          controller: _scrollController[1],
                          itemCount: _itemsList.length,
                          semanticChildCount: 12,
                          itemBuilder: (context, index) {
                            return ItemTile(
                              key: ValueKey(_itemsList[index]["key"]),
                              overlayController: itemOverlaysControllers[index],
                              item: _itemsList[index],
                              index: _indexList![index],
                              onTapFunction: () {
                                setState(() {
                                  if (itemOverlaysControllers[index]
                                      .isShowing) {
                                    itemOverlaysControllers[index].hide();
                                    isOverlayed = null;
                                  } else {
                                    if (isOverlayed != null) {
                                      itemOverlaysControllers[isOverlayed!]
                                          .hide();
                                    }
                                    itemOverlaysControllers[index].show();
                                    isOverlayed = index;
                                  }
                                });
                              },
                              itemInfoTap: () {
                                GoRouter.of(context)
                                    .go('/shop/item/${_indexList![index]}');
                              },
                            );
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisExtent: 110,
                                  crossAxisSpacing: 2),
                        ),
                        SizedBox(
                          height: 130,
                          width: double.maxFinite,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Flexible(
                                  flex: 4,
                                  child: Divider(),
                                ),
                                Flexible(
                                    flex: 3,
                                    child: TextUI(
                                      text: const ListEquality()
                                              .equals(_itemsList, [])
                                          ? "No results"
                                          : "End of list",
                                    )),
                                const Flexible(
                                  flex: 4,
                                  child: Divider(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class FiltersSearch extends StatefulWidget {
  const FiltersSearch(
      {super.key,
      required this.filterKeys,
      required this.callBack,
      required this.filterValues,
      required this.listModel,
      required this.filterListShop,
      required this.clearFilterList,
      required this.isFilteredList});

  final List<String> filterKeys;
  final bool isFilteredList;
  final List<dynamic> filterValues;
  final void Function(String filter, String value) callBack;
  final ListCardsModel listModel;
  final Function() filterListShop;
  final Function() clearFilterList;

  @override
  State<FiltersSearch> createState() => _FiltersSearchState();
}

class _FiltersSearchState extends State<FiltersSearch> {
  List<Widget> filtersSearch() {
    List<Widget> filtersSearch = [];

    for (int i = 0; i < widget.filterKeys.length; i++) {
      filtersSearch.add(DropDownFilter(
          dropdownValue: widget.filterValues[i][0],
          callBack: widget.callBack,
          filter: widget.filterKeys[i],
          listModel: widget.listModel));
    }

    filtersSearch.add(ButtonCR(
      onTapFunction: widget.filterListShop(),
      color: const Color.fromARGB(255, 71, 117, 155),
      child: const TextUI(text: "Search"),
    ));
    if (widget.isFilteredList) {
      filtersSearch.add(ButtonCR(
          onTapFunction: widget.clearFilterList(),
          color: const Color.fromARGB(255, 71, 117, 155),
          width: 50,
          child: const Icon(
            Icons.close,
            shadows: [
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
            color: Color.fromARGB(255, 255, 255, 255),
          )));
    }

    return filtersSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: filtersSearch(),
    );
  }
}
