//
//  SquareImageView.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 10/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import Foundation
import UIKit

class SquareImageView : UIImageView {
    
    private let squareImg : UIImage = UIImage(named: "Square")!
    
    init(with point:CGPoint!){
        super.init(frame: CGRect(x: 0, y: 0, width: squareImg.size.width, height: squareImg.size.height))
        self.layer.position = CGPoint(x: point.x, y: point.y - squareImg.size.height / 2 + 8)
        self.image = squareImg
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func jumpOver(block: BlockImageView!, completion:@escaping ()->()){
        
        let path = CGMutablePath()
        path.move(to: self.layer.position)
        path.addCurve(to:CGPoint(x: block.center.x , y: block.frame.minY - squareImg.size.height / 2 + 8) , control1: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y - 100), control2: CGPoint(x: block.frame.minX, y: block.frame.minY - 250))
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path
        animation.duration = 0.7
        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        
        self.layer.add(animation, forKey: animation.keyPath)
        
        //Posicion final
        self.layer.position = CGPoint(x: block.center.x , y: block.frame.minY - squareImg.size.height / 2 + 8)
        
        UIView.animate(withDuration: 0.7, animations: {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        }, completion: { finish in
        
            if finish {
                self.transform = CGAffineTransform(rotationAngle: 0)
                completion()
            }
            
        })
        
    }
    
    func destruction(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { finish in
        
            if finish {
                completion()
            }
            
        })
    }
    
}
