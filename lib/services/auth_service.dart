import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/models.dart';
class AuthService {
 final _auth=FirebaseAuth.instance; final _db=FirebaseFirestore.instance;
 String email(String u)=>'${u.trim().toLowerCase()}@joudia.local';
 Future<void> bootstrapAdmin() async { try { final c=await _auth.createUserWithEmailAndPassword(email:email('admin'),password:'123456'); await _db.collection('users').doc(c.user!.uid).set({'username':'admin','name':'المسؤول الرئيسي','role':'admin','active':true,'createdAt':FieldValue.serverTimestamp()}); } on FirebaseAuthException catch(e) { if(e.code!='email-already-in-use') rethrow; } }
 Future<AppUser?> signIn(String username,String password) async { final c=await _auth.signInWithEmailAndPassword(email:email(username),password:password); final d=await _db.collection('users').doc(c.user!.uid).get(); if(!d.exists) throw Exception('حسابك غير مهيأ في قاعدة البيانات'); final u=AppUser.fromMap(d.id,d.data()!); if(!u.active) throw Exception('الحساب موقوف'); return u; }
 Future<void> signOut()=>_auth.signOut();
 Future<void> createRepRecord(String username,String name) async { await _db.collection('users').doc('pending_${username.trim()}').set({'username':username.trim(),'name':name.trim(),'role':'salesRep','active':true,'pendingAuth':true,'createdAt':FieldValue.serverTimestamp()}); }
 Stream<List<AppUser>> users()=>_db.collection('users').snapshots().map((s)=>s.docs.map((d)=>AppUser.fromMap(d.id,d.data())).toList());
 Future<void> setUserActive(AppUser u,bool active)=>_db.collection('users').doc(u.id).update({'active':active});
 Future<void> deleteUser(AppUser u)=>_db.collection('users').doc(u.id).delete();
}