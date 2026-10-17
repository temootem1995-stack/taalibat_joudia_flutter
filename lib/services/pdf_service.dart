import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
class PdfService {
 Future<Uint8List> build(OrderModel o) async { final doc=pw.Document(); final f=await PdfGoogleFonts.notoSansArabic(); final bold=await PdfGoogleFonts.notoSansArabicBold(); doc.addPage(pw.MultiPage(pageFormat:PdfPageFormat.a4,theme:pw.ThemeData.withFont(base: f,bold:bold),textDirection:pw.TextDirection.rtl,header:(ctx)=>pw.Column(children:[pw.Text('طلبات مناديب الجوديا',style:pw.TextStyle(font:bold,fontSize:20)),pw.SizedBox(height:6),pw.Divider()]),build:(ctx)=>[pw.Text('تقرير طلب تصنيع',style:pw.TextStyle(font:bold,fontSize:17)),pw.SizedBox(height:8),pw.Row(mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,children:[pw.Text('رقم الطلب: ${o.id}'),pw.Text('التاريخ: ${DateFormat('yyyy/MM/dd HH:mm').format(o.createdAt)}')]),pw.Text('المندوب: ${o.salesRepName}'),pw.Text('العميل/المنطقة: ${o.customer} / ${o.region}'),pw.SizedBox(height:12),pw.Table.fromTextArray(headerStyle:pw.TextStyle(font:bold),headers:['م','الكود','الصنف','الوحدة','الكمية','ملاحظات'],data:[for(int i=0;i<o.lines.length;i++)[(i+1).toString(),o.lines[i].code,o.lines[i].productName,o.lines[i].unit,o.lines[i].quantity.toString(),o.lines[i].note]]),pw.SizedBox(height:12),pw.Text('إجمالي الأصناف: ${o.lines.length} | إجمالي الكميات: ${o.lines.fold<double>(0,(a,b)=>a+b.quantity)}'),pw.SizedBox(height:35),pw.Row(mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,children:[pw.Text('توقيع المندوب: ______________'),pw.Text('توقيع المسؤول: ______________')])]); return doc.save(); }
 Future<void> printOrder(OrderModel o) async { final bytes=await build(o); await Printing.layoutPdf(onLayout:(_)=>bytes); }
}
