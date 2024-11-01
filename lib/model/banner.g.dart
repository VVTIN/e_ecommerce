// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannerModelAdapter extends TypeAdapter<BannerModel> {
  @override
  final int typeId = 1;

  @override
  BannerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannerModel(
      id: fields[0] as int,
      image: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BannerModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
