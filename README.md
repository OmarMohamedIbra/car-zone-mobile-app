# CarZone Mobile App Documentation

## Overview

**CarZone** is a Flutter-based mobile application that serves as a comprehensive platform for car enthusiasts. The app enables users to browse cars, participate in events, and manage their profiles within a premium, community-driven environment.

---

## Project Structure

- **lib/presentation/main.dart:** Entry point of the app.
- **lib/presentation/auth.dart:** Handles authentication (login, registration).
- **lib/presentation/home.dart:** Main navigation and home page.
- **lib/presentation/carStore.dart:** Car browsing and details.
- **lib/presentation/event.dart:** Event browsing and registration.
- **lib/presentation/profile.dart:** User profile and settings.

---

## Navigation Flow

The navigation is managed via a **Bottom Navigation Bar** with four main sections:

1. **Home (🏠)**
2. **Cars (🚗)**
3. **Events (🎪)**
4. **Profile (👤)**

### 1. Authentication Flow

- The app starts with the **AuthScreen** (`auth.dart`), allowing users to log in or register.
- Upon successful authentication, users are routed to the **Home** page.

### 2. Home Page

- **Welcome Header:** Personalized greeting and logo.
- **Search Bar:** Allows searching for cars, deals, and services.
- **Hot Deals:** Showcases highlighted car deals.
- **Testimonials:** Displays user feedback.
- **Navigation:** Bottom navigation bar for switching between sections.

### 3. Cars Page

- Accessible via the "Cars" icon (🚗) in the bottom navigation.
- Displays a list/grid of available cars.
- Each car card includes model, year, price, engine, transmission, mileage, and features.
- Users can tap a car to view details.

### 4. Events Page

- Accessible via the "Events" icon (🎪).
- Lists upcoming car-related events (e.g., auto shows, driving experiences, summits).
- Each event card shows an image, title, date, and status.
- Users can register for events or view more details.
- Button at the bottom allows viewing all registered events.

### 5. Profile Page

- Accessible via the "Profile" icon (👤).
- **Header:** Shows user info and avatar.
- **Registered Events:** Quick access to events the user is signed up for.
- **Account Settings:**
  - Notifications: Enable/disable push notifications.
  - Language: Select app language.
  - Privacy: Manage privacy settings.
- **Support & About:**
  - Contact Support, Feedback, About CarZone, App Version.
- **Logout:** Securely sign out of the app.

---

## How to Navigate the App

- **Switch Sections:** Use the bottom navigation bar to switch between Home, Cars, Events, and Profile.
- **View Car Details:** Tap any car in the Cars section to see more information.
- **Register for Events:** Go to Events, select an event, and follow prompts to register.
- **Manage Your Profile:** Go to Profile to update settings, view events, or contact support.

---

## Design & User Experience

- **Consistent Theming:** The app uses a dark, modern theme with gold accents.
- **Smooth Animations:** Fade transitions and animations enhance navigation.
- **Responsive Layout:** Optimized for various screen sizes.

---

## Further Customization

- Add new car data or events via backend integration.
- Enhance user profile with more personalization options.
- Integrate notifications and multilingual support.

---

## Getting Started

1. Run `flutter pub get` to install dependencies.
2. Launch the app on your emulator or device: `flutter run`.
3. Register or log in to access all features.

---

For more technical details, see the code under the `lib/presentation` directory.

---
