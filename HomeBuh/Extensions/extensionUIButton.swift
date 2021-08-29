//
//  extensionUIButton.swift
//  HomeBuh
//
//  Created by Алексей on 20.07.2021.
//

import UIKit

extension UIButton {
    func customButton(colorButton: UIColor, title: String, font: UIFont, colorTitle: UIColor, cornerRadius: CGFloat) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = colorButton
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(colorTitle, for: .normal)
        button.layer.cornerRadius = cornerRadius
        
        return button
    }
}
