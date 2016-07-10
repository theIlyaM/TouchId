# Touch Id Helper
==
The helper for working with Touch Id in iOS

How to add?
--------

You just need to add file TouchIdHelper.swift to your project.

How to use?
--------

To check that touch id is available on your device:

```swift
    var error: NSError? = nil
    if TouchIdHelper.canUseTouchId(&error) {
      // Is available
    } else {
      // Is not available with error
    }
```

Present touch id alert for authentication:

```swift
TouchIdHelper.presentTouchIdAlert("Reason title",
                                  fallbackTitle: "fallback button title",
                                  reply: { (result, error) in
                                    if result == true {
                                      // success
                                    } else {
                                      // failure
                                      // proccessError(error)
                                    }
            })
```

Present touch id alert for authentication without fallback button:

```swift
TouchIdHelper.presentTouchIdAlert("Reason title",
                                  reply: { (result, error) in
                                    if result == true {
                                      // success
                                    } else {
                                      // failure
                                      // proccessError(error)
                                    }
            })
```

Example how to process the errors returned by these calls:

```swift
func proccessError(error: NSError?)
{
    var message = "Other error"
      
    if let code = error?.code {
       switch code {
        case LAError.TouchIDNotAvailable.rawValue:
          message = "The device doesn't have a fingerprint sensor"
        case LAError.PasscodeNotSet.rawValue:
          message = "There is no passcode set on the device, which means that Touch ID is disabled"
        case LAError.SystemCancel.rawValue:
          message = "Some system event interrupted the evaluation (e.g. Home button pressed)."
        default:
          break
        }
    }
        
    print(message)
}
```

Typical error codes:

```swift
public enum LAError : Int {
    
    /// Authentication was not successful, because user failed to provide valid credentials.
    case AuthenticationFailed
    
    /// Authentication was canceled by user (e.g. tapped Cancel button).
    case UserCancel
    
    /// Authentication was canceled, because the user tapped the fallback button (Enter Password).
    case UserFallback
    
    /// Authentication was canceled by system (e.g. another application went to foreground).
    case SystemCancel
    
    /// Authentication could not start, because passcode is not set on the device.
    case PasscodeNotSet
    
    /// Authentication could not start, because Touch ID is not available on the device.
    case TouchIDNotAvailable
    
    /// Authentication could not start, because Touch ID has no enrolled fingers.
    case TouchIDNotEnrolled
    
    /// Authentication was not successful, because there were too many failed Touch ID attempts and
    /// Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating
    /// LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
    @available(iOS 9.0, *)
    case TouchIDLockout
    
    /// Authentication was canceled by application (e.g. invalidate was called while
    /// authentication was in progress).
    @available(iOS 9.0, *)
    case AppCancel
    
    /// LAContext passed to this call has been previously invalidated.
    @available(iOS 9.0, *)
    case InvalidContext
}
```
