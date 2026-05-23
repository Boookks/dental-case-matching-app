# Dental Case-Matching Mobile Application

## Project Overview
This is a Flutter + Firebase mobile application designed to help patients describe dental symptoms, receive a suggested dental case type, and connect with dental students.

The app is an MVP graduation project and should prioritize:
- simplicity
- clean UI
- maintainable code
- beginner-friendly architecture
- fast implementation

The app is NOT intended to be production-level or enterprise-scale.

---

# Main User Roles

## 1. Patient
Patients can:
- Register/Login
- Describe symptoms
- Receive a suggested case type
- Create dental case posts
- View their own posts
- Manage profile

## 2. Dental Student
Students can:
- Register/Login
- Browse patient posts
- Filter posts by case type
- View case details
- Contact patients externally using provided contact information
- Manage profile

---

# Smart Suggestion Feature

The smart suggestion system is NOT real AI.

It should work using:
- predefined symptom questions
- simple conditional logic
- category-based suggestions

Example suggestions:
- Possible Cavity Case
- Possible Gum Disease Case
- Possible Root Canal Case

IMPORTANT:
The app must NEVER present suggestions as real medical diagnoses.

Use wording like:
- Suggested Case Type
- Possible Dental Issue

NOT:
- Diagnosis

---

# Tech Stack

Frontend:
- Flutter

Backend:
- Firebase

Database:
- Cloud Firestore

Authentication:
- Firebase Authentication

Storage:
- Optional Firebase Storage (only if needed later)

---

# Project Architecture

Use SIMPLE beginner-friendly architecture.

Avoid:
- overly complex clean architecture
- advanced patterns
- unnecessary abstractions

Use this structure:

lib/
├── models/
├── screens/
├── widgets/
├── services/
├── utils/
├── constants/
└── main.dart

---

# Folder Responsibilities

## models/
Contains data models:
- user_model.dart
- post_model.dart

## screens/
Contains app screens:
- login_screen.dart
- register_screen.dart
- patient_home_screen.dart
- student_home_screen.dart
- etc.

## widgets/
Reusable UI widgets:
- custom_button.dart
- post_card.dart
- custom_textfield.dart

## services/
Firebase and business logic:
- auth_service.dart
- firestore_service.dart

## utils/
Helper methods and utility functions.

## constants/
App colors, theme, strings.

---

# Main Screens

## Authentication
- LoginScreen
- RegisterScreen
- RoleSelectionScreen

## Patient Screens
- PatientHomeScreen
- SmartSuggestionScreen
- CreatePostScreen
- MyPostsScreen
- ProfileScreen

## Student Screens
- StudentHomeScreen
- FilterScreen
- CaseDetailsScreen
- ProfileScreen

---

# Navigation Rules

Use named routes.

Keep navigation simple and consistent.

Avoid complicated nested navigation.

---

# UI Design Guidelines

The UI should be:
- modern
- minimal
- clean
- beginner-friendly
- mobile-first

Theme:
- blue and white medical style
- rounded cards
- clean spacing
- simple icons
- no complicated animations

DO NOT:
- overdesign the UI
- use advanced animations
- create overly complex layouts

Prioritize:
- readability
- consistency
- functionality

---

# Firestore Collections

## users
Fields:
- uid
- name
- email
- role
- createdAt

## posts
Fields:
- postId
- userId
- title
- description
- symptoms
- suggestedCaseType
- contactInfo
- createdAt

---

# Authentication Rules

Use Firebase email/password authentication only.

Do NOT implement:
- Google sign in
- phone auth
- social login

unless specifically requested later.

---

# Communication Rules

The app does NOT include:
- chat
- messaging
- notifications
- real-time communication

Students contact patients externally using:
- phone number
- email
- WhatsApp

provided in the patient post.

---

# MVP Priorities

Highest Priority:
1. Authentication
2. Role selection
3. Smart suggestion feature
4. Create post
5. Browse posts
6. View case details
7. Firebase integration

Medium Priority:
- profile management
- filtering

Low Priority:
- advanced UI polish
- animations
- extra features

---

# Coding Rules

IMPORTANT:
- Keep code beginner-friendly
- Keep files readable
- Avoid unnecessary complexity
- Avoid generating huge files
- Reuse widgets when possible
- Use clear variable names
- Add comments for important sections

---

# Important Development Strategy

Build the app in this order:

1. App skeleton
2. Navigation
3. Authentication
4. Patient UI
5. Student UI
6. Firebase integration
7. Smart suggestion logic
8. Testing and bug fixing

Test each feature immediately after implementation.

Do NOT build everything at once.

---

# Important Notes

This is a university graduation MVP project.

The goal is:
- functional demo
- stable app
- clear project structure
- understandable code

NOT:
- enterprise scalability
- production-grade complexity
- advanced AI systems