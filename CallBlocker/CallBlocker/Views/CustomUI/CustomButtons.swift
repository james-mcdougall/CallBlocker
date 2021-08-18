//
//  CustomButtons.swift
//  CallBlocker
//
//  Created by James McDougall on 8/17/21.
//

import UIKit

struct CustomButtons {
    
    func dullRedHollowButton(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.layer.backgroundColor = UIColor(named: "DullRed")?.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func dullRedCircleButton(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "DullRed")?.cgColor ?? UIColor.white.cgColor
    }
    
}
