import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { admin, salesRep }
enum OrderStatus { draft, submitted, reviewing, approved, manufacturing, ready, delivered, rejected }

String statusLabel(OrderStatus s) => const {
  OrderStatus.draft: 'مسودة', OrderStatus.submitted: 'تم الإرسال', OrderStatus.reviewing: 'قيد المراجعة',
  OrderStatus.approved: 'تمت الموافقة', OrderStatus.manufacturing: 'قيد التصنيع',
  OrderStatus.ready: 'جاهز للتسليم', OrderStatus.delivered: 'تم التسليم', OrderStatus.rejected: 'مرفوض أو ملغى'
}[s]!;

OrderStatus statusFrom(String value) => OrderStatus.values.firstWhere((x) => x.name == value, orElse: () => OrderStatus.draft);

class AppUser {
  final String id, username, name; final UserRole role; final bool active;
  AppUser({required this.id, required this.username, required this.name, required this.role, this.active = true});
  factory AppUser.fromMap(String id, Map<String,dynamic> m) => AppUser(id:id, username:m['username']??'', name:m['name']??m['username']??'', role:m['role']=='admin'?UserRole.admin:UserRole.salesRep, active:m['active']??true);
  Map<String,dynamic> toMap()=>{'username':username,'name':name,'role':role.name,'active':active};
}

class UnitOption { final String name; final double factor; UnitOption(this.name,this.factor); Map<String,dynamic> toMap()=>{'name':name,'factor':factor}; factory UnitOption.fromMap(Map<String,dynamic> m)=>UnitOption(m['name']??'وحدة', (m['factor']??1).toDouble()); }
class Product {
  final String id, name, code, category; final List<UnitOption> units; final bool active;
  Product({required this.id,required this.name,required this.code,this.category='',this.units=const [],this.active=true});
  factory Product.fromMap(String id,Map<String,dynamic> m)=>Product(id:id,name:m['name']??'',code:m['code']??'',category:m['category']??'',units:(m['units'] as List? ?? []).map((x)=>UnitOption.fromMap(Map<String,dynamic>.from(x))).toList(),active:m['active']??true);
  Map<String,dynamic> toMap()=>{'name':name,'code':code,'category':category,'units':units.map((x)=>x.toMap()).toList(),'active':active};
}
class OrderLine { final String productId, productName, code, unit, note; final double quantity; OrderLine({required this.productId,required this.productName,required this.code,required this.unit,required this.quantity,this.note=''}); Map<String,dynamic> toMap()=>{'productId':productId,'productName':productName,'code':code,'unit':unit,'quantity':quantity,'note':note}; factory OrderLine.fromMap(Map<String,dynamic> m)=>OrderLine(productId:m['productId']??'',productName:m['productName']??'',code:m['code']??'',unit:m['unit']??'',quantity:(m['quantity']??0).toDouble(),note:m['note']??''); }
class OrderModel { final String id,salesRepId,salesRepName,customer,region; final OrderStatus status; final List<OrderLine> lines; final DateTime createdAt,updatedAt; final String note;
 OrderModel({required this.id,required this.salesRepId,required this.salesRepName,required this.status,required this.lines,required this.createdAt,required this.updatedAt,this.customer='',this.region='',this.note=''});
 factory OrderModel.fromMap(String id,Map<String,dynamic> m)=>OrderModel(id:id,salesRepId:m['salesRepId']??'',salesRepName:m['salesRepName']??'',status:statusFrom(m['status']??'draft'),lines:(m['lines'] as List? ?? []).map((x)=>OrderLine.fromMap(Map<String,dynamic>.from(x))).toList(),createdAt:(m['createdAt'] as Timestamp?)?.toDate()??DateTime.now(),updatedAt:(m['updatedAt'] as Timestamp?)?.toDate()??DateTime.now(),customer:m['customer']??'',region:m['region']??'',note:m['note']??'');
 Map<String,dynamic> toMap()=>{'salesRepId':salesRepId,'salesRepName':salesRepName,'status':status.name,'lines':lines.map((x)=>x.toMap()).toList(),'createdAt':Timestamp.fromDate(createdAt),'updatedAt':Timestamp.fromDate(updatedAt),'customer':customer,'region':region,'note':note}; }
