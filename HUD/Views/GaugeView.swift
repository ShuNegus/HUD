//
//  GaugeView.swift
//  HUD
//
//  Created by Konstantin on 23.12.2020.
//  Copyright © 2020 Konstantin Kuznetsov. All rights reserved.
//

import UIKit
import CoreGraphics

class GaugeView: UIView {
    
    var outerBezelColor = UIColor.white
    var outerBezelWidth: CGFloat = 10
    
    var innerBezelColor = UIColor.white
    var innerBezelWidth: CGFloat = 5
    
    var insideColor = UIColor.black
    
    var segmentWidth: CGFloat = 20
    var segmentColors = [UIColor(red: 0.7, green: 0, blue: 0, alpha: 1), UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(red: 0.7, green: 0, blue: 0, alpha: 1)]
    
    var totalAngle: CGFloat = 270
    var rotation: CGFloat = -135
    
    var majorTickColor = UIColor.white
    var majorTickWidth: CGFloat = 2
    var majorTickLength: CGFloat = 25

    var minorTickColor = UIColor.white
    var minorTickWidth: CGFloat = 1
    var minorTickLength: CGFloat = 20
    var minorTickCount = 9
    
    var outerCenterDiscColor = UIColor(white: 0.9, alpha: 1)
    var outerCenterDiscWidth: CGFloat = 35
    var innerCenterDiscColor = UIColor(white: 0.7, alpha: 1)
    var innerCenterDiscWidth: CGFloat = 25
    
    var needleColor = UIColor(white: 0.7, alpha: 1)
    var needleWidth: CGFloat = 4
    let needle = UIView()
    
    let valueLabel = UILabel()
    var valueFont = UIFont.systemFont(ofSize: 56)
    var valueColor = UIColor.white
    
    let unitsLabel = UILabel()
    var unitsFont = UIFont.systemFont(ofSize: 30)
    var unitsColor = UIColor.white
    
    var value: Double = 0 {
        didSet {
            // update the value label to show the exact number
            valueLabel.text = String(value)
            unitsLabel.text = "KM/H"

            // figure out where the needle is, between 0 and 1
            let needlePosition = CGFloat(value) / 250

            // create a lerp from the start angle (rotation) through to the end angle (rotation + totalAngle)
            let lerpFrom = rotation
            let lerpTo = rotation + totalAngle

            // lerp from the start to the end position, based on the needle's position
            let needleRotation = lerpFrom + (lerpTo - lerpFrom) * needlePosition
            needle.transform = CGAffineTransform(rotationAngle: deg2rad(needleRotation))
        }
    }
    
    func setUp() {
        needle.backgroundColor = needleColor
        needle.translatesAutoresizingMaskIntoConstraints = false

        needle.bounds = CGRect(x: 0, y: 0, width: needleWidth, height: bounds.height / 3)

        needle.layer.anchorPoint = CGPoint(x: 0.5, y: 1)

        needle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        valueLabel.font = valueFont
        valueLabel.textColor = valueColor
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        unitsLabel.font = unitsFont
        unitsLabel.textColor = unitsColor
        unitsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(valueLabel)
        addSubview(unitsLabel)

        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            unitsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            unitsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        addSubview(needle)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        drawBackground(in: rect, context: ctx)
        //drawSegments(in: rect, context: ctx)
        drawTicks(in: rect, context: ctx)
        drawCenterDisc(in: rect, context: ctx)

    }
    
    func drawBackground(in rect: CGRect, context ctx: CGContext){
        outerBezelColor.set()
        ctx.fillEllipse(in: rect)
        
        let innerBezelRect = rect.insetBy(dx: outerBezelWidth, dy: outerBezelWidth)
        ctx.fillEllipse(in: innerBezelRect)
        
        let insideRect = innerBezelRect.insetBy(dx: innerBezelWidth, dy: innerBezelWidth)
        insideColor.set()
        ctx.fillEllipse(in: insideRect)
    }
    
    func deg2rad(_ number: CGFloat) -> CGFloat{
        return number * .pi / 180
    }
    
    func drawTicks(in rect: CGRect, context ctx: CGContext){
        
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: deg2rad(rotation) - (.pi/2))
        
        let segmentAngle = deg2rad(totalAngle / CGFloat(segmentColors.count))
        
        let segmentRadius = (((rect.width - segmentWidth) / 2) - outerBezelWidth) - innerBezelWidth
        
        ctx.saveGState()
        
        ctx.setLineWidth(majorTickWidth)
        majorTickColor.set()
        let majorEnd = segmentRadius + (segmentWidth / 2)
        let majorStart = majorEnd - majorTickLength
        
        for _ in 0 ... segmentColors.count {
            ctx.move(to: CGPoint(x: majorStart, y: 0))
            ctx.addLine(to: CGPoint(x: majorEnd, y: 0))
            ctx.drawPath(using: .stroke)
            ctx.rotate(by: segmentAngle)
        }
        
        ctx.restoreGState()
        
        ctx.saveGState()
        
        ctx.setLineWidth(minorTickWidth)
        minorTickColor.set()

        let minorEnd = segmentRadius + (segmentWidth / 2)
        let minorStart = minorEnd - minorTickLength
        let minorTickSize = segmentAngle / CGFloat(minorTickCount + 1)
        
        for _ in 0 ..< segmentColors.count {
            ctx.rotate(by: minorTickSize)

            for _ in 0 ..< minorTickCount {
                ctx.move(to: CGPoint(x: minorStart, y: 0))
                ctx.addLine(to: CGPoint(x: minorEnd, y: 0))
                ctx.drawPath(using: .stroke)
                ctx.rotate(by: minorTickSize)
            }
        }
        
        ctx.restoreGState()

            // go back to the original graphics state
        ctx.restoreGState()
    }
    
    func drawCenterDisc(in rect: CGRect, context ctx: CGContext) {
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)

        let outerCenterRect = CGRect(x: -outerCenterDiscWidth / 2, y: -outerCenterDiscWidth / 2, width: outerCenterDiscWidth, height: outerCenterDiscWidth)
        outerCenterDiscColor.set()
        ctx.fillEllipse(in: outerCenterRect)

        let innerCenterRect = CGRect(x: -innerCenterDiscWidth / 2, y: -innerCenterDiscWidth / 2, width: innerCenterDiscWidth, height: innerCenterDiscWidth)
        innerCenterDiscColor.set()
        ctx.fillEllipse(in: innerCenterRect)
        ctx.restoreGState()
    }
    
    
}
