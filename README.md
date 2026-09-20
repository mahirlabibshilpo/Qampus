# QAMPUS 🎓
> **Smart Access, Better Campus**

QAMPUS is an all-in-one smart university campus companion application built with Flutter. It streamlines campus life by integrating essential academic and student services into an intuitive, elegant mobile experience.

---

## 📱 Features

### 1. 🔐 Authentication & Security
- Secure sign-in powered by **Firebase Authentication**.
- Built-in fallback authentication for offline testing.
- Demo student credentials available for testing:
  - **Email:** `student@qampus.com` / `aust@gmail.com`
  - **Password:** `123456`

### 2. 📚 Library Services
- Real-time seat occupancy counter and availability tracker.
- Book catalog search and issue/return tracking.
- Study room reservations and quiet zone status.

### 3. 🍽️ Canteen Services
- Cafeteria token management and orders.
- Daily meal menus and price lists.
- Real-time rush hour indicator and cafeteria schedule.

### 4. 👥 Club Office
- Directory of active university clubs and societies.
- Upcoming campus events, workshops, and competitions.
- Direct club membership registration.

### 5. 📢 Notice Board
- Centralized hub for official university notices and announcements.
- Categorized feeds (Academic, Exam, Holidays, Cultural).
- Real-time badge indicators for urgent updates.

### 6. 🏛️ Administrative Office
- Student ID reissue requests.
- Semester fee payment tracking and receipts.
- Official clearance and transcript request workflows.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Channel stable, SDK `^3.13.1`)
- **Language:** [Dart](https://dart.dev/)
- **Backend & Services:**
  - Firebase Core
  - Firebase Authentication
  - Cloud Firestore
- **Animations & UI:**
  - `flutter_animate`
  - Material Design 3

---

## 📂 Project Structure

```text
lib/
├── administrative_office.dart  # Admin services & clearance requests
├── auth_service.dart           # Local & session auth manager
├── canteen.dart                # Cafeteria menu & token system
├── club_office.dart            # Club events & registration
├── firebase_options.dart       # Firebase platform configuration
├── home.dart                   # Main campus services dashboard
├── library.dart                # Library seats, books & room status
├── login.dart                  # User login screen
├── main.dart                   # App entry point
├── models/
│   └── book.dart               # Data models
├── notice_board.dart           # University notices & circulars
└── splash.dart                 # Animated splash screen
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
- Android Studio / VS Code with Flutter extensions.
- An active Android Emulator, iOS Simulator, or connected physical device.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/mahirlabibshilpo/Qampus.git
   cd Qampus
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run the automated widget and integration tests using:
```bash
flutter test
```

---

## 📄 License
This project is developed for university campus management and student life facilitation.
