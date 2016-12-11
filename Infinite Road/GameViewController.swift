//
//  GameViewController.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 6/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

enum soundType{
    case click
    case destruction
    case goup
    case jump
}

class GameViewController : UIViewController, GameOverDelegate{
    
    private var square : SquareImageView! = nil
    
    private var margin : UIView! = nil
    private var marginFrame : CGRect! = nil
    
    private var blocks : [BlockImageView] = []
    
    private let greenBlockImg = UIImage(named: "greenBlock")!
    private let yellowBlockImg = UIImage(named: "yellowBlock")!
    private let blueBlockImg = UIImage(named: "blueBlock")!
    
    private var bonusBall = UIImageView()
    
    private var gameOverView : GameOverView?
    
    //Sounds
    private var clickSound : AVAudioPlayer! = nil
    private var destructionSound : AVAudioPlayer! = nil
    private var goupSound : AVAudioPlayer! = nil
    private var jumpSound : AVAudioPlayer! = nil
    
    //Points
    private var score : UILabel! = nil
    
    //Combo label
    private var comboLbl = UILabel()
    
    //Status
    private var blocksInScreen : Int = 0
    private var blocksNumber : Int = 0 {
        didSet{
            score.text = String(blocksNumber)
        }
    }
    private var combo : Int = 0
    private var isAnimating = false
    private var isGameOver = false
    private var takeBonus = false
    
    override func loadView() {
        super.loadView()
        let mainView : UIView = UIView.init(frame: UIScreen.main.bounds)
        
        let bgImg = UIImageView.init(image: UIImage.init(named: "background.jpg"))
        bgImg.frame = mainView.frame
        bgImg.contentMode = .scaleAspectFill
        bgImg.isUserInteractionEnabled = false
        mainView.addSubview(bgImg)
        
        //Calcs
        self.blocksInScreen = Int((mainView.frame.width / 2) / greenBlockImg.size.width) + 1
        
        let marginImg = UIImage(named: "margin")?.stretchableImage(withLeftCapWidth: 1, topCapHeight: 0)
        self.margin = UIView(frame: CGRect(x: 0, y: (self.view.center.y - self.view.frame.height * 0.1) - (marginImg?.size.height)! / 2, width: self.view.frame.width, height: (marginImg?.size.height)!))
        self.marginFrame = self.margin.frame
        self.margin.backgroundColor = UIColor.init(patternImage: marginImg!)
        mainView.addSubview(self.margin)
        
        //FirstBlock
        let firstBlock = BlockImageView(with: CGRect(x: mainView.frame.midX - self.greenBlockImg.size.width / 2 - self.greenBlockImg.size.width, y: self.margin.frame.maxY - 11, width: self.greenBlockImg.size.width, height: self.greenBlockImg.size.height), image: greenBlockImg)
        self.blocks.append(firstBlock)
        mainView.addSubview(firstBlock)
        
        self.square = SquareImageView(with: CGPoint(x: firstBlock.center.x, y: firstBlock.frame.minY))
        mainView.addSubview(self.square)
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.frame = CGRect(x: mainView.frame.width / 2 - 30, y: 50, width: 60, height: 60)
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = blurEffectView.frame.height / 2
        mainView.addSubview(blurEffectView)
        
        score = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        score.clipsToBounds = true
        score.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        score.textAlignment = .center
        score.textColor = UIColor.white
        score.text = "0"
        blurEffectView.addSubview(score)
        
        comboLbl = UILabel(frame: CGRect(x: 0, y: score.frame.maxY + 50, width: mainView.frame.width, height: 30))
        comboLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        comboLbl.textAlignment = .center
        comboLbl.isHidden = true
        mainView.addSubview(comboLbl)
        
        let soundBtn = UIButton.init(frame: CGRect(x: mainView.frame.maxX - 60, y: 20, width: 50, height: 50))
        soundBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#ffff00", alpha: 0.4)), for: UIControlState.normal)
        soundBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#ffff00", alpha: 0.6)), for: UIControlState.highlighted)
        soundBtn.setImage(UIImage.init(named: "soundOFF"), for: UIControlState.normal)
        soundBtn.setImage(UIImage.init(named: "soundON"), for: UIControlState.selected)
        soundBtn.clipsToBounds = true
        soundBtn.layer.cornerRadius = soundBtn.frame.height / 2
        soundBtn.imageEdgeInsets = UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 7)
        soundBtn.addTarget(self, action:#selector(setSound(sender:)) , for: .touchUpInside)
        soundBtn.isSelected = Controller.shared().sound
        mainView.addSubview(soundBtn)
        
        self.bonusBall = UIImageView(image: UIImage(named: "bonus")!)
        self.bonusBall.frame = CGRect(x: 0, y: 0, width: (self.bonusBall.image?.size.width)!, height: (self.bonusBall.image?.size.height)!)
        self.bonusBall.center = CGPoint(x: mainView.center.x, y: self.bonusBall.center.y)
        self.bonusBall.isHidden = true
        mainView.addSubview(self.bonusBall)
        
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapEvent)
        
