//
//  Color+Extention.swift
//  Ourry
//
//  Created by SeongHoon Jang on 2023/11/28.
//

import UIKit

//MARK: - Color Sets
extension UIColor {
    // Custom Colors
    static let backgroundColor              = UIColor(hexCode: "F9F9F9")
    static let blueShadowColor              = UIColor(hexCode: "C1D0FF")
    static let brandLogoColor               = UIColor(hexCode: "4667D1")
    static let buttonColor                  = UIColor(hexCode: "58B1F2")
    static let loginNextButtonColor         = UIColor(hexCode: "1780CD")
    static let surveyOptionBackroundColor   = UIColor(hexCode: "E5EFFE")
    static let voteResultColor              = UIColor(hexCode: "9AC8FF")
    
    // System Colors
    static let disabledButtonColor          = UIColor.systemGray3
    static let subTitleTextColor            = UIColor.systemGray6
}

//MARK: - Hex Color to CGColor(RGB)
extension UIColor {
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
