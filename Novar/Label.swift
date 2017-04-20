//
//  Label.swift
//  LiveViewDemo
//
//  Created by Everton Luiz Pascke on 10/01/17.
//  Copyright © 2017 Everton Luiz Pascke. All rights reserved.
//

import UIKit

@IBDesignable
class Label: UILabel {

    @IBInspectable var borderColor: UIColor!
    @IBInspectable var borderWidth: CGFloat = 2.0
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let context = UIGraphicsGetCurrentContext() {
            if borderColor == nil {
                borderColor = textColor
            }
            context.setLineWidth(borderWidth)
            context.setStrokeColor(borderColor.cgColor)
            context.move(to: CGPoint(x: 0, y: frame.height - borderWidth))
            context.addLine(to: CGPoint(x: frame.width, y: frame.height - borderWidth))
            context.strokePath()
        }
    }
}
