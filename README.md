# Expense Management App

**Welcome to the Expense Management App repository!**

A comprehensive solution to track expenses, visualize spending patterns, and manage financial data through intuitive charts and reports.

---

## Features

- **Secure Authentication**: Login/Signup with Firebase Auth integration
- **Data Visualization**: Interactive pie charts and bar graphs for expense categories
- **Expense Management**: Add/edit/delete expenses with category selection and date tracking
- **Advanced Filtering**: Sort and filter expenses by date
- **PDF Export**: Generate and share expense reports in PDF format
- **Theme Customization**: Light/dark theme switching in settings
- **Push Notifications**: Financial insights via notification system

---

## Screens

1. **Splash Screen**
    - Branding screen with app logo and initial loading

2. **Auth Screen**
    - User login and registration interface
    - Email/password validation and error handling

3. **Home Screen**
    - Pie chart and bar graph visualization of expense distribution
    - Category percentage breakdown

4. **Expense List Screen**
    - Chronological list of all expenses
    - Sort by date
    - Export to PDF functionality
    - Floating action button for adding new expenses

5. **Expense Form Screen**
    - Input form with title, amount, and category selection
    - Date picker and category bottom sheet
    - Slide-to-delete/edit functionality

6. **Settings Screen**
    - Theme switcher (light/dark mode)
    - Profile editing options
    - Help/FAQs section
    - Logout and account deletion

7. **Notification Screen**
    - History of push notifications
    - System alerts and financial reminders

8. **Exported PDF Screen**
    - Generated expense reports in PDF format
    - Shareable financial summaries

---

## Tech Stack

- **Frontend**: Flutter
- **State Management**: Riverpod (Enhanced provider version)
- **Architecture**: Clean Architecture
- **Local Database**: sqflite
- **Authentication**: Firebase Auth
- **Notifications**: Firebase Cloud Messaging
- **PDF Generation**: `pdf` package
- **Charting**: `fl_chart` package

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/expense-management-app.git

2. Navigate to the project directory:
   ```bash
   cd your-project-directory
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run

## Testing

**Unit Testing**
 ```bash
   flutter test test/unit/auth/login_viewmodel_test.dart
   ```
**Integration Testing**
 ```bash
   flutter drive --driver test/integration_test/driver.dart --target test/integration_test/app_test.dart --dart-define=IS_INTEGRATION_TEST=true
   ```
