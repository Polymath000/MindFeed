import 'package:hive/hive.dart';
import 'package:mind_feed/core/articles/domain/entities/downloaded_article_entity.dart';

class DownloadedArticleEntityAdapter extends TypeAdapter<DownloadedArticleEntity> {
  @override
  final int typeId = 2;

  @override
  DownloadedArticleEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedArticleEntity(
      id: fields[0] as String? ?? '',
      title: fields[1] as String? ?? '',
      excerpt: fields[2] as String? ?? '',
      content: fields[3] as String? ?? '',
      authorName: fields[4] as String? ?? '',
      authorRole: fields[5] as String? ?? '',
      authorAvatar: fields[6] as String? ?? '',
      categoryId: fields[7] as String? ?? '',
      categorySlug: fields[8] as String? ?? '',
      tags: (fields[9] as List?)?.cast<String>() ?? <String>[],
      publishedAt: fields[10] is DateTime
          ? fields[10] as DateTime
          : (fields[10] is int
              ? DateTime.fromMillisecondsSinceEpoch(fields[10] as int)
              : DateTime.tryParse(fields[10]?.toString() ?? '') ?? DateTime.now()),
      readingTimeMinutes: fields[11] as int? ?? 0,
      downloadedAt: fields[12] is DateTime
          ? fields[12] as DateTime
          : (fields[12] is int
              ? DateTime.fromMillisecondsSinceEpoch(fields[12] as int)
              : DateTime.tryParse(fields[12]?.toString() ?? '') ?? DateTime.now()),
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedArticleEntity obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.excerpt)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.authorName)
      ..writeByte(5)
      ..write(obj.authorRole)
      ..writeByte(6)
      ..write(obj.authorAvatar)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.categorySlug)
      ..writeByte(9)
      ..write(obj.tags)
      ..writeByte(10)
      ..write(obj.publishedAt)
      ..writeByte(11)
      ..write(obj.readingTimeMinutes)
      ..writeByte(12)
      ..write(obj.downloadedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedArticleEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
