import 'package:flutter/material.dart';
import 'package:elliot/tags/colors.dart';
import 'package:flutter/foundation.dart';

class Tag {
  final String title;
  final Color color;

  Tag({@required this.title, @required this.color});

  static final tags = [
    Tag(title: '', color: Colors.transparent),
    Tag(title: 'animation', color: Colours.baraRed),
    Tag(title: 'architecture', color: Colours.pixelatedGrass),
    Tag(title: 'ui', color: Colours.forgottenPurple),
    Tag(title: 'ux', color: Colors.black87),
    Tag(title: 'model', color: Colours.baraRed),
    Tag(title: 'widget', color: Colours.marineBlue),
    Tag(title: 'network', color: Colours.deepLeaguesBlue),
    Tag(title: 'service', color: Colours.lavenderTea),
    Tag(title: 'database', color: Colours.hollyHock),
    Tag(title: 'caching', color: Colours.blueMartina),
    Tag(title: 'refactor', color: Colours.lavenderRose),
    Tag(title: 'bug', color: Colours.turkishAqua),
    Tag(title: 'error', color: Colours.redPigment),
    Tag(title: 'cleanup', color: Colours.mediterraneanSea),
    Tag(title: 'feature', color: Colours.energos),
    Tag(title: 'privacy', color: Colours.circumorbitalRing),
    Tag(title: 'performance', color: Colors.blueGrey),
    Tag(title: 'testing', color: Colours.radiantYellow),
  ];
//  animation,
//  architecture,
//  ui,
//  ux,
//  model,
//  widget,
//  network,
//  service,
//  database,
//  caching,
//  refactor,
//  bug,
//  error,
//  cleanup,
//  feature,
//  privacy,
//  performance,
//  testing,
}
