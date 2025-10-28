SafeSpace — Your Personal Mental Wellness & Therapy Companion
SafeSpace is a Flutter-based mobile app designed to help users manage their mental well-being through journaling, self-reflection, mood tracking, and personalized wellness resources — all in a safe digital space.

Built for accessibility, privacy, and comfort, it combines AI-assisted chat, local data storage, and easy payment integration for unlocking premium self-care tools.

🌟 Key Features
🧠 Core (Free)
- Mood Journal – Track and reflect on your emotions with daily entries.
- Wellness Feed – View calming affirmations and self-care insights.
- AI Chat Companion – Have guided conversations for mindfulness.
- Insights Dashboard – See mood statistics and behavioral trends.
- Profile Management – Personalize your identity within the app.

💎 Premium (Upgrade)
- 🎵 Relaxing Music – Access curated tracks for stress relief.
- 🎥 Motivational Videos – Watch inspiring clips for daily uplift.
- 📚 Resources Hub – Read articles and books on mental wellness.
- 🖋️ Journaling Pro – Reflect deeper with structured prompts.
- 💬 Talk to Affy – Connect with human support via WhatsApp.
- ☎️ Africa Helplines – Contact verified mental health hotlines.

⚙️ Tech Stack
Category	Tools Used
Framework	Flutter (Dart)
State Storage	Hive (Local NoSQL)
Authentication	Custom Email Auth (local Hive)
Payment	Flutterwave Integration
Environment	Flutter .env via flutter_dotenv
UI Design	Material 3 & GridView Layout
Persistence	SharedPreferences + Hive
🚀 Project Setup
1️⃣ Clone the repository
git clone https://github.com/yourusername/safespace.git
cd safespace

2️⃣ Install dependencies
flutter pub get

3️⃣ Configure environment variables
Create an .env file inside your assets/ folder:
FLW_PUBLIC_KEY=FLWPUBK_TEST-xxxxxxxxxxxxxxxxxxxxxx-X
FLW_SECRET_KEY=FLWSECK_TEST-xxxxxxxxxxxxxxxxxxxxxx-X



4️⃣ Run the app
flutter run

💳 Flutterwave Integration
SafeSpace integrates with Flutterwave’s hosted checkout for secure premium upgrades.
Test environment uses the Sandbox Mode
Real payments can be switched on via your Flutterwave dashboard

The upgrade process:
- Tap “Upgrade Now 💳”
- Complete payment on Flutterwave checkout page
- Return to app → Premium features automatically unlock 🎉

💾 Data Storage
- All user data (moods, chats, preferences) are stored locally on-device via Hive.
- Each account is tied to an email address — entries persist upon login.
- Premium access is saved using SharedPreferences to persist status even after closing the app.

🪄 Core Folder Structure
lib/
 ├── main.dart
 ├── models/
 │    ├── mood_entry.dart
 │    ├── chat_message.dart
 ├── screens/
 │    ├── auth/
 │    │    ├── login_screen.dart
 │    │    └── signup_screen.dart
 │    ├── Upgrade/
 │    │    ├── upgrade_screen.dart
 │    │    ├── music_screen.dart
 │    │    ├── videos_screen.dart
 │    │    ├── resources_screen.dart
 │    │    ├── journal_screen.dart
 │    │    ├── support_screen.dart
 │    ├── home_screen.dart
 │    ├── mood_screen.dart
 │    ├── wellness_screen.dart
 │    ├── chat_screen.dart
 │    └── profile_screen.dart
 ├── services/
 │    └── auth_service.dart
 └── assets/
      └── .env

🧭 How to Use the App
Create an Account → Sign up using your email and password.
Log In → Access your saved data and journals anytime.
Explore Free Features → Try mood tracking, chat, and wellness tips.
Upgrade to Premium → Unlock all tools and resources via Flutterwave.
Enjoy Personalized Self-Care — wherever, whenever.

🧩 Developer Notes
- All payment actions are handled externally through Flutterwave’s hosted payment link.
- The app does not store any card data — ensuring complete user safety.
- Works across Android, iOS, and Web (PC-friendly).
- To modify features, simply edit the corresponding screen in lib/screens/.

🧑 Author
Affy: Creator of SafeSpace – A mindful app for modern wellness
 [rofiatadepitan33@gmail.com]


📜 License
This project is licensed under the MIT License – feel free to use, modify, and build upon it.