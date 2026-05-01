# u2me — Flutter Dating Prototype

u2me is a lightweight Flutter prototype for a dating / social discovery app. It contains core screens, mocked authentication, and in-app profile/matching flows suitable for local demos and iterative development.

## Quick start

- Requirements: Flutter SDK (stable), Dart, platform toolchains for Android/iOS if running on device/emulator.
- To run locally:

```bash
flutter pub get
flutter run
```

## Project overview

This repository contains a simple, modular Flutter app with the following high-level folders:
- `lib/controllers/` — State controllers (GetX) for auth, matches, swipe, settings.
- `lib/models/` — Data models used across the app.
- `lib/views/` — Screen implementations grouped by feature (auth, main, onboarding, profile, swipe, settings).
- `lib/widgets/` — Reusable UI widgets (e.g., `user_card`).

## Screens and features

	- Login: Email/password sign-in (mocked). Demo account available.
	- Signup: Create an account (mocked) and proceed to onboarding.
	- Onboarding flow: Collect basic profile details after signup.

	- Swipe deck: Browse candidate profiles with swipe left/right gestures.
	- Profile preview: Tap a card to see profile details (photos, bio, interests).
	- Match confirmation: When two users mutually like each other, a match screen appears.
- **Matches & Messages** (`lib/views/main/` / messaging)

Detailed screen descriptions & workflows

- **Auth - Login** (`lib/views/auth/login.dart`)
	- Purpose: Authenticate returning users.
	- Key elements: Email and password fields, primary Sign In button, links for Sign Up and Forgot Password, optional "Sign in as demo" action.
	- User actions: Enter credentials -> tap Sign In -> `AuthController.signIn()` or `signInAsDemo()` for the demo account.
	- Data flow: On success, the controller persists the `current_user` in `SharedPreferences` and navigates to `/main`.
	- Edge cases: Invalid credentials show an error snackbar; loading state disables inputs.

- **Auth - Sign Up / Onboarding** (`lib/views/auth/signup.dart`, `lib/views/onboarding/`)
	- Purpose: Collect minimal profile info for new users and create an initial profile.
	- Key elements (signup): Email, password, name, age, gender, lookingFor.
	- Key elements (onboarding): Photo upload, bio, interests, location/distance preferences.
	- Workflow: Sign Up -> `AuthController.signUp()` creates a mocked `UserModel` -> app navigates to Onboarding to collect richer profile fields -> Onboarding calls controller update methods and finally routes to `/main`.
	- Data flow: Temporary onboarding state is merged into `UserModel` then persisted via `AuthController.updateProfile()`.

- **Main / Swipe Deck** (`lib/views/swipe/swipe_view.dart`)
	- Purpose: Core discovery experience — surface candidate profiles and collect like/dislike input.
	- Key elements: Stack of `UserCard` widgets, like/dislike/super-like buttons, rewind/undo (if enabled), profile preview modal.
	- User actions: Swipe right = like, swipe left = pass, tap = open full profile, press Super Like = stronger interest.
	- Workflow: User swipes -> `SwipeController` updates the local match/love state -> when both users like each other in the mocked dataset, the UI shows a Match overlay and the `MatchesController` records the match.
	- Edge cases: Deck exhaustion shows a "No more profiles" state; network or mock data errors fall back to local sample profiles.

- **Profile Preview / Detail** (`lib/views/profile/profile_view.dart`)
	- Purpose: Present a candidate's full profile (photos carousel, bio, basic info, interests, social links).
	- Key elements: Photo carousel, info tiles (occupation, education, distance), actions (like, message if matched), report/block options.
	- Workflow: Open from swipe deck or matches -> view full details -> optionally like or message (if already matched).
	- Data flow: Read-only for other users; updates to the signed-in user's profile are handled in the Edit Profile screen.

- **Matches & Messages** (`lib/views/main/matches_view.dart`, `lib/views/main/chat_view.dart`)
	- Purpose: Surface users who mutually liked each other and enable conversations.
	- Key elements: Matches list (cards), unread badges, chat threads, simple message composer.
	- Workflow: When a mutual like occurs, add an entry to `MatchesController.matches`. From a match, open the chat view to exchange messages (mocked; messages are ephemeral/local unless wired to backend).
	- Edge cases: Offline behavior stores messages locally; message delivery is simulated in the demo.

