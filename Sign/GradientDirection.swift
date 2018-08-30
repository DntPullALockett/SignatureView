//
//  GradientDirection.swift
//  Sign
//
//  Created by Sharad Goyal on 24/08/18.
//  Copyright © 2018 Sharad Goyal. All rights reserved.
//

import Foundation

@objc public enum GradientDirection: Int {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    
}

@objc public enum PressEffectType: Int {
    case bubble
    case invertColors
}


