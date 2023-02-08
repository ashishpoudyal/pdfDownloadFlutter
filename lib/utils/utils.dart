import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdf_app/utils/Mymcategory.dart';
import 'package:flutter_pdf_app/utils/url_text.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:permission_handler/permission_handler.dart';

Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document(title: "Flutter Pdf PRevi");
  final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/flutter_school.png'))
          .buffer
          .asUint8List());
  final footerImage = pw.MemoryImage(
      (await rootBundle.load('assets/footer.png')).buffer.asUint8List());
  final font = await rootBundle.load('assets/open-sans.ttf');
  final ttf = pw.Font.ttf(font);
  final pageTheme = await _myPageTheme(format);
  doc.addPage(pw.MultiPage(
    build: (context) => [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('Phone :'),
          pw.Text('Email:'),
          pw.Text('Instagram'),
          pw.Text('Telegram')
        ],
      ),
    ],
  )
      // pw.Page(
      //   pageTheme: pageTheme,
      //   build: (pw.Context context) => pw.Center(
      //     child: pw.Text('Hello World!'),
      //   ),
      // ),

      // pw.MultiPage(
      //   pageTheme: pageTheme,
      //   header: (final context) => pw.Image(
      //     alignment: pw.Alignment.topLeft,
      //     logoImage,
      //     fit: pw.BoxFit.contain,
      //   ),
      //   footer: (final context) => pw.Image(
      //     footerImage,
      //     fit: pw.BoxFit.scaleDown,
      //   ),
      //   build: (final context) => [
      //     pw.Container(
      //       padding: pw.EdgeInsets.only(left: 30, bottom: 30),
      //       child: pw.Column(
      //         crossAxisAlignment: pw.CrossAxisAlignment.center,
      //         mainAxisAlignment: pw.MainAxisAlignment.start,
      //         children: [
      //           pw.Padding(padding: pw.EdgeInsets.only(top: 20)),
      //           pw.Row(
      //             crossAxisAlignment: pw.CrossAxisAlignment.start,
      //             mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      //             children: [
      //               pw.Column(
      //                 crossAxisAlignment: pw.CrossAxisAlignment.end,
      //                 children: [
      //                   pw.Text('Phone :'),
      //                   pw.Text('Email:'),
      //                   pw.Text('Instagram')
      //                 ],
      //               ),
      //               pw.SizedBox(width: 70),
      //               pw.Column(
      //                 children: [
      //                   pw.Text("000120 345 666"),
      //                   // UrlText("my flutte school", "http://www.youtube.com"),
      //                   // UrlText("my flutte school", "http://www.youtube.com"),
      //                   // UrlText("my flutte school", "http://www.youtube.com"),
      //                 ],
      //               ),
      //               pw.SizedBox(width: 70),
      //               pw.BarcodeWidget(
      //                 data: 'Flutter school',
      //                 width: 40,
      //                 height: 40,
      //                 barcode: pw.Barcode.qrCode(),
      //                 drawText: false,
      //               ),
      //               pw.Padding(padding: pw.EdgeInsets.zero)
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //     // pw.Align(alignment: pw.Alignment.center, child: MyCategory("dfdf", ttf),
      //     // )
      //   ],
      // ),
      );
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);

      var file = File('${dir.path}/documentings.pdf');
      for (int num = 0; await file.exists(); num++) {
        file = new File('${dir.path}/documentings$num.pdf');
        print(file.path);
      }

      try {
        await file.writeAsBytes(await doc.save());
        showSharedToast;
      } on FileSystemException catch (err) {}
    }
  }
  final output = await getTemporaryDirectory();
  final file = File("${output.path}/example.pdf");

  await file.writeAsBytes(await doc.save());

  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/flutter_school.png'))
          .buffer
          .asUint8List());
  return pw.PageTheme(
    margin: pw.EdgeInsets.symmetric(
      horizontal: 1 * PdfPageFormat.cm,
      vertical: 0.5 * PdfPageFormat.cm,
    ),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
    buildBackground: (final context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Watermark(
          angle: 20,
          child: pw.Opacity(
            opacity: 0.5,
            child: pw.Image(
                alignment: pw.Alignment.center,
                logoImage,
                fit: pw.BoxFit.cover),
          ),
        )),
  );
}

Future<void> saveAsFile(final BuildContext context, LayoutCallback build,
    final PdfPageFormat pageFormat) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

Future<void> downloadAsFile(final BuildContext context, LayoutCallback build,
    final PdfPageFormat pageFormat) async {
  final bytes = await build(pageFormat);
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      final file = File('${dir.path}/documentings.pdf');

      try {
        await file.writeAsBytes(bytes);
        // await OpenFile.open(file.path);
        // await file.writeAsBytes(byteData.buffer
        //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        // await file.writeAsBytes(bytes);
        // await OpenFile.open(file.path);
      } on FileSystemException catch (err) {
        // handle error
      }
    }
  }
}

Future<void> downloadFile(final BuildContext context, LayoutCallback build,
    final PdfPageFormat pageFormat) async {
  final bytes = await build(pageFormat);
  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      final file = File('${dir.path}/documenting.pdf');

      try {
        await file.writeAsBytes(bytes);
        // await OpenFile.open(file.path);
        // await file.writeAsBytes(byteData.buffer
        //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        // await file.writeAsBytes(bytes);
        // await OpenFile.open(file.path);
      } on FileSystemException catch (err) {
        // handle error
      }
    }
  }
}

void showPrintToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("DOcument Printed sucessfully")));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("DOcument shared sucessfully")));
}
