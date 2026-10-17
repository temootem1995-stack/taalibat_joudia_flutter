import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
class DataService { final db=FirebaseFirestore.instance; final uid=const Uuid();
 Stream<List<Product>> products()=>db.collection('products').orderBy('name').snapshots().map((s)=>s.docs.map((d)=>Product.fromMap(d.id,d.data())).toList());
 Future<void> saveProduct(Product p) async { final ref=p.id.isEmpty?db.collection('products').doc():db.collection('products').doc(p.id); await ref.set(p.toMap()); }
 Future<void> deleteProduct(String id)=>db.collection('products').doc(id).delete();
 Future<void> saveOrder(OrderModel o)=>db.collection('orders').doc(o.id).set(o.toMap());
 Stream<List<OrderModel>> orders({String? repId}) { Query q=db.collection('orders').orderBy('updatedAt',descending:true); if(repId!=null) q=q.where('salesRepId',isEqualTo:repId); return q.snapshots().map((s)=>s.docs.map((d)=>OrderModel.fromMap(d.id,d.data() as Map<String,dynamic>)).toList()); }
 Future<void> updateStatus(String id,OrderStatus s)=>db.collection('orders').doc(id).update({'status':s.name,'updatedAt':FieldValue.serverTimestamp()});
}
