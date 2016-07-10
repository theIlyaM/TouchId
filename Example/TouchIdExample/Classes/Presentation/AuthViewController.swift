//
//  AuthViewController.swift
//  TouchIdExample
//
//  Created by Merkulov Ilya on 10.07.16.
//  Copyright © 2016 Merkulov Ilya. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {

    @IBOutlet var touchIdButton: UIButton!
    
    // MARK: - View Controller Life Circle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI()
    {
        touchIdButton.hidden = !TouchIdHelper.canUseTouchId(nil)
    }
    
    // MARK: - Action
    
    @IBAction func authWithTouchId()
    {
        TouchIdHelper.presentTouchIdAlert("Auth via Touch Id",
                                          fallbackTitle: "Manual input password",
                                          reply: { [weak self] (result, error) in
                                            if result == true {
                                                self?.finishAuth()
                                            } else {
                                                self?.processError(error)
                                            }
            })
    }
    
    // MARK: - Private
    
    private func finishAuth()
    {
        performSegueWithIdentifier("MainViewController", sender: self)
    }
    
    private func processError(error: NSError?)
    {
        var message = "Other error"
        
        if let code = error?.code {
            switch code {
            case LAError.TouchIDNotAvailable.rawValue:
                message = "The device doesn't have a fingerprint sensor"
            case LAError.PasscodeNotSet.rawValue:
                message = "There is no passcode set on the device, which means that Touch ID is disabled"
            case LAError.TouchIDNotEnrolled.rawValue:
                message = "There is a passcode set but the device has not been configured with any fingerprints"
            case LAError.UserFallback.rawValue:
                message = "User tapped the fallback button"
            case LAError.UserCancel.rawValue:
                message = "User has tapped the Cancel button"
            case LAError.SystemCancel.rawValue:
                message = "Some system event interrupted the evaluation (e.g. Home button pressed)."
            default:
                break
            }
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}

