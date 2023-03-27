# tindog

A new Flutter project.

## V1.0.0
รายละเอียด : เป็นการอัพโหลดโค้ดทั้งหมดลงใน github ครั้งแรก ในเวอร์ชั่นนี้ feature ที่สามารถใช้งานได้แก่ การสมัครสมาชิก(ชื่อ อายุ เพศ อีเมล์ อาชีพ) การอัพโหลดรูปภาพสุนัขพร้อมรายละเอียดจาก cloud firebase (ชื่อ อายุ สายพันธ์ุ เพศ คำอธิบายประกอบ) และการอัพโหลดรูปภาพ แก้ไข delete โดยใช้ Node.js จัดการเรื่อง API (มีแฟมเวิร์คเป็น express) 
error : มีการแสดง Null check operator used on a null value ตรงบริเวณ drawer เมื่อเปิดแอพขึ้นมา เพราะยังไม่ได้ logout ID เก่า

## V1.0.0
รายละเอียด : แก้บัคตรง drawer เมื่อมีเปิดแอพโดยที่ยังไม่ได้ log in ทำให้ไม่มีข้อมูลส่งมาจาก firebase <br>
snapshot.data?.data() == null <br>
FirebaseFirestore.instance.collection('users').doc(user!.uid).get(), ตรงจุดนี้คือสาเหตุ เพราะเกิด check null
