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
        finalString.append(NSAttributedString(string: "\n\nDetén los bloques antes de que lleguen al margen.\nEl margen se ajusta a la altura del ultimo bloque.\nSi el bloque toca el margen, estás perdido.\nLa velocidad de subida de los bloques se incrementa con el número de bloques.\n\nSi te gusta el juego puedes obtener la versión completa con la que podrás acceder al sistema de combos y hacer el juego más divertido y entretenido.\n\n", attributes: [NSFontAttributeName : UIFont(name: "MarkerFelt-Wide", size: 15)!, NSForegroundColorAttributeName : UIColor.colorWithHex(hex: "#00ff00", alpha: 1)]))
        finalString.append(NSAttributedString(string: "Pasa página para más información", attributes: [NSFontAttributeName : UIFont(name: "MarkerFelt-Wide", size: 12)!, NSForegroundColorAttributeName : UIColor.colorWithHex(hex: "#00ff00", alpha: 1), NSParagraphStyleAttributeName : aligmentRight]))
        
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
