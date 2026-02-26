# 🌱 LOOP — Circular Industrial Marketplace

---

## 📌 Introduction

LOOP is a Flutter-based mobile application developed to promote sustainable industrial collaboration through circular economy practices. The platform enables businesses to register securely, manage their company details, and participate in a resource-sharing ecosystem that reduces industrial waste and improves resource utilization.

The application uses:

* **Firebase Authentication** for secure user access
* **Cloud Firestore** for structured data storage

---

## 👩‍💻 Developed By

* **Kavyashree Chandarasekaran**
* *LOOP — Circular Solutions for Industrial Sustainability*

---

## 🛠 Tech Stack

* **Flutter** — Mobile Application Development
* **Dart** — Programming Language
* **Firebase Authentication** — User Login & Account Creation
* **Cloud Firestore** — Database Storage
* **Firebase Core** — Firebase Initialization

---

## 🚀 Features

### 🔐 Authentication

* Secure Email & Password Login
* Firebase Authentication Integration
* Persistent User Sessions

---

### 🏢 Multi-Step Business Registration

The onboarding process is divided into **four steps**:

#### 1️⃣ Business Information

* Business Name
* Business Type
* Registration ID
* Year of Establishment

#### 2️⃣ Business Location

* Address
* City
* ZIP Code
* State

#### 3️⃣ Contact Details

* Contact Person Name
* Official Email
* Mobile Number

#### 4️⃣ Account Security

* Password Creation

* Firebase Account Setup

* Firestore Data Storage

* All fields are validated before moving to the next step.

---

### 🏠 Home Dashboard

* Accessible after successful login or registration
* Displays authentication success
* Expandable for marketplace modules

---

## 📂 Folder Structure

```
lib/
│
├── core/
│   └── colors.dart
│
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_step1.dart
│   │   ├── register_step2.dart
│   │   ├── register_step3.dart
│   │   └── register_step4.dart
│   │
│   └── home_screen.dart
│
├── firebase_options.dart
└── main.dart
```

---

## ▶️ How To Run The Project

### 1️⃣ Clone Repository

```
git clone <repository-link>
```

### 2️⃣ Install Dependencies

```
flutter pub get
```

### 3️⃣ Firebase Setup

* Create a Firebase Project
* Enable:

  * Email/Password Authentication
  * Cloud Firestore Database
* Add Android App in Firebase Console
* Download:

  * `google-services.json`
* Place it inside:

  ```
  android/app/
  ```

### 4️⃣ Run Application

```
flutter clean
flutter pub get
flutter run
```

Make sure:

* Emulator or Android device is connected

---

## ✅ Result

* Splash Screen launches application
* Users can securely login or register
* Registration follows a structured multi-step onboarding process
* Business data is stored securely in Firebase Firestore
* Users are redirected to the Home Screen after successful account creation
