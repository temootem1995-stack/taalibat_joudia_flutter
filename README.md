# طلبيات مناديب الجوديا

تطبيق Flutter عربي RTL لإدارة طلبات المندوبين والعمل دون اتصال مع Firebase عند توفر الإنترنت.

## التشغيل

1. أنشئ مشروعًا في Firebase.
2. فعّل Firebase Authentication بطريقة Email/Password وCloud Firestore.
3. من مجلد المشروع شغّل:

```bash
flutter pub get
flutterfire configure
flutter run
```

4. انسخ قواعد `firestore.rules` إلى Firestore Rules.
5. افتح التطبيق واضغط **إنشاء المسؤول الافتراضي** ثم سجّل بـ:
   - اسم المستخدم: `admin`
   - كلمة المرور: `123456`

> اسم المستخدم يُحوَّل داخليًا إلى بريد تقني: `admin@joudia.local`. غيّر كلمة المرور فورًا من Firebase أو أضف شاشة تغيير كلمة المرور قبل الاستخدام الفعلي.

## ملاحظات مهمة

- يجب أن يكون ملف `lib/firebase_options.dart` مولّدًا بواسطة `flutterfire configure`، ولا تضع مفاتيح Firebase في هذا المستند.
- إنشاء المستخدمين الآخرين من داخل التطبيق يتطلب Cloud Function لأن Firebase Auth لا يسمح للمسؤول بإنشاء حساب دون تسجيل خروجه. النسخة الحالية تنشئ سجل المندوب في Firestore وتعرض للمسؤول بيانات حساب مقترحة؛ استخدم Cloud Function الإنتاجية الواردة في `docs/create_user_function.js`.
- PDF والمشاركة يعملان محليًا. رفع PDF إلى Storage اختياري ويمكن إضافته لاحقًا.