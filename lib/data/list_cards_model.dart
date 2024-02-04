import 'dart:convert';

import 'package:flutter/services.dart';

class ListCardsModel {
  late String jsonString;
  late List<dynamic> jsonList;

  ListCardsModel();

  Future<void> init() async {
    jsonString = await rootBundle.loadString('assets/items.json');
    jsonList = jsonDecode(jsonString);
  }

  List<dynamic> listCards() {
    return jsonList;
  }

  dynamic getCard(int index) {
    return jsonList[index];
  }

  int getTotalExlixir(List<int> indexes) {
    int total = 0;
    for (int index in indexes) {
      total = (total + jsonList[index]["elixir"]).toInt();
    }
    return total;
  }

  List<int> getIndex(List<dynamic> list) {
    List<int> indexList = [];
    for (int i = 0; i < list.length; i++) {
      indexList.add(jsonList.indexOf(list[i]));
    }
    return indexList;
  }

  List<dynamic> filterList(Map<String, dynamic> filters) {
    List<dynamic> filterList = jsonList;
    filters.forEach((key, value) {
      if (value[0] != null && value[1] == "String") {
        filterList = filterList.where((e) => e[key] == value[0]).toList();
      } else if (value[0] != null && value[1] == "int") {
        filterList =
            filterList.where((e) => e[key] == int.parse(value[0])).toList();
      }
    });
    return filterList;
  }

  List<dynamic> filterChoices(String filter) {
    List<dynamic> filterChoices = [jsonList[0][filter]];
    for (int i = 1; i < jsonList.length; i++) {
      if (!filterChoices.contains(jsonList[i][filter])) {
        filterChoices.add(jsonList[i][filter]);
      }
    }
    filterChoices.sort();
    filterChoices = filterChoices.map((e) => e.toString()).toList();
    return filterChoices;
  }

  List<dynamic> orderList(String? orderFilter, List<dynamic> listCardsVar) {
    List<dynamic> listCardsCopy = listCardsVar;
    listCardsVar = [];
    if (orderFilter != null) {
      for (var choice in filterChoices(orderFilter)) {
        for (var item in listCardsCopy) {
          if (item[orderFilter].toString() == choice.toString()) {
            listCardsVar.add(item);
          }
        }
      }
      return listCardsVar;
    } else {
      return listCardsVar;
    }
  }
}