- **Edit Profile** (`lib/views/profile/edit_profile.dart`)
	- Purpose: Allow users to modify their profile data.
	- Key elements: Photo management (add/remove/reorder), editable text fields (name, bio), pickers for occupation/education/relationshipGoal, toggles for visibility/filters.
	- Workflow: User edits fields -> `AuthController.updateProfile()` persists changes locally -> success snackbar displayed.
	- Data flow: The controller serializes the `UserModel` into `SharedPreferences` under `current_user`.

- **Settings** (`lib/views/settings/settings_view.dart`)
	- Purpose: App-level preferences and account actions.
	- Key elements: Discovery radius, age range, notification toggles, privacy options, Sign Out, Delete Account.
	- Workflow: Changing preferences updates a `SettingsController` (local) and persists settings; Sign Out calls `AuthController.signOut()`; Delete calls `AuthController.deleteAccount()` (mocked).

UX notes and small interaction rules

- Loading state: Controllers expose `isLoading` to show spinners and disable primary actions during API/mocked calls.
- Navigation: App uses GetX named routes (see `lib/routes/app_routes.dart`) and central controllers via `Get.find()`.
- Persistence: `SharedPreferences` stores the `current_user` JSON string for session continuity between app launches.

Developer pointers

- See `lib/controllers/auth_controller.dart` for authentication and demo account logic.
- Match-making and swipe logic live in `lib/controllers/swipe_controller.dart` and `lib/controllers/matches_controller.dart`.
- UI widgets such as `lib/widgets/user_card.dart` are intentionally small and reusable — extend them when adding new profile fields or actions.

Example screen-by-screen demo workflow (happy path)

1. Launch app -> Login screen -> Tap `Sign in as demo` -> `AuthController.signInAsDemo()` persists demo user and navigates to `/main`.
2. On the Swipe deck, view profiles -> swipe right on an interesting profile.
3. If a mutual like is simulated by the demo dataset, a Match overlay appears and the new match is added to Matches.
4. Open Matches -> select a match -> send a message in the chat view.
5. Go to Profile -> Edit profile -> update bio -> changes persist and reflect in the Swipe cards.
	- Matches list: See users you matched with.
	- Chat interface: One-to-one messaging with matched users (mocked, local only).

- **Profile** (`lib/views/profile/`)
	- View/Edit profile: Update name, bio, photos, occupation, education, lifestyle and social links.
	- Privacy & preferences: Set what you’re looking for, filters, and discovery distance.

- **Settings** (`lib/views/settings/`)
	- App settings, sign out, delete account (mocked delete).

## Workflow (user journey)

1. New user opens the app and lands on the **Auth** screens.
2. User signs up and completes **Onboarding** (profile basics).
3. User enters the **Main / Swipe** screen and starts browsing profiles.
4. If the user and another profile both swipe right, they become a **Match**.
5. Matches appear in the **Matches** list where users can open a chat.
6. Users can update their profile and preferences from **Profile** and **Settings**.

All server interactions in this prototype are mocked locally (see `AuthController`). The app persists a `current_user` object to `SharedPreferences` to simulate a logged-in session.

## Demo account

To make demos and reviews easier, a built-in demo account is provided.

- Demo credentials:
	- Email: `demo@u2me.app`
	- Password: `demo1234`

- How to use the demo account:
	- In the app's login screen enter the demo credentials above to sign in.
	- Alternatively, from developer code you can programmatically sign in the demo user by calling `AuthController.to.signInAsDemo()` (helper added in `lib/controllers/auth_controller.dart`).

Developer note: the demo account is mocked and intended only for local development or presentations; it does not contact a real backend and the credentials are stored only in code for convenience.

## Developer notes

- Auth is mocked in `lib/controllers/auth_controller.dart` using `SharedPreferences` to persist a JSON string under the `current_user` key.
- To wire a real backend, replace the mock logic in `signIn`, `signUp`, and `checkAuthStatus` with API calls and proper token handling.
- The demo sign-in helper `signInAsDemo()` provides a ready-made user object for demos — feel free to expand the demo user's photos, bio, or interests in `AuthController`.

## Next steps / suggestions

- Add backend endpoints for auth, profile, matches, and messaging.
- Replace SharedPreferences persistence with secure storage and token-based auth.
- Add E2E tests and unit tests for controllers.

---
If you'd like, I can also:
- Add a visible "Sign in as demo" button to the login screen.
- Expand the demo user's profile with more photos and realistic data.
- Scaffold backend API interfaces for the key flows.

Tell me which of these you'd like me to implement next.
