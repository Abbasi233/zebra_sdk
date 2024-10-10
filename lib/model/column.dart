class ZFlex {
  int flex;
  String title;
  ZAlign align;

  ZFlex({
    required this.title,
    this.flex = 1,
    this.align = ZAlign.L,
  });
}

enum ZAlign {
  L('L'), // Left
  R('R'), // Right
  C('C'), // Center
  J('J'); // Justified

  const ZAlign(this.val);
  final String val;
}
