import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class TodoCard extends StatefulWidget {
  final Map<String, dynamic> todoItem;
  final void Function(BuildContext) action;

  TodoCard({super.key, required this.todoItem, required this.action});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  final todoItemBox = Hive.box("todo_item");


  Future<void> _updateItem(int itemKey, Map<String, dynamic> value) async{
    await todoItemBox.put(itemKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 134, 139, 139)),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0,0,0,0),
        child: Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.3,
            motion: BehindMotion(),
            children: [
              SlidableAction(
                onPressed: widget.action,
                backgroundColor: Color(0xff5038BC),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                 borderRadius: BorderRadius.circular(10)
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.todoItem["title"]),
                Checkbox(
                  value: widget.todoItem["is_done"],
                  onChanged: (bool? value) {
                    setState(() {
                      widget.todoItem["is_done"] = value!;
                      _updateItem(widget.todoItem["key"], widget.todoItem);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}