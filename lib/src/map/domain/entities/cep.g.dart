// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cep.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CepAdapter extends TypeAdapter<Cep> {
  @override
  final int typeId = 0;

  @override
  Cep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cep(
      cep: fields[0] as String,
      logradouro: fields[1] as String,
      bairro: fields[2] as String,
      localidade: fields[3] as String,
      uf: fields[4] as String,
      estado: fields[5] as String,
      ddd: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cep obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.cep)
      ..writeByte(1)
      ..write(obj.logradouro)
      ..writeByte(2)
      ..write(obj.bairro)
      ..writeByte(3)
      ..write(obj.localidade)
      ..writeByte(4)
      ..write(obj.uf)
      ..writeByte(5)
      ..write(obj.estado)
      ..writeByte(6)
      ..write(obj.ddd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
