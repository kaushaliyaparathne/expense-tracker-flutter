# Expense Tracker

A simple and user-friendly mobile expense tracking application built with Flutter and Firebase.

## About

Expense Tracker helps users record and manage their daily expenses.

Users can add, edit, delete, and filter expenses while viewing monthly totals and category-wise spending.

## Features

* Add new expenses
* Edit existing expenses
* Delete expenses
* Select expense categories
* Select expense dates
* Add optional notes
* Firebase Firestore data storage
* Monthly expense total
* Category-wise expense summary
* Expense category pie chart
* Filter expenses by category
* Filter expenses by date
* Expense history
* Form validation
* Loading and error states
* Empty state handling
* Confirmation before deleting an expense
* Responsive Flutter UI

## Technologies

* Flutter
* Dart
* Firebase
* Cloud Firestore
* Material Design

## Packages

Main packages used in this project:

* `firebase_core`
* `cloud_firestore`
* `fl_chart`

## Firebase Setup

This application uses Firebase Cloud Firestore to store expense data.

### Setup Steps

1. Create a Firebase project.
2. Add an Android application to the Firebase project.
3. Configure the Flutter project with Firebase.
4. Add the required Firebase configuration files.
5. Enable Cloud Firestore.
6. Configure Firestore security rules.
7. Run the Flutter application.

The Firestore collection used by the application is:

```text
expenses
```

Each expense contains:

* Title
* Amount
* Category
* Date
* Note

## Project Structure

```text
lib/
├── models/
│   └── expense.dart
│
├── screens/
│   ├── add_expense_screen.dart
│   ├── expense_history_screen.dart
│   └── home_screen.dart
│
├── services/
│   └── expense_service.dart
│
├── providers/
│   └── expense_provider.dart
│
├── widgets/
│   ├── empty_state.dart
│   ├── expense_card.dart
│   └── expense_form.dart
│
├── utils/
│   └── constants.dart
│
├── firebase_options.dart
└── main.dart
```

## How to Run

### Prerequisites

Make sure Flutter and Dart are installed.

Check Flutter installation:

```bash
flutter doctor
```

### Install Dependencies

Clone the repository and open the project folder:

```bash
git clone https://github.com/kaushaliyaparathne/expense-tracker-flutter.git
cd expense-tracker-flutter
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

To build a release APK:

```bash
flutter build apk --release
```

The generated APK can be found at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## AI Tools Used

ChatGPT was used to:

* Understand Firebase integration concepts
* Help debug Flutter errors
* Improve code structure
* Review validation and UI implementation

All generated code was reviewed, modified, tested, and understood before submission.

## Screenshots

Screenshots of the application will be added here.

### Home Dashboard

<img width="720" height="1600" alt="WhatsApp Image 2026-09-28 at 17 30 48 (2)" src="https://github.com/user-attachments/assets/0580af4c-87b3-4a8e-817a-2f88bc4c78f6" />


### Add Expense

<img width="720" height="1600" alt="WhatsApp Image 2026-09-28 at 17 30 48" src="https://github.com/user-attachments/assets/0a7e14ef-9c20-4ed0-a127-55c311df26db" />


### Expense History

<img width="720" height="1600" alt="WhatsApp Image 2026-09-28 at 17 30 48 (1)" src="https://github.com/user-attachments/assets/46016465-d90e-45b8-a970-629c0b7cee06" />


### Expense Filters

<img width="720" height="1600" alt="WhatsApp Image 2026-09-28 at 17 30 47" src="https://github.com/user-attachments/assets/d7c245bf-8e8f-433f-af71-5ba97dfc06d3" />


## APK

A release APK was generated using:

```bash
flutter build apk --release
```

APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The APK can be downloaded from the GitHub Releases section if uploaded there.

## AI Tools Used

ChatGPT was used to:

- Understand Firebase integration concepts
- Help debug Flutter errors
- Improve code structure
- Review validation and UI implementation

All generated code was reviewed, modified, tested, and understood before submission.
