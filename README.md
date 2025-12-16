# 🍽️ YumShare

**YumShare** là một ứng dụng mobile chia sẻ công thức nấu ăn, nơi người dùng có thể khám phá món ăn từ khắp nơi trên thế giới, lưu lại công thức yêu thích và kết nối với những đầu bếp khác.

Ứng dụng được xây dựng với mục tiêu:

* Trải nghiệm mượt mà, tập trung vào nội dung
* Dữ liệu rõ ràng, dễ mở rộng
* Kiến trúc phù hợp cho mobile app thực tế
  
---

## 🛠️ Công nghệ sử dụng

* **Flutter**
* **GetX** (State management & Dependency Injection)
* **Firebase**

  * Authentication
  * Cloud Firestore
* **REST Countries API**
* **Local Storage**  : Hive

---

## ✨ Tính năng chính

### 👀 Khám phá (Discover)

* Xem danh sách công thức mới nhất
* Xem danh sách công thức phổ biến, yêu thích, được đề xuất
* Phân loại theo **Category** (Beef, Chicken, Dessert, …)
* Phân loại theo **Region / Country**
* Phân loại theo **Chefs**

### 🍳 Công thức (Recipes)

* Tạo công thức: ảnh, tên, nguyên liệu, các bước
* Xem chi tiết công thức: nguyên liệu, các bước thực hiện, thời gian nấu, ...
* Công khai công thức nấu ăn cho cộng đồng 
* Có thể đánh giá, like và comment 
* Gợi ý công thức tương tự dựa trên category và region

### ❤️ Yêu thích

* Lưu công thức vào danh sách yêu thích
* Truy xuất nhanh các món đã lưu

### 👨‍🍳 Người dùng

* Đăng nhập / đăng ký
* Xem profile đầu bếp
* Hiển thị top users dựa trên số lượng công thức

---

## 🧱 Kiến trúc

Ứng dụng được xây dựng theo hướng tách biệt rõ ràng:

* **UI (View)**: chỉ render dữ liệu
* **Controller (GetX)**: quản lý state và xử lý logic
* **Repository**: lấy và ghi dữ liệu
* **Service**: auth, cache, helper

```text
UI → Controller → Repository → Firebase / API
```

### State Management

* **GetX** với `Rx`, `Obx`
* Mỗi feature có controller riêng

---

## 📂 Cấu trúc thư mục (rút gọn)

```text
lib/
├── features/
│   ├── auth/
│   ├── discover/
│   ├── recipe/
│   └── profile/
├── models/
├── repository/
├── services/
└── utils/
```

---

## 🚀 Cài đặt & chạy dự án

```bash
flutter pub get
flutter run
```

Yêu cầu:

* Flutter SDK
* Firebase project được cấu hình

---


## 📌 Định hướng phát triển

* Share công thức
* Notification

---

## 👤 Tác giả

**YumShare** được phát triển như một dự án cá nhân và thực hành Flutter, tập trung vào kiến trúc và tư duy xây dựng ứng dụng mobile thực tế.

---

> *Cook. Share. Discover the world through food.* 🌎🍜
