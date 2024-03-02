// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoItemAdapter extends TypeAdapter<TodoItem> {
  @override
  final int typeId = 2;

  @override
  TodoItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoItem(
      keyItem: fields[1] as String,
      start: fields[2] as DateTime,
      end: fields[3] as DateTime,
      title: fields[4] as String,
      category: fields[5] as String,
    )..description = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, TodoItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.keyItem)
      ..writeByte(2)
      ..write(obj.start)
      ..writeByte(3)
      ..write(obj.end)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
