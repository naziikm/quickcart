# QuickCart

QuickCart is a Flutter grocery delivery app with Firebase Authentication,
Firestore, and Firebase Storage. It includes login, signup, phone OTP,
product browsing, cart, checkout, and order tracking.

## Firebase Setup

1. Create a Firebase project.
2. Add Android app:
	 - Package name: update `applicationId` in
		 [android/app/build.gradle.kts](android/app/build.gradle.kts).
	 - Download `google-services.json` and place it in
		 [android/app](android/app).
3. Add iOS app:
	 - Bundle ID: set in Xcode (Runner target).
	 - Download `GoogleService-Info.plist` and place it in
		 [ios/Runner](ios/Runner).
4. Enable Authentication providers in Firebase Console:
	 - Email/Password
	 - Phone
5. Enable Firestore and Storage.

## Firestore Structure

Collections used by the app:

- `products`
	- `name` (string)
	- `description` (string)
	- `price` (number)
	- `imageUrl` (string)
	- `category` (string)
	- `unit` (string)
	- `isAvailable` (bool)

- `orders`
	- `userId` (string)
	- `address` (map)
	- `items` (list)
	- `status` (string)
	- `total` (number)
	- `createdAt` (timestamp)

## Firestore Rules (Dev Only)

```
rules_version = '2';
service cloud.firestore {
	match /databases/{database}/documents {
		match /products/{productId} {
			allow read: if true;
			allow write: if false;
		}
		match /orders/{orderId} {
			allow read, write: if request.auth != null
				&& request.auth.uid == resource.data.userId;
			allow create: if request.auth != null
				&& request.auth.uid == request.resource.data.userId;
		}
	}
}
```

## Run the App

1. Install dependencies:
	 - `flutter pub get`
2. Run on a device:
	 - `flutter run`

## Notes

- Product images should be hosted in Firebase Storage or a public URL.
- Order status values: `placed`, `preparing`, `outForDelivery`, `delivered`.
