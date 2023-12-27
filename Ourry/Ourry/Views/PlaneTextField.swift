//
//  PlaneTextField.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/30.
//

import UIKit

class PlaneTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        let wasFirstResponder = isFirstResponder
        let success = super.becomeFirstResponder()
        if !wasFirstResponder, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }

    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.textContentType = .oneTimeCode
        self.borderStyle = .roundedRect
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
