//
//  UIBuilder.swift
//  Push It!
//
//  Created by Veikko Arvonen on 19.1.2026.
//

import UIKit

struct UIBuilder {
    
    func styleHeader(header: UILabel, text: String) {
        header.text = text
        header.textColor = .white
        header.textAlignment = .left
        header.font = UIFont(name: C.fonts.bold, size: 40.0)
    }
    
    func styleSubheader(header: UILabel, text: String) {
        header.text = text
        header.textColor = .white
        header.textAlignment = .left
        header.font = UIFont(name: C.fonts.bold, size: 15.0)
        header.backgroundColor = C.testUIwithBackgroundColor ? .black : .clear
    }
    
    func styleLabel(header: UILabel, text: String, fontSize: CGFloat, textColor: UIColor, alignment: NSTextAlignment) {
        header.text = text
        header.textColor = textColor
        header.textAlignment = .left
        header.font = UIFont(name: C.fonts.bold, size: fontSize)
        header.backgroundColor = .clear
    }
    
}
