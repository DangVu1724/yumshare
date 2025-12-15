// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeFeedHiveAdapter extends TypeAdapter<RecipeFeedHive> {
  @override
  final int typeId = 1;

  @override
  RecipeFeedHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeFeedHive(
      id: fields[0] as String,
      name: fields[1] as String,
      authorId: fields[2] as String,
      imageUrl: fields[3] as String?,
      category: fields[4] as String,
      regions: fields[5] as String,
      isShared: fields[6] as bool,
      likes: fields[7] as int,
      rating: fields[8] as double,
      ratingCount: fields[9] as int,
      createdAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeFeedHive obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.authorId)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.regions)
      ..writeByte(6)
      ..write(obj.isShared)
      ..writeByte(7)
      ..write(obj.likes)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.ratingCount)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeFeedHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
