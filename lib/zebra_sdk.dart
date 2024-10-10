import '/model/column.dart';
import 'zebra_sdk_platform_interface.dart';

class ZebraSdk {
  int labelWidth;
  int labelLength;
  int horizontalPadding;

  ZebraSdk({
    this.labelWidth = 578, // iMZ230 Default Label Width
    this.labelLength = 350,
    this.horizontalPadding = 50,
  });

  /// Default line vertical padding
  void appendHeight({int height = 25}) {
    labelLength += height;
  }

  // FB kodu ile text'in gideceği son sınır belirlenebilir.
  String text(String content, {ZAlign align = ZAlign.L, int fontSize = 23}) {
    int maxLines = 1;
    int textWidth = labelWidth - horizontalPadding * 2;
    double lines = content.length / 40;

    if (lines > 1) maxLines = lines.ceil();

    String returnValue = "^FO$horizontalPadding,$labelLength^FB$textWidth,$maxLines,,${align.val},^A0N,$fontSize^FD$content^FS";

    appendHeight(height: 25 * maxLines);
    return returnValue;
  }

  String textSpan(
    List<ZFlex> spans, {
    int? sectionWidth,
    int? spanXPos,
    int fontSize = 23,
    bool withColon = true,
  }) {
    // String font = "^ANN,$fontSize"; FONTLAR ENUM'A ALINABİLİR. BU DEĞİŞKEN DE FONT SPESİFİK BİR FONT SEÇİLDİYSE VAL'E GEÇİRİLMEYİ SAĞLAYABİLİR.
    String val = "";
    int spanX = spanXPos ?? horizontalPadding;
    int totalWidth = sectionWidth ?? labelWidth - horizontalPadding * 2;
    int totalFlex = spans.fold(0, (sum, span) => span.flex + sum);

    for (int i = 0; i < spans.length; i++) {
      ZFlex span = spans[i];
      int spanWidth = _calcSpan(
        flex: span.flex,
        totalFlex: totalFlex,
        totalWidth: totalWidth,
      );

      int charLength = 10;
      int textLength = spanWidth ~/ charLength;
      String title = span.title.length > textLength ? "${span.title.substring(0, textLength - 3)}..." : span.title;

      val += "^FO$spanX,$labelLength^FB$spanWidth,,,${span.align.val},^A0N,$fontSize^FD$title^FS";
      spanX += spanWidth;

      if (withColon && i != spans.length - 1) {
        val += "^FO$spanX,$labelLength^FB10,,,L,^A0N,$fontSize^FD:^FS";
        spanX += 10;
      }
    }
    appendHeight();
    return val;
  }

  String table({
    required List<ZFlex> columns,
    required List<List<ZFlex>> data,
    int fontSize = 23,
  }) {
    String val = "";
    int totalWidth = labelWidth - horizontalPadding * 2;

    val += textSpan(columns, withColon: false, fontSize: fontSize);
    val += "^FO$horizontalPadding,$labelLength^GB$totalWidth,0,2^FS";
    appendHeight();

    for (var i = 0; i < data.length; i++) {
      List<ZFlex> spans = data[i];
      val += textSpan(spans, withColon: false, fontSize: fontSize);
    }
    return val;
  }

  String resultSection(List<List<ZFlex>> data, {int? sectionWidth, int fontSize = 23}) {
    String val = ""; // "^FW,1"; For right orientation
    int totalWidth = sectionWidth ?? labelWidth ~/ 3;

    for (var i = 0; i < data.length; i++) {
      List<ZFlex> spans = data[i];
      int spanX = labelWidth - horizontalPadding - totalWidth;

      val += textSpan(spans, sectionWidth: totalWidth, spanXPos: spanX, fontSize: fontSize);
      appendHeight();
    }
    // val += "^FW,0";
    return val;
  }

  int _calcSpan({
    required int flex,
    required int totalFlex,
    required int totalWidth,
  }) {
    int widthRate = (totalWidth / totalFlex).round();
    return widthRate * flex;
  }

  Future<Map<String, dynamic>> print({
    required String btAddr,
    required String content,
    required String labelLength,
  }) {
    return ZebraSdkPlatform.instance.print(btAddr, content, labelLength);
  }
}
