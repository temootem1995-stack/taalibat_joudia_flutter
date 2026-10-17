// Cloud Function اختيارية لإنشاء Firebase Auth للمندوبين بشكل آمن.
// ضعها في مشروع Functions بعد تثبيت firebase-admin وfirebase-functions.
const {onCall,HttpsError}=require('firebase-functions/v2/https');
const admin=require('firebase-admin'); admin.initializeApp();
exports.createSalesRep=onCall(async (request)=>{
 if(!request.auth) throw new HttpsError('unauthenticated','يجب تسجيل الدخول');
 const caller=(await admin.firestore().doc(`users/${request.auth.uid}`).get()).data();
 if(!caller || caller.role!=='admin') throw new HttpsError('permission-denied','للمسؤول فقط');
 const {username,name,password}=request.data;
 if(!username||!name||!password||password.length<6) throw new HttpsError('invalid-argument','بيانات غير مكتملة');
 const email=`${username.trim().toLowerCase()}@joudia.local`;
 const u=await admin.auth().createUser({email,password,displayName:name});
 await admin.firestore().doc(`users/${u.uid}`).set({username,name,role:'salesRep',active:true,createdAt:admin.firestore.FieldValue.serverTimestamp()});
 return {uid:u.uid};
});