//
//  SigConfiguration.swift
//  SignatureDemo
//
//  Created by Sharad Goyal on 21/08/18.
//  Copyright © 2018 Sharad Goyal. All rights reserved.
//

import Foundation
import UIKit

@objc public class Configuration: NSObject {
    /// label placeholder text
    @objc public var placeholderText: String
    
    /// reset button title
    @objc public var resetBtnTitle: String
    
    /// resize button title
    @objc public var resizeBtnTitle: String
    
    /// done button title
    @objc public var doneBtnTitle: String
    
    /// buttons background color
    @objc public var btnBackgroundColor: UIColor {
        didSet {
            btnBackgroundColor = gradientColors.first ?? UIColor.black
        }
    }
    
    /// buttons title color
    @objc public var btnTitleColor: UIColor
    
    /// to specify signature color
    @objc public var signatureColor: UIColor
    
    /// to specify signature line width
    @objc public var signatureWidth: CGFloat
    
    /// label text color
    @objc public var labelTextColor: UIColor
    
    /// label and button font name
    @objc public var fontName: String
    
    /// to draw rounded button
    @objc public var showRounded: Bool
    
    /// to enable Gradiant Color
    @objc public var enableGradiant: Bool
    
    /// array of gradient colors
    @objc public var gradientColors: [UIColor]
    
    /// gradient color direction
    @objc public var gradientDirection: GradientDirection
    
    /// UIButton press effect type
    @objc public var buttonPressEffectType: PressEffectType
    
    /// UIButton border color
    public var btnBorderColor: UIColor
    
    /// UIButton corner radius
    @objc public var btnCornerRadius: CGFloat
    
    /// UIButton border width
    @objc public var btnBorderWidth: CGFloat
    
    /// Signature View background color
    @objc public var viewBGColor: UIColor
    
    /// view alpha range 0.0 - 1.0
    /// 1.0 means opaque, 0.0 - 0.9 means transparency level
    @objc public var viewAlpha: CGFloat
    
    override public init() {
        
        placeholderText = "Sign Here"
        resetBtnTitle = "Reset"
        resizeBtnTitle = "Resize"
        doneBtnTitle = "Done"
        btnBackgroundColor = UIColor.black
        btnTitleColor = UIColor.white
        signatureColor = UIColor.black
        signatureWidth = 2.0
        labelTextColor = UIColor.lightGray
        fontName = "Verdana"
        showRounded = false
        enableGradiant = false
        gradientColors = [UIColor.black, UIColor.white]
        gradientDirection = .leftRight
        buttonPressEffectType = .invertColors
        btnBorderColor = btnBackgroundColor
        btnCornerRadius = 10
        btnBorderWidth = 1
        viewBGColor = UIColor.gray
        viewAlpha = 0.8
        
        super.init()
    }
    
}
