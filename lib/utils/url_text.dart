import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class UrlText extends pw.StatelessWidget {
  final String text;
  final String url;
  UrlText(this.text, this.url);
  @override
  pw.Widget build(pw.Context context) {
    // TODO: implement build
    return pw.UrlLink(
        destination: url,
        child: pw.Text(text,
            style: pw.TextStyle(
                decoration: pw.TextDecoration.underline,
                color: PdfColors.blue)));
  }
}
