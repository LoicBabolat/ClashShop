import 'package:flutter/material.dart';
import '/data/list_cards_model.dart';
import 'text_ui.dart';

class DropDownFilter extends StatefulWidget {
  const DropDownFilter(
      {super.key,
      required this.dropdownValue,
      required this.callBack,
      required this.filter,
      required this.listModel});

  final String? dropdownValue;
  final void Function(String filter, String value) callBack;
  final String filter;
  final ListCardsModel listModel;

  @override
  State<DropDownFilter> createState() => _DropDownFilterState();
}

class _DropDownFilterState extends State<DropDownFilter> {
  List<dynamic>? list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    list = widget.listModel.filterChoices(widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    {
      return Expanded(
        child: DropdownButtonFormField<String>(
          selectedItemBuilder: (BuildContext context) {
            return list!.map<Widget>((dynamic item) {
              // This is the widget that will be shown when you select an item.
              // Here custom text style, alignment and layout size can be applied
              // to selected item string.
              return Container(
                  constraints: const BoxConstraints(minHeight: 37, maxHeight: 37),
                  alignment: Alignment.centerLeft,
                  child: TextUI(
                    text: item.toString(),
                    fontSize: 10,
                  ));
            }).toList();
          },
          isExpanded: true,
          value: widget.dropdownValue,
          elevation: 20,
          onChanged: (String? value) {
            // This is called when the user selects an item.
            widget.callBack(widget.filter, value!);
          },
          decoration: InputDecoration(
              fillColor: const Color.fromARGB(255, 71, 117, 155),
              filled: true,
              constraints: const BoxConstraints(minHeight: 37, maxHeight: 37),
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              label: Container(
                  child: TextUI(
                text: widget.filter,
                fontSize: 10,
              ))),
          items: list != null
              ? list!.map<DropdownMenuItem<String>>((dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: TextUI(
                      text: value,
                    ),
                  );
                }).toList()
              : [
                  const DropdownMenuItem<String>(
                    value: "",
                    child: TextUI(
                      text: "",
                    ),
                  )
                ],
        ),
      );
    }
  }
}
