//
//  Controller.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 10/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import Foundation
import UIKit

class Controller {
    
    static private var singleton : Controller?
    
    private let UDSOUND = "SOUND"
    let UDSCORE = "SCORE"
    let UDCOMBO = "COMBO"
    
    static func shared() -> Controller{
        if(self.singleton == nil){
            self.singleton = Controller()
        }
        return self.singleton!
    }
    
    private init(){
        
        let ud_dic = UserDefaults().dictionaryRepresentation()
        
        if(ud_dic.index(forKey: UDSOUND) == nil){
            sound = true
        }else{
            sound = UserDefaults().bool(forKey: UDSOUND)
        }
        
    }
    
    var sound : Bool! {
        didSet{
            if(oldValue != sound){
                UserDefaults().set(sound, forKey: UDSOUND)
                UserDefaults().synchronize()
            }
        }
    }
    
    let comboBlueColor = UIColor.init(colorLiteralRed: 112.0/255.0, green: 251.0/255.0, blue: 253.0/255.0, alpha: 1)
    
}
