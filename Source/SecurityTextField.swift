//
//  SecurityTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 01/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

public protocol SecurityTextFieldDelegate {
    func securityTextFieldDidEnterCode(textField: SecurityTextField, isValid: Bool)
}

public class SecurityTextField: JudoPayInputField {
    
    public var cardNetwork: CardNetwork = .Unknown
    
    public var delegate: SecurityTextFieldDelegate?
    
    override func setupView() {
        super.setupView()
        self.titleLabel.text = self.cardNetwork.securityCodeTitle()
    }

    // MARK: UITextFieldDelegate Methods
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // only handle delegate calls for own textfield
        guard textField == self.textField else { return true }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        self.delegate?.securityTextFieldDidEnterCode(self, isValid: newString.characters.count == self.cardNetwork.securityCodeLength())
        
        return newString.isNumeric() && newString.characters.count <= self.cardNetwork.securityCodeLength()
    }

    // MARK: Custom methods

    override func containsLogo() -> Bool {
        return true
    }
    
    override func logoView() -> CardLogoView? {
        let type: CardLogoType = self.cardNetwork == .AMEX ? .CIDV : .CVC
        return CardLogoView(type: type)
    }

}
