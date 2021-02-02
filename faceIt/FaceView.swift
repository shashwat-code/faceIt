//
//  FaceView.swift
//  faceIt
//
//  Created by Shashwat on 01/02/21.
//

import UIKit

class FaceView: UIView {
    
    var scaleRadius:CGFloat = 0.9
    var skullRadius:CGFloat {
        min(bounds.size.width, bounds.size.height)/2 * scaleRadius
    }
    
    var skullCenter:CGPoint {
        CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye{
        case Left
        case Right
    }
    
    private func pathForCircle(midPoint:CGPoint,withRadius radius:CGFloat)->UIBezierPath{
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2*Double.pi),
            clockwise: true
        )
        path.lineWidth = 3.0
        return path
    }
    
    private func getEyeCenter(eye: Eye)->CGPoint{
        let eyeOffset = skullRadius/Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye{
        case .Left:
            eyeCenter.x-=eyeOffset
        case .Right:
            eyeCenter.x+=eyeOffset
        }
        return eyeCenter
    }
    
    private struct Ratios{
        static let SkullRadiusToEyeOffset:CGFloat = 3
        static let SkullRadiusToEyeRadius:CGFloat = 10
        static let SkullRadiusToMouthWidth:CGFloat = 1
        static let SkullRadiusToMouthHeight:CGFloat = 3
        static let SkullRadiusToMouthOffset:CGFloat = 3
    }
    var curvature = 0.3
    private func mouthPath()->UIBezierPath{
       
        let mouthWidth = skullRadius/Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius/Ratios.SkullRadiusToMouthHeight
        let smileOffSet = CGFloat(max(-1,min(curvature,1)))*mouthHeight
        let path = CGRect(x: skullCenter.x - mouthWidth/2,
                          y: skullCenter.y + mouthHeight,
                          width: mouthWidth,
                          height: mouthHeight
        )
        let start = CGPoint(x: path.minX, y: path.minY)
        let end = CGPoint(x: path.maxX, y: path.minY)
        let cp1 = CGPoint(x: path.minX+path.width/3, y: path.minY+smileOffSet)
        let cp2 = CGPoint(x: path.maxX-path.width/3, y: path.minY+smileOffSet)
        let path1 = UIBezierPath()
        path1.move(to: start)
        path1.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        return path1
        //return UIBezierPath(rect: path)
    }
    
    private func eyeCircle(eye:Eye)->UIBezierPath{
        let eyeRadius = skullRadius/Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        return pathForCircle(midPoint: eyeCenter, withRadius: eyeRadius)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.yellow.set()
        pathForCircle(midPoint: skullCenter, withRadius: skullRadius).fill()
        UIColor.black.set()
        eyeCircle(eye: .Left).fill()
        eyeCircle(eye: .Right).fill()
        mouthPath().stroke()
        
        
    }
    
    
}
