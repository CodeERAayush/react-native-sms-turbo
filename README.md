# react-native-sms-turbo

A React Native **TurboModule** for sending SMS messages across Android and iOS.

- **Android**: Sends SMS directly in the background via `SmsManager` (requires `SEND_SMS` permission).
- **iOS**: Opens the native `MFMessageComposeViewController` for user-confirmed sending.

Built with the **New Architecture** (TurboModules + Codegen) for type-safe, high-performance native bridge calls.

## Installation

```bash
npm install react-native-sms-turbo
# or
yarn add react-native-sms-turbo
```

### iOS

```bash
cd ios && pod install
```

### Android

The `SEND_SMS` permission is declared in the library's `AndroidManifest.xml` and will be merged automatically. No additional setup needed.

## Usage

```typescript
import { SMSManager } from 'react-native-sms-turbo';

// Check if SMS is available on this device
const available = await SMSManager.isSMSAvailable();

// Check permission status (Android only, iOS always returns 'granted')
const status = await SMSManager.checkSMSPermission();

// Request SMS permission (Android only)
const result = await SMSManager.requestSMSPermission();

// Send an SMS
try {
  const response = await SMSManager.sendSMS('+1234567890', 'Hello from React Native!');
  console.log(response); // 'SMS Sent Successfully' (Android) or 'sent' (iOS)
} catch (error) {
  console.error(error);
}
```
### Demo 
```bash
git clone https://github.com/CodeERAayush/react-native-sms-turbo-demo
cd react-native-sms-turbo-demo
npm install
npm run android
```



## API Reference

### `SMSManager.sendSMS(phoneNumber: string, message: string): Promise<string>`

Sends an SMS to the specified phone number.

| Platform | Behavior |
|----------|----------|
| Android  | Sends directly in background. Requires `SEND_SMS` permission. |
| iOS      | Opens native message composer. User must tap Send. |

**Returns**: `'SMS Sent Successfully'` (Android), `'sent'`/`'cancelled'` (iOS)

---

### `SMSManager.isSMSAvailable(): Promise<boolean>`

Checks if the device can send SMS messages.

---

### `SMSManager.checkSMSPermission(): Promise<string>`

Returns the current SMS permission status.

| Platform | Returns |
|----------|---------|
| Android  | `'granted'` or `'denied'` |
| iOS      | Always `'granted'` |

---

### `SMSManager.requestSMSPermission(): Promise<string>`

Requests `SEND_SMS` permission from the user.

| Platform | Behavior |
|----------|----------|
| Android  | Shows system permission dialog |
| iOS      | No-op, returns `'granted'` |

## Requirements

- React Native >= 0.76.0 (New Architecture)
- Android: `minSdkVersion` 24+
- iOS: 13.4+

## License

MIT
