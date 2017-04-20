//
//  View.swift
//  Novar
//
//  Created by Everton Luiz Pascke on 13/01/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import UIKit

@IBDesignable
class View: UIView {

    @IBInspectable var borderColor: UIColor!
    @IBInspectable var borderBottomWidth: CGFloat = 1.0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let context = UIGraphicsGetCurrentContext() {
            if borderColor == nil {
                borderColor = tintColor
            }
            context.setLineWidth(borderBottomWidth)
            context.setStrokeColor(borderColor.cgColor)
            context.move(to: CGPoint(x: 0, y: frame.height - borderBottomWidth))
            context.addLine(to: CGPoint(x: frame.width, y: frame.height - borderBottomWidth))
            context.strokePath()
        }
    }
}
