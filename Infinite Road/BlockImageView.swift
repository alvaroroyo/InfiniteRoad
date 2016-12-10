//
//  File.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 10/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import Foundation
import UIKit

class BlockImageView : UIImageView{
    
    init(with frame: CGRect!, image: UIImage){
        super.init(frame: frame)
        self.image = image
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        let screen = UIScreen.main.bounds
        self.frame = CGRect(x: screen.width / 2 - (image?.size.width)! / 2, y: screen.maxY, width: (image?.size.width)!, height: (image?.size.height)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stop(){
        let frame = self.layer.presentation()?.frame
        if(frame != nil){
            self.frame = frame!
        }
        self.layer.removeAllAnimations()
    }
    
}
