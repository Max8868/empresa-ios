//
//  DesingClasses.swift
//  empresas-ios
//
//  Created by Taciano Maximo on 23/06/21.
//

import Foundation
import UIKit

class PaddingTxtFld: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITextField {
    
    enum Direction {
        case left
        case right
    }
    
    func addIcon(direction: Direction, imageName: String?, isSystemName: Bool, frame: CGRect, backgroundColor: UIColor) {
        
        let View = UIView(frame: frame)
        
        View.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: frame)
        
        if let imgName = imageName {
            
            if isSystemName {
                imageView.image = UIImage(systemName: imgName)
            }
            else {
                imageView.image = UIImage(named: imgName)
            }
            
           
            View.addSubview(imageView)
        } else {
            imageView.image = UIImage()
            View.addSubview(imageView)
        }
        
        if Direction.left == direction {
            self.leftViewMode = .always
            self.leftView = View
        }
        else {
            self.rightViewMode = .always
            self.rightView = View
        }
        
    }
    
}
struct SetNewConstraint {
    static func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem!,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant)
        
        newConstraint.priority = constraint.priority
        
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
