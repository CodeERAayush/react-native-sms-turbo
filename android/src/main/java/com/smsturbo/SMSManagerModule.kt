package com.smsturbo

import android.content.pm.PackageManager
import android.telephony.SmsManager
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = SMSManagerModule.NAME)
class SMSManagerModule(reactContext: ReactApplicationContext) : NativeSMSManagerSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun sendSMS(phoneNumber: String, message: String, promise: Promise) {
    if (ContextCompat.checkSelfPermission(reactApplicationContext, android.Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
      promise.reject("SMS_PERMISSION_DENIED", "Send SMS permission not granted")
      return
    }

    try {
      val smsManager: SmsManager = reactApplicationContext.getSystemService(SmsManager::class.java)
        ?: @Suppress("DEPRECATION") SmsManager.getDefault()
      val parts = smsManager.divideMessage(message)
      if (parts.size > 1) {
        smsManager.sendMultipartTextMessage(phoneNumber, null, parts, null, null)
      } else {
        smsManager.sendTextMessage(phoneNumber, null, message, null, null)
      }
      promise.resolve("SMS Sent Successfully")
    } catch (e: Exception) {
      promise.reject("SMS_SEND_ERROR", "Failed to send SMS: ${e.message}")
    }
  }

  override fun isSMSAvailable(promise: Promise) {
    val pm = reactApplicationContext.packageManager
    val hasFeature = pm.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)
    promise.resolve(hasFeature)
  }

  override fun checkSMSPermission(promise: Promise) {
    val status = ContextCompat.checkSelfPermission(reactApplicationContext, android.Manifest.permission.SEND_SMS)
    if (status == PackageManager.PERMISSION_GRANTED) {
      promise.resolve("granted")
    } else {
      promise.resolve("denied")
    }
  }

  override fun requestSMSPermission(promise: Promise) {
    val currentActivity = reactApplicationContext.currentActivity
    if (currentActivity == null) {
      promise.reject("NO_ACTIVITY", "Current activity is null, cannot request permission")
      return
    }

    currentActivity.requestPermissions(arrayOf(android.Manifest.permission.SEND_SMS), 1)
    promise.resolve("requested")
  }

  companion object {
    const val NAME = "SMSManager"
  }
}
