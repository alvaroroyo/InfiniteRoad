//
//  FirstPageView.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 11/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import Foundation
import UIKit

class FirstPageView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let aligmentRight = NSMutableParagraphStyle()
        aligmentRight.alignment = .right
        
        let finalString = NSMutableAttributedString()
        finalString.append(NSAttributedString(string: NSLocalizedString("How to play:", comment: ""), attributes: [NSFontAttributeName : UIFont(name: "MarkerFelt-Wide", size: 35)!, NSForegroundColorAttributeName : UIColor.colorWithHex(hex: "#ffff00", alpha: 0.8)]))
        finalString.append(NSAttributedString(string: NSLocalizedString("\n\nStop the blocks before they reach the margin.\nThe margin is adjusted to the height of the last block.\nIf the block touch the margin, game over.\nThe speed increments with the blocks number.\n\n", comment: ""), attributes: [NSFontAttributeName : UIFont(name: "MarkerFelt-Wide", size: 15)!, NSForegroundColorAttributeName : UIColor.colorWithHex(hex: "#00ff00", alpha: 1)]))
//        finalString.append(NSAttributedString(string: "Pasa página para más información", attributes: [NSFontAttributeName : UIFont(name: "MarkerFelt-Wide", size: 12)!, NSForegroundColorAttributeName : UIColor.colorWithHex(hex: "#00ff00", alpha: 1), NSParagraphStyleAttributeName : aligmentRight]))
        
        let textLbl = UILabel(frame: CGRect(x: 15, y: 0, width: frame.width - 15 - 15, height: frame.height))
        textLbl.attributedText = finalString
        textLbl.numberOfLines = 0
        textLbl.textAlignment = .natural
        self.addSubview(textLbl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
