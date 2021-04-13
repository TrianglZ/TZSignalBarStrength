//
//  FillView.swift
//  SignalBarStrength
//
//  Created by Rana Hossam on 11/04/2021.
//

import UIKit

class FillView: UIView {
    
    let shapeLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    var rectanglePath = UIBezierPath()
    
    private func configureView(with color: UIColor) {
        backgroundColor = UIColor.clear
//        initial shape of the view
   
        rectanglePath = UIBezierPath(rect: CGRect(x: self.bounds.minX,
                                                  y: self.bounds.maxY,
                                                  width: self.bounds.width,
                                                  height: 0))
        // Create initial shape of the view
        shapeLayer.path = rectanglePath.cgPath
        shapeLayer.fillColor = color.cgColor
        //        shapeLayer.fillColor = UIColor.black.cgColor
        layer.addSublayer(shapeLayer)
        //mask layer
        maskLayer.path = shapeLayer.path
        maskLayer.position =  shapeLayer.position
        layer.mask = maskLayer
    }
    
    //
    func animate(with duration: CFTimeInterval, radius cornerRadius: CGFloat, and color: UIColor) {
        configureView(with: color)
        //
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        
        // Your new shape here
        animation.toValue = UIBezierPath.init(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        //        animation.toValue = UIBezierPath.init(rect: bounds).cgPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        // The next two line preserves the final shape of animation,
        // if you remove it the shape will return to the original shape after the animation finished
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: nil)
        maskLayer.add(animation, forKey: nil)
        
        // border animation
        //        secondBar.backgroundColor = .clear
        //        CATransaction.begin()
        //        let layer : CAShapeLayer = CAShapeLayer()
        //        layer.strokeColor = UIColor.red.cgColor
        //        layer.lineWidth = 3.0
        //        layer.fillColor = UIColor.clear.cgColor
        //
        //        let path : UIBezierPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.secondBar.frame.size.width + 2, height: self.secondBar.frame.size.height + 2), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5.0, height: 0.0))
        //        layer.path = path.cgPath
        //
        //        let animation : CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //        animation.fromValue = 0.0
        //        animation.toValue = 1.0
        //
        //        animation.duration = 7.0
        //
        //        CATransaction.setCompletionBlock{ [weak self] in
        //            print("Animation completed")
        //        }
        //
        //        layer.add(animation, forKey: "myStroke")
        //        CATransaction.commit()
        //        self.secondBar.layer.addSublayer(layer)
        
        
        //        let path = UIBezierPath()
        //        path.move(to: CGPoint.init(x: secondBar.frame.minX, y: secondBar.frame.minY))
        //
        //        path.addLine(to: CGPoint(x: secondBar.frame.maxX, y: secondBar.frame.maxY))
        ////            path.addLine(to: CGPoint(x: 200, y: 240))
    }
}
