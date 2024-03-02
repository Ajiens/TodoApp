import 'package:hive/hive.dart';

part 'todo_item.g.dart';

@HiveType(typeId:2, adapterName:'TodoItemAdapter')
class TodoItem {
  @HiveField(1)
  String keyItem;

  @HiveField(2)
  DateTime start;

  @HiveField(3)
  DateTime end;

  @HiveField(4)
  String title;

  @HiveField(5)
  String category;

  @HiveField(6)
  String? description;

  TodoItem({
    required this.keyItem, 
    required this.start, 
    required this.end, 
    required this.title, 
    required this.category, 
  });
}