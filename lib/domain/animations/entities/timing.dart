import 'package:json_annotation/json_annotation.dart';

import '../../common/entities/audio.dart';

part 'timing.g.dart';

@JsonSerializable()
class Timing {
  List<int> flashColor;
  int flashDuration;
  int flashScope;
  int frame;
  Audio? se;

  Timing({
    required this.flashColor,
    required this.flashDuration,
    required this.flashScope,
    required this.frame,
    this.se,
  });

  factory Timing.fromJson(Map<String, dynamic> json) => _$TimingFromJson(json);
  Map<String, dynamic> toJson() => _$TimingToJson(this);
}
