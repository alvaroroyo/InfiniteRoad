//
//  GameOverView.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 10/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import Foundation
import UIKit

protocol GameOverDelegate : class {
    func restartGame()
}

class GameOverView : UIView {
    
    weak var delegate : GameOverDelegate?
    
    init(frame: CGRect, score:Int) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        
        var recordInt = UserDefaults().integer(forKey: Controller.shared().UDSCORE)
        if(score > recordInt){
            recordInt = score
            UserDefaults().set(recordInt, forKey: Controller.shared().UDSCORE)
        }
        
        let mainView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        mainView.frame = self.frame
        self.addSubview(mainView)
        
        let gameOverLbl = UILabel(frame: CGRect(x: 0, y: 20, width: self.frame.width, height: 50))
        gameOverLbl.text = "Game Over"
        gameOverLbl.textColor = UIColor.orange
        gameOverLbl.font = UIFont(name: "Verdana-bold", size: 40)
        gameOverLbl.textAlignment = .center
        mainView.addSubview(gameOverLbl)
        
        let scoreLbl = UILabel(frame: CGRect(x: 20, y: mainView.frame.midY - 65, width: self.frame.width, height: 40))
        scoreLbl.text = String(format:"Score: %li",score)
        scoreLbl.textColor = UIColor.white
        scoreLbl.font = UIFont(name: "Verdana-bold", size: 30)
        scoreLbl.textAlignment = .left
        mainView.addSubview(scoreLbl)
        
        let record = UILabel(frame: CGRect(x: 20, y: mainView.frame.midY - 20, width: self.frame.width, height: 40))
        record.text = String(format: "Record: %li",recordInt)
        record.textColor = UIColor.yellow
        record.font = UIFont(name: "Verdana-bold", size: 30)
        record.textAlignment = .left
        mainView.addSubview(record)
        
        let comboRecord = UILabel(frame: CGRect(x: 20, y: mainView.frame.midY + 40, width: self.frame.width, height: 23))
        comboRecord.text = String(format: "Combo record: %li",UserDefaults().integer(forKey: Controller.shared().UDCOMBO))
        comboRecord.textColor = Controller.shared().comboBlueColor
        comboRecord.font = UIFont(name: "Verdana-bold", size: 20)
        comboRecord.textAlignment = .left
        mainView.addSubview(comboRecord)
        
        let playBtn = UIButton.init(frame: CGRect(x: 0, y: self.frame.maxY - 70, width: 130, height: 50))
        playBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#00ff00", alpha: 0.2)), for: UIControlState.normal)
        playBtn.setTitle("Restart", for: .normal)
        playBtn.setTitleColor(UIColor.green, for: .normal)
        playBtn.clipsToBounds = true
        playBtn.layer.cornerRadius = 7
        playBtn.layer.borderColor = UIColor.green.cgColor
        playBtn.layer.borderWidth = 3
        playBtn.titleLabel?.font = UIFont(name: "Verdana", size: 25)
        playBtn.center = CGPoint(x: self.center.x, y: playBtn.center.y)
        playBtn.addTarget(self, action:#selector(platBtnAction(sender:)) , for: .touchUpInside)
        mainView.addSubview(playBtn)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func platBtnAction(sender:UIButton){
        if(delegate != nil){
            delegate!.restartGame()
        }
    }
    
}
