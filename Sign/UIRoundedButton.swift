//
//  UIRoundedButton.swift
//  SignatureDemo
//
//  Created by Sharad Goyal on 21/08/18.
//  Copyright © 2018 Sharad Goyal. All rights reserved.
//

import UIKit

class UIRoundedButton: UIButton {
    
    /// UIRoundedButtonWithGradient
    let gradientColors : [UIColor]
    let startPoint : CGPoint
    let endPoint : CGPoint
    let configuration: Configuration
    
    required init(config: Configuration,
                  startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                  endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        
        self.gradientColors = config.gradientColors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.configuration = config
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width / 3, height: 50.0))
        setUpButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton() {
        layer.cornerRadius = configuration.btnCornerRadius
        
        setTitleColor(configuration.btnTitleColor, for: .normal)
        
        if configuration.enableGradiant {
            setGradientBackgroundColor(configuration.gradientColors, for: .normal)
        } else {
            setBackgroundColor(configuration.btnBackgroundColor, for: .normal)
            setBtnLayer()
        }
        
        if configuration.buttonPressEffectType == .invertColors {
            setTitleColor(configuration.btnBackgroundColor, for: .highlighted)
            setBackgroundColor(configuration.btnTitleColor, for: .highlighted)
        }
        
        clipsToBounds = true
        titleLabel?.numberOfLines = 0
    }
    
    private func setBtnLayer() {
        layer.borderColor = configuration.btnBorderColor.cgColor
        layer.borderWidth = configuration.btnBorderWidth
    }
    
    override var isHighlighted: Bool {
        didSet {
            if configuration.buttonPressEffectType == .bubble {
                
                let xScale : CGFloat = isHighlighted ? 1.025 : 1.0
                let yScale : CGFloat = isHighlighted ? 1.05 : 1.0
                UIView.animate(withDuration: 0.1) {
                    let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                    self.transform = transformation
                }
            }
        }
    }
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    private func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
    
    private func setGradientBackgroundColor(_ colors: [UIColor], for state: UIControlState) {
        self.setBackgroundImage(gradientImage(withColor: colors), for: state)
    }
    
    private func gradientImage(withColor color: [UIColor]) -> UIImage? {
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = color.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
