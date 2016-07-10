//
//  TouchIdHelper.swift
//  
//
//  Created by Merkulov Ilya on 10.07.16.
//  Copyright © 2016 BadassCoding LLC. All rights reserved.
//

import Foundation
import LocalAuthentication.LAContext

class TouchIdHelper {

    /// Determines if a particular policy can be evaluated.
    ///
    /// @param error Output parameter which is set to nil if the policy can be evaluated, or it
    ///              contains error information if policy evaluation is not possible.
    /// Typical error codes returned by this call are
    /// @li          LAErrorTouchIDNotAvailable if the device doesn't have a fingerprint sensor.
    /// @li          LAErrorPasscodeNotSet if there is no passcode set on the device, which means that Touch ID is disabled.
    /// @li          LAErrorTouchIDNotEnrolled if there is a passcode set but the device has not been configured with any fingerprints.
    ///
    /// @return YES if the policy can be evaluated, NO otherwise.
    
    class func canUseTouchId(error: NSErrorPointer) -> Bool
    {
        return LAContext().canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics,
                                             error: error)
    }
    
    /// Present touch id alert.
    ///
    /// @param reason           Application reason for authentication. This string must be provided in correct
    ///                         localization and should be short and clear. It will be eventually displayed in
    ///                         the authentication dialog subtitle. A name of the calling application will be
    ///                         already displayed in title, so it should not be duplicated here.
    ///
    /// @param fallbackTitle    Fallback button title. Allows fallback button title customization. A default title
    ///                         "Enter Password" is used when
    ///                         this property is left nil. If set to empty string, the button will be hidden.
    ///
    /// @param reply            Reply block that is executed when policy evaluation finishes.
    ///
    /// @param success          Reply parameter that is YES if the policy has been evaluated successfully or NO if
    ///                         the evaluation failed.
    ///
    /// @param error            Reply parameter that is nil if the policy has been evaluated successfully, or it contains
    ///                         error information about the evaluation failure.
    /// @see LAError
    ///
    /// Typical error codes returned by this call are:
    /// @li          LAErrorUserFallback if user tapped the fallback button
    /// @li          LAErrorUserCancel if user has tapped the Cancel button
    /// @li          LAErrorSystemCancel if some system event interrupted the evaluation (e.g. Home button pressed).

    class func presentTouchIdAlert(reason: String,
                                   fallbackTitle: String?,
                                   reply: (Bool, NSError?) -> Void)
    {
        let context = LAContext()
        context.localizedFallbackTitle = fallbackTitle
        let error: NSErrorPointer = nil
        if (!TouchIdHelper.canUseTouchId(error)) {
            reply(false, error.memory)
        } else {
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                dispatch_async(dispatch_get_main_queue()) {
                    reply(success, error)
                }
            }
        }
    }
    
    /// Present touch id alert without fallback button
    ///
    /// @param reason           Application reason for authentication. This string must be provided in correct
    ///                         localization and should be short and clear. It will be eventually displayed in
    ///                         the authentication dialog subtitle. A name of the calling application will be
    ///                         already displayed in title, so it should not be duplicated here.
    ///
    /// @param reply            Reply block that is executed when policy evaluation finishes.
    ///
    /// @param success          Reply parameter that is YES if the policy has been evaluated successfully or NO if
    ///                         the evaluation failed.
    ///
    /// @param error            Reply parameter that is nil if the policy has been evaluated successfully, or it contains
    ///                         error information about the evaluation failure.
    /// @see LAError
    ///
    /// Typical error codes returned by this call are:
    /// @li          LAErrorUserFallback if user tapped the fallback button
    /// @li          LAErrorUserCancel if user has tapped the Cancel button
    /// @li          LAErrorSystemCancel if some system event interrupted the evaluation (e.g. Home button pressed).
    
    class func presentTouchIdAlert(reason: String,
                                   reply: (Bool, NSError?) -> Void)
    {
        TouchIdHelper.presentTouchIdAlert(reason,
                                          fallbackTitle: "",
                                          reply: reply)
    }
}