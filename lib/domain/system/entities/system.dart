import 'package:json_annotation/json_annotation.dart';

import '../../common/entities/audio.dart';
import 'attack_motions.dart';
import 'terms.dart';
import 'test_battlers.dart';
import 'ship.dart';

part 'system.g.dart';

@JsonSerializable()
class System {
  Ship airship;
  List<String> armorTypes;
  List<AttackMotion?> attackMotions;
  Audio battleBgm;
  String battleback1Name;
  String battleback2Name;
  int battlerHue;
  String battlerName;
  Ship boat;
  String currencyUnit;
  Audio defeatMe;
  int editMapId;
  List<String> elements;
  List<String> equipTypes;
  String gameTitle;
  Audio gameoverMe;
  String locale;
  List<int> magicSkills;
  List<bool> menuCommands;
  bool optDisplayTp;
  bool optDrawTitle;
  bool optExtraExp;
  bool optFloorDeath;
  bool optFollowers;
  bool optSideView;
  bool optSlipDeath;
  bool optTransparent;
  List<int> partyMembers;
  Ship ship;
  List<String> skillTypes;
  List<Audio> sounds;
  int startMapId;
  int startX;
  int startY;
  List<String> switches;
  Terms terms;
  List<TestBattlers> testBattlers;
  int testTroopId;
  String title1Name;
  String title2Name;
  Audio titleBgm;
  List<String> variables;
  int versionId;
  Audio victoryMe;
  List<String> weaponTypes;
  List<int> windowTone;
  bool hasEncryptedImages;
  bool hasEncryptedAudio;
  String encryptionKey;

  System({
    required this.airship,
    required this.armorTypes,
    required this.attackMotions,
    required this.battleBgm,
    required this.battleback1Name,
    required this.battleback2Name,
    required this.battlerHue,
    required this.battlerName,
    required this.boat,
    required this.currencyUnit,
    required this.defeatMe,
    required this.editMapId,
    required this.elements,
    required this.equipTypes,
    required this.gameTitle,
    required this.gameoverMe,
    required this.locale,
    required this.magicSkills,
    required this.menuCommands,
    required this.optDisplayTp,
    required this.optDrawTitle,
    required this.optExtraExp,
    required this.optFloorDeath,
    required this.optFollowers,
    required this.optSideView,
    required this.optSlipDeath,
    required this.optTransparent,
    required this.partyMembers,
    required this.ship,
    required this.skillTypes,
    required this.sounds,
    required this.startMapId,
    required this.startX,
    required this.startY,
    required this.switches,
    required this.terms,
    required this.testBattlers,
    required this.testTroopId,
    required this.title1Name,
    required this.title2Name,
    required this.titleBgm,
    required this.variables,
    required this.versionId,
    required this.victoryMe,
    required this.weaponTypes,
    required this.windowTone,
    required this.hasEncryptedImages,
    required this.hasEncryptedAudio,
    required this.encryptionKey,
  });

  factory System.fromJson(Map<String, dynamic> json) => _$SystemFromJson(json);
  Map<String, dynamic> toJson() => _$SystemToJson(this);
}
