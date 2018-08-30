//
//  SignatureView.swift
//  SideMenuDemo
//
//  Created by Sharad Goyal on 13/08/18.
//  Copyright © 2018 Sharad Goyal. All rights reserved.
//

import UIKit

enum SignatureStatus {
    case done
    case inProgress
}

@objc public class SignatureView: UIView {
    
    private var imageHandler: ((_ response: UIImage?) -> Void)?
    // signature view
    private var config: Configuration!
    
    /// to add wrapper view on window
    private let wrapperView = UIView()
    
    /// to add Reset, Resize and Done buttons at bottom
    private let stackView = UIStackView()
    
    /// to show a UILabel stating "sign here"
    private var signatureLabel: UILabel?
    
    /// flag to identify the signature state
    private var signatureStatus: SignatureStatus = .inProgress
    
    private var bezierPath: UIBezierPath?
    private var points = [CGPoint](repeating: CGPoint.zero, count: 5)
    private var control: Int = 0
    private var shapeLayer: CAShapeLayer?
    private var sigImage: UIImage?
    
    // to resize and move the view
    private var isResizingLR = false
    private var isResizingUL = false
    private var isResizingUR = false
    private var isResizingLL = false
    
    private var touchStart: CGPoint = CGPoint.zero
    private let kResizeThumbSize: CGFloat = 25
    
    // Create a View which contains Signature Label
    
    @objc public required init(config: Configuration, completionHandler: @escaping ((_ response: UIImage?) -> Void)) {
        self.config = config
        self.imageHandler = completionHandler
        super.init(frame: .zero)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if signatureLabel?.superview != nil {
            signatureLabel?.translatesAutoresizingMaskIntoConstraints = false
            signatureLabel?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
            signatureLabel?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
            signatureLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
            signatureLabel?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        }
        
        signatureLabel?.text = config.placeholderText
        signatureLabel?.textColor = config.labelTextColor
        
        bezierPath?.lineWidth = config.signatureWidth
        
        sigImage?.draw(in: rect)
        bezierPath?.stroke()
        
        // Set initial color for drawing
        config.signatureColor.setFill()
        config.signatureColor.setStroke()
        bezierPath?.stroke()
    }
    
    // MARK: - UIView Touch Methods
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        switch signatureStatus {
        case .done:
            handleTouchesBeganForResizeAndMove(touches: touches, event: event)
        default:
            handleTouchesBeganForSignature(touches: touches, event: event)
        }
        
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        switch signatureStatus {
        case .done:
            handleTouchesMovedForResizeAndMove(touches: touches, event: event)
        default:
            handleTouchesMovedForSignature(touches: touches, event: event)
        }
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if signatureStatus == .inProgress {
            drawBitmapImage()
            setNeedsDisplay()
            bezierPath?.removeAllPoints()
            control = 0
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK :- Private Methods to handle touch events
    /// handles touchBegan event during Resize
    private func handleTouchesBeganForResizeAndMove(touches: Set<UITouch>, event: UIEvent?) {
        self.touchStart = touches.first!.location(in: self)
        self.isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize)
        self.isResizingUL = (touchStart.x < kResizeThumbSize && touchStart.y < kResizeThumbSize)
        self.isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y < kResizeThumbSize)
        self.isResizingLL = (touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize)
    }
    
    /// handles touchMoved event during Resize
    private func handleTouchesMovedForResizeAndMove(touches: Set<UITouch>, event: UIEvent?) {
        let touchPoint = touches.first!.location(in: self)
        let previous = touches.first!.previousLocation(in: self)
        
        let deltaWidth =  previous.x - touchPoint.x
        let deltaHeight = previous.y - touchPoint.y
        
        let x = self.frame.origin.x;
        let y = self.frame.origin.y;
        let width = self.frame.size.width;
        let height = self.frame.size.height;
        
        let originFrame = self.frame
        var finalFrame: CGRect = originFrame
        
        if (isResizingLR) {
            
            let distance = CGPoint(x: 1.0 - (deltaWidth / width),
                                   y: 1.0 - (deltaHeight / height))
            
            let scale = (distance.x + distance.y) * 0.5
            
            finalFrame.size.width = width * scale
            finalFrame.size.height = height * scale
            
        } else if (isResizingUL) {
            let distance = CGPoint(x: 1.0 - (-deltaWidth / width),
                                   y: 1.0 - (-deltaHeight / height))
            
            let scale = (distance.x + distance.y) * 0.5
            
            finalFrame.size.width = width * scale
            finalFrame.size.height = height * scale
            finalFrame.origin.x = x + width - finalFrame.size.width;
            finalFrame.origin.y = y + height - finalFrame.size.height;
        } else if (isResizingUR) {
            let distance = CGPoint(x: 1.0 - (deltaWidth / width),
                                   y: 1.0 - (-deltaHeight / height))
            
            let scale = (distance.x + distance.y) * 0.5
            
            finalFrame.size.width = width * scale
            finalFrame.size.height = height * scale
            finalFrame.origin.y = y + height - finalFrame.size.height
        } else if (isResizingLL) {
            let distance = CGPoint(x: 1.0 - (-deltaWidth / width),
                                   y: 1.0 - (deltaHeight / height))
            
            let scale = (distance.x + distance.y) * 0.5
            
            finalFrame.size.width = width * scale
            finalFrame.size.height = height * scale
            finalFrame.origin.x = originFrame.maxX - finalFrame.size.width
        } else {
            // not dragging from a corner -- move the view
            let newCenter = CGPoint(x: self.center.x + touchPoint.x - touchStart.x,
                                    y: self.center.y + touchPoint.y - touchStart.y)
            
            if (newCenter.x + self.bounds.midX <= self.superview!.bounds.maxX && newCenter.x - self.bounds.midX >= self.superview!.bounds.minX && newCenter.y + self.bounds.midY <= self.superview!.bounds.maxY && newCenter.y - self.bounds.midY >= self.superview!.bounds.minY)
            {
                self.center = newCenter
            }
            return;
        }
        
        if (finalFrame.maxX <= self.superview!.bounds.maxX && finalFrame.minX >= self.superview!.bounds.minX && finalFrame.maxY <= self.superview!.bounds.maxY && finalFrame.minY >= self.superview!.bounds.minY) {
            self.frame = finalFrame
        }
    }
    
    /// handles touchMoved event during Signature
    private func handleTouchesMovedForSignature(touches: Set<UITouch>, event: UIEvent?) {
        let touch = touches.first
        let touchPoint: CGPoint? = touch?.location(in: self)
        control += 1
        if let touchPoint = touchPoint {
            points[control] = touchPoint
            if control == 4 {
                points[3] = CGPoint(x: (points[2].x + points[4].x) / 2.0, y: (points[2].y + points[4].y) / 2.0)
                bezierPath?.move(to: points[0])
                bezierPath?.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
                setNeedsDisplay()
                points[0] = points[3]
                points[1] = points[4]
                control = 1
            }
        }
    }
    
    /// handles touchBegan event during Signature
    private func handleTouchesBeganForSignature(touches: Set<UITouch>, event: UIEvent?) {
        if ((signatureLabel?.superview) != nil) {
            signatureLabel?.removeFromSuperview()
        }
        control = 0
        let touch = touches.first
        if let point = touch?.location(in: self) {
            points[0] = point
            let startPoint: CGPoint = points[0]
            let endPoint = CGPoint(x: startPoint.x + 1.5, y: startPoint.y + 2)
            bezierPath?.move(to: startPoint)
            bezierPath?.addLine(to: endPoint)
        }
    }
    
    // MARK:- Private methods
    
    /// Bitmap Image Creation
    private func drawBitmapImage() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        
        if sigImage == nil {
            let rectpath = UIBezierPath(rect: bounds)
            backgroundColor?.setFill()
            rectpath.fill()
        }
        sigImage?.draw(at: CGPoint.zero)
        //Set final color for drawing
        
        config.signatureColor.setStroke()
        bezierPath?.stroke()
        sigImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    /// to setUp elements for view
    private func setUpView() {
        isMultipleTouchEnabled = false
        frame = CGRect.init(x: 20, y: 50, width: UIScreen.main.bounds.size.width - 40, height: 160)
        backgroundColor = UIColor.white
        
        addWrapperView()
        
        bezierPath = UIBezierPath()
        
        signatureLabel = UILabel()
        
        if let label = signatureLabel {
            label.numberOfLines = 0
            label.font = UIFont(name: config.fontName, size: 60)
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.1
            label.alpha = 0.3
            addSubview(label)
        }
    }
    
    /// to add wrapper view on window
    private func addWrapperView() {
        let window = UIApplication.shared.windows.first
        
        wrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        wrapperView.backgroundColor = config.viewBGColor
        wrapperView.alpha = config.viewAlpha
        if let frame = window?.frame {
            wrapperView.frame = frame
        }
        
        window?.addSubview(wrapperView)
        wrapperView.addSubview(self)
        
        addBottomStackView()
        
    }
    
    /// to add stack view at bottom which contains buttons to take action on signature view
    private func addBottomStackView() {
        stackView.backgroundColor = UIColor.clear
        
        wrapperView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: 0).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        stackView.axis = .horizontal
        
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        addResetButton()
        addResizeButton()
        addDoneButton()
    }
    
    /// to reset the signature view and removes the signature
    private func addResetButton() {
        
        let btnReset = getUIButton()
        
        btnReset.setTitle(config.resetBtnTitle, for: .normal)
        btnReset.addTarget(self, action: #selector(clickedBtnReset), for: .touchUpInside)
        
        stackView.addArrangedSubview(btnReset)
        
    }
    
    /// to resize and move signature view
    private func addResizeButton() {
        
        let btnResize = getUIButton()
        
        btnResize.setTitle(config.resizeBtnTitle, for: .normal)
        btnResize.addTarget(self, action: #selector(clickedBtnResize), for: .touchUpInside)
        
        stackView.addArrangedSubview(btnResize)
    }
    
    /// to return signature image and return to caller
    private func addDoneButton() {
        
        let btnDone = getUIButton()
        btnDone.setTitle(config.doneBtnTitle, for: .normal)
        btnDone.addTarget(self, action: #selector(clickedBtnDone), for: .touchUpInside)
        
        stackView.addArrangedSubview(btnDone)
    }
    
    private func getUIButton() -> UIRoundedButton {
        let point = getGradientDirectionPoints(direction: config.gradientDirection)
        
        return UIRoundedButton.init(config: config, startPoint: point.x, endPoint: point.y)
    }
    
    @objc private func clickedBtnReset() {
        clearSignature()
    }
    
    @objc private func clickedBtnResize() {
        signatureStatus = .done
    }
    
    @objc private func clickedBtnDone() {
        imageHandler?(getSignatureImage())
        
        self.removeFromSuperview()
        wrapperView.removeFromSuperview()
    }
    
    // MARK:- Methods accessible within module
    private func clearSignature() {
        sigImage = nil
        signatureStatus = .inProgress
        if let label = signatureLabel {
            addSubview(label)
        }
        setNeedsDisplay()
    }
    
    private func getSignatureImage() -> UIImage? {
        if ((signatureLabel?.superview) != nil) {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let signatureImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return signatureImage
    }
    
    private func getGradientDirectionPoints(direction: GradientDirection) -> (x: CGPoint, y: CGPoint) {
        switch direction {
        case .leftRight:
            return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return (x: CGPoint(x: 0.5, y: 0), y: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
        }
    }
    
}
