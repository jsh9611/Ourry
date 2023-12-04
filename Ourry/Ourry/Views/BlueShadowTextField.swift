//
//  BlueShadowTextField.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/30.
//

import UIKit

class BlueShadowTextField: UITextField {

    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.blueShadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
