import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MyCategory extends pw.StatelessWidget {
  final String title;
  final pw.Font font;
  MyCategory(this.title, this.font);
  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xffcdf1e7),
        borderRadius: pw.BorderRadius.all(
          pw.Radius.circular(6),
        ),
      ),
      margin: pw.EdgeInsets.only(bottom: 10, top: 20),
      padding: pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
      child:
          pw.Text(title, textScaleFactor: 1.5, style: pw.TextStyle(font: font)),
    );
  }
}