        do {try clickSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "click", ofType: "m4a")!))}catch{}
        do {try destructionSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "destruction", ofType: "m4a")!))}catch{}
        do {try goupSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "go_up", ofType: "m4a")!))}catch{}
        do {try jumpSound = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "jump", ofType: "m4a")!))}catch{}
        
        clickSound.prepareToPlay()
        destructionSound.prepareToPlay()
        goupSound.prepareToPlay()
        jumpSound.prepareToPlay()
        
        self.startGame()
        
    }
    
    //Methods
    
    @objc private func tapGestureAction(){
        if !self.isGameOver && !self.isAnimating {
            self.blocksNumber += 1
            self.isAnimating = true
            let block = self.blocks.last!
            block.stop()
            
            if !self.bonusBall.isHidden{
                
                if block.frame.intersects(self.bonusBall.frame) {
                    
                    self.takeBonus = true
                    
                    var upMargin = Int(self.margin.frame.minY) - self.combo * 10
                    
                    if upMargin < Int(self.marginFrame.minY) { upMargin = Int(self.marginFrame.minY) }
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        self.margin.frame = CGRect(x: 0.0, y: CGFloat(upMargin), width: self.margin.frame.width, height: self.margin.frame.height)
                    })
                }
                
                self.bonusBall.isHidden = true
                self.combo = 0
            }else if block.frame.minY < self.blocks[self.blocks.count - 2].frame.midY {
                
                self.takeBonus = false
                self.combo += 1
                
                var comboColor : UIColor!
                
                if combo < 3 {
                    comboColor = UIColor.green
                }else if combo < 6 {
                    comboColor = UIColor.yellow
                }else{
                    comboColor = Controller.shared().comboBlueColor
                }
                
                self.comboLbl.textColor = comboColor
                self.comboLbl.layer.shadowColor = comboColor.cgColor
                self.comboLbl.layer.shadowOffset = CGSize(width: 0, height: 0)
                self.comboLbl.layer.shadowRadius = 5
                self.comboLbl.layer.shadowOpacity = 0.5
                self.comboLbl.text = String(format: "Combo x%li", self.combo)
                self.comboLbl.isHidden = false
                
                UIView.animate(withDuration: 0.7, animations: {
                    self.comboLbl.transform = CGAffineTransform(scaleX: 4, y: 4)
                    self.comboLbl.alpha = 0
                }, completion: {finish in
                    
                    if finish {
                        self.comboLbl.isHidden = true
                        self.comboLbl.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.comboLbl.alpha = 1
                    }
                    
                })
                
            }else{
                
                let comboRecord = UserDefaults().integer(forKey: Controller.shared().UDCOMBO)
                if(self.combo > comboRecord){
                    UserDefaults().set(self.combo, forKey: Controller.shared().UDCOMBO)
                }
                
                if self.combo >= 3 {
                    self.showBonus()
                }else{
                    self.combo = 0
                }
                
                self.takeBonus = false
                
            }
            
            self.play(soundType: .jump)
            
            self.square.jumpOver(block: self.blocks.last!, completion: {
                self.blocksToLeft()
            })
        }
    }
    
    private func newBlock(){
        let distance = self.view.frame.maxY - self.margin.frame.minY
        let timeFactor = 2.4 - (Double(self.blocksNumber) / 10.0 * 0.05)
        let upAnimInterval = Double(distance) * timeFactor / 1000.0
        
        var nextImage : UIImage! = nil
        
        if self.combo >= 6 {
            nextImage = self.blueBlockImg
        }else if self.combo >= 3 {
            nextImage = self.yellowBlockImg
        }else{
            nextImage = self.greenBlockImg
        }
        
        let block = BlockImageView(image: nextImage)
        self.view.addSubview(block)
        
        self.blocks.append(block)
        
        self.play(soundType: .goup)
        
        UIView.animate(withDuration: upAnimInterval, delay: 0, options: .curveLinear, animations: {
            block.frame = CGRect(x: block.frame.origin.x, y: self.margin.frame.maxY - 11, width: block.frame.width, height: block.frame.height)
        }, completion: { finish in
            
            if finish {
                print("Game over")
                self.isGameOver = true
                self.play(soundType: .destruction)
                self.square.destruction(completion: {
                    self.gameOverView = GameOverView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.55), score:self.blocksNumber)
                    self.gameOverView?.center = self.view.center
                    self.gameOverView?.delegate = self
                    self.view.addSubview(self.gameOverView!)
                })
            }
        
        })
        
    }
    
    func blocksToLeft(){
        let timeFactor = Double(self.blocksNumber) / 10.0 * 0.06
        var leftAnimInterval :TimeInterval = 0.8 - timeFactor
        
        if leftAnimInterval < 0.4 {
            leftAnimInterval = 0.4
        }
        
        if self.blocks.count > self.blocksInScreen {
            let block = self.blocks.remove(at: 0)
            block.removeFromSuperview()
        }
        
        var index = 0
        for block in self.blocks {
            UIView.animate(withDuration: leftAnimInterval, animations: {
                block.frame = CGRect(x: block.frame.minX - block.frame.width, y: block.frame.minY, width: block.frame.width, height: block.frame.height)
                
                if index == self.blocks.count - 1 {
                    self.square.frame = CGRect(x: self.square.frame.minX - block.frame.width, y: self.square.frame.minY, width: self.square.frame.width, height: self.square.frame.height)
                    if !self.takeBonus {
                        self.margin.frame = CGRect(x: 0, y: block.frame.minY - 3, width: self.margin.frame.width, height: self.margin.frame.height)
                    }
                }
                
            }, completion: { finish in
            
                if finish && index == self.blocks.count{
                    self.isAnimating = false
                    self.newBlock()
                }
                
            })
            
            index += 1
            
        }
    }
    
    func startGame(){
        self.isAnimating = true
        let cuentaAtras = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        cuentaAtras.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        cuentaAtras.textColor = UIColor.white
        cuentaAtras.textAlignment = .center
        cuentaAtras.text = "3"
        self.view.addSubview(cuentaAtras)
        
        let clean : (String) -> Void = { next in
            cuentaAtras.alpha = 1
            cuentaAtras.text = next
            cuentaAtras.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.play(soundType: .click)
        }
        
        let timeLabelAnimation : (@escaping ()->()) -> Void = { completion in
            UIView.animate(withDuration: 1, animations: {
                cuentaAtras.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
                cuentaAtras.alpha = 0
            }, completion: { finish in
                completion()
            })
        }
        self.play(soundType: .click)
        timeLabelAnimation{
            clean("2")
            timeLabelAnimation{
                clean("1")
                timeLabelAnimation{
                    cuentaAtras.removeFromSuperview()
                    self.isAnimating = false
                    self.newBlock()
                }
            }
        }
        
    }
    
    @objc func setSound(sender: UIButton!){
        sender.isSelected = !sender.isSelected
        print(String(format: "Sound: %@", sender.isSelected ? "OFF" : "ON"))
        Controller.shared().sound = sender.isSelected
    }
    
    func play(soundType: soundType){
        
        if(Controller.shared().sound!){
            switch soundType {
            case .click:
                clickSound.play()
                break
            case .destruction:
                destructionSound.play()
                break
            case .goup:
                goupSound.play()
                break
            case .jump:
                jumpSound.play()
                break
            }
        }
    }
    
    func showBonus(){
        let block = self.blocks.last!
        let A : UInt32 = UInt32(block.frame.minY)
        let B : UInt32 = UInt32(self.view.frame.maxY) - 10
        let distY = arc4random_uniform(B - A) + A
        self.bonusBall.layer.position = CGPoint(x: self.bonusBall.center.x, y: CGFloat(distY))
        self.bonusBall.isHidden = false
    }
    
    func restartGame() {

        //Status reset
        self.blocksNumber = 0
        self.combo = 0
        self.isAnimating = false
        self.isGameOver = false
        self.takeBonus = false
        
        self.bonusBall.isHidden = true
        
        for _ in 0...self.blocks.count - 1 {
            let block = self.blocks.remove(at: 0)
            block.removeFromSuperview()
        }
        
        self.margin.frame = self.marginFrame
        
        let firstBlock = BlockImageView(with: CGRect(x: self.view.frame.midX - self.greenBlockImg.size.width / 2 - self.greenBlockImg.size.width, y: self.margin.frame.maxY - 11, width: self.greenBlockImg.size.width, height: self.greenBlockImg.size.height), image: greenBlockImg)
        self.blocks.append(firstBlock)
        self.view.addSubview(firstBlock)
        
        self.square.layer.position = CGPoint(x: firstBlock.center.x, y: firstBlock.frame.minY - greenBlockImg.size.height / 2 + 5)
        UIView.animate(withDuration: 0.5, animations: {
            self.square.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
        self.gameOverView?.removeFromSuperview()
        
        startGame()
    }
    
}
