//
//  PlaneTextField.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/30.
//

import UIKit

class PlaneTextField: UITextField {

    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.autocapitalizationType = .none
        self.borderStyle = .roundedRect
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
