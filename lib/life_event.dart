import 'package:objectbox/objectbox.dart';

@Entity()
class LifeEvent {
  LifeEvent({
    required this.title,
    required this.count,
  });
// objectboxにおいて id が必ず必要になります。初期値は0とします。
  int id = 0;

  /// イベント名
  String title;

  /// イベントがあった回数
  int count;
}
