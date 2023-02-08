import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pdf_app/utils/utils.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPage extends StatefulWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    // final actions = <PdfPreviewAction>[
    //   if (!kIsWeb)
    //     const PdfPreviewAction(
    //         icon: Icon(Icons.save), onPressed: downloadAsFile),
    // ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter PDF"),
      ),
      body: PdfPreview(
          maxPageWidth: 700,
          actions: null,
          onPrinted: showPrintToast,
          onShared: showSharedToast,
          build: generatePdf),
    );
  }
}
