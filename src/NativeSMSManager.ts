import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  /**
   * Sends an SMS to the specified phone number with the given message.
   * On Android, this sends directly in the background (needs SEND_SMS permission).
   * On iOS, this opens the native MFMessageComposeViewController.
   */
  sendSMS(phoneNumber: string, message: string): Promise<string>;

  /**
   * Checks if the device is capable of sending SMS.
   */
  isSMSAvailable(): Promise<boolean>;

  /**
   * Requests SEND_SMS permission (Android only).
   * Returns 'granted', 'denied', or 'unavailable'.
   * On iOS, always returns 'granted'.
   */
  requestSMSPermission(): Promise<string>;

  /**
   * Checks SEND_SMS permission status (Android only).
   * On iOS, always returns 'granted'.
   */
  checkSMSPermission(): Promise<string>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('SMSManager');
