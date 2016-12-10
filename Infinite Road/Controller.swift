//
//  Controller.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 10/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import Foundation

class Controller {
    
    static let shared = Controller()
    
    private let UD_SOUND = "SOUND"
    
    init(){
        
        let ud_dic = UserDefaults().dictionaryRepresentation()
        
        if(ud_dic.index(forKey: UD_SOUND) == nil){
            sound = true
        }else{
            sound = UserDefaults().bool(forKey: UD_SOUND)
        }
        
    }
    
    var sound : Bool! {
        didSet{
            if(oldValue != sound){
                UserDefaults().set(sound, forKey: UD_SOUND)
                UserDefaults().synchronize()
            }
        }
    }
    
    
    
}
