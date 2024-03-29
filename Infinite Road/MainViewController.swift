//
//  ViewController.swift
//  Infinite Road
//
//  Created by Alvaro Royo on 5/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UIScrollViewDelegate {

    private var scrollView : UIScrollView = UIScrollView()
    private var paginView : UIPageControl = UIPageControl()
    
    override func loadView() {
        let mainView : UIView = UIView.init(frame: UIScreen.main.bounds)
        
        //Construcción de la vista de la pantalla de inicio
        self.navigationController?.navigationBar.isHidden = true //Navigation bar oculta
        
        //Background
        let bgImg = UIImageView.init(image: UIImage.init(named: "background.jpg"))
        bgImg.frame = mainView.frame
        bgImg.contentMode = .scaleAspectFill
        bgImg.isUserInteractionEnabled = false
        mainView.addSubview(bgImg)
        
        //Titulo y animacion
        let titleString : NSMutableAttributedString = NSMutableAttributedString.init()
        titleString.append(NSAttributedString.init(string: "INFINITE", attributes: [NSFontAttributeName : UIFont.init(name: "Verdana-Bold", size: mainView.frame.width * 0.165)!]))
        titleString.append(NSAttributedString.init(string: "\nROAD", attributes: [NSFontAttributeName : UIFont.init(name: "Verdana-Bold", size: mainView.frame.width * 0.283)!]))
        
        let infiniteRoadTitle : UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height * 0.35))
        infiniteRoadTitle.textColor = UIColor.colorWithHex(hex: "#ffffff", alpha: 0.7)
        infiniteRoadTitle.textAlignment = .center
        infiniteRoadTitle.numberOfLines = 0
        infiniteRoadTitle.layer.shadowColor = UIColor.white.cgColor
        infiniteRoadTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        infiniteRoadTitle.layer.shadowRadius = 5
        infiniteRoadTitle.layer.shadowOpacity = 0.5
        infiniteRoadTitle.attributedText = titleString
        mainView.addSubview(infiniteRoadTitle)
        
        let beatAnim = CABasicAnimation.init(keyPath: "transform.scale")
        beatAnim.duration = 0.7
        beatAnim.repeatCount = HUGE
        beatAnim.autoreverses = true
        beatAnim.fromValue = 1.0
        beatAnim.toValue = 1.1
        beatAnim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        infiniteRoadTitle.layer.add(beatAnim, forKey: "beatAnimation")
        
        //Boton de play
        let playBtn = UIButton.init(frame: CGRect(x: 0, y: mainView.frame.maxY - 130, width: 100, height: 50))
        playBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#00ff00", alpha: 0.2)), for: UIControlState.normal)
        playBtn.setTitle(NSLocalizedString("Play", comment: ""), for: .normal)
        playBtn.setTitleColor(UIColor.green, for: .normal)
        playBtn.clipsToBounds = true
        playBtn.layer.cornerRadius = 7
        playBtn.layer.borderColor = UIColor.green.cgColor
        playBtn.layer.borderWidth = 3
        playBtn.titleLabel?.font = UIFont(name: "Verdana", size: 25)
        playBtn.center = CGPoint(x: mainView.center.x, y: playBtn.center.y)
        playBtn.addTarget(self, action:#selector(playBtnAction(sender:)) , for: .touchUpInside)
        mainView.addSubview(playBtn)
        
        let soundBtn = UIButton.init(frame: CGRect(x: 0, y: playBtn.frame.maxY + 10, width: 80, height: 35))
        soundBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#00ff00", alpha: 0.2)), for: UIControlState.selected)
        soundBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#ff0000", alpha: 0.2)), for: UIControlState.normal)
        soundBtn.setTitle(NSLocalizedString("Sound ON", comment: ""), for: .selected)
        soundBtn.setTitle(NSLocalizedString("Sound OFF", comment: ""), for: .normal)
        soundBtn.setTitleColor(UIColor.green, for: .selected)
        soundBtn.setTitleColor(UIColor.red, for: .normal)
        soundBtn.clipsToBounds = true
        soundBtn.layer.cornerRadius = 7
        soundBtn.layer.borderWidth = 2
        soundBtn.titleLabel?.font = UIFont(name: "Verdana", size: 12)
        soundBtn.center = CGPoint(x: mainView.center.x, y: soundBtn.center.y)
        soundBtn.addTarget(self, action:#selector(soundBtnAction(sender:)) , for: .touchUpInside)
        soundBtn.isSelected = Controller.shared().sound!
        soundBtn.layer.borderColor = soundBtn.isSelected ? UIColor.green.cgColor : UIColor.red.cgColor
        mainView.addSubview(soundBtn)
        
        let numPaginas : CGFloat = 2
        
        paginView.frame = CGRect(x: 0, y: playBtn.frame.minY - 22, width: mainView.frame.width, height: 15)
        paginView.numberOfPages = Int(numPaginas)
        paginView.pageIndicatorTintColor = UIColor.white
        paginView.currentPageIndicatorTintColor = UIColor.green
        mainView.addSubview(paginView)
        
        scrollView.frame = CGRect(x: 0, y: infiniteRoadTitle.frame.maxY, width: mainView.frame.width, height: paginView.frame.minY - infiniteRoadTitle.frame.maxY - 3)
        scrollView.contentSize = CGSize(width: mainView.frame.width * numPaginas, height: scrollView.frame.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        mainView.addSubview(scrollView)
        
        //Scroll pagins
        scrollView.addSubview(FirstPageView(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: scrollView.frame.height)))
        
        self.view = mainView
    }

    @objc private func playBtnAction(sender : UIButton){
        self.navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    @objc private func soundBtnAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        Controller.shared().sound = sender.isSelected
        
        sender.layer.borderColor = sender.isSelected ? UIColor.green.cgColor : UIColor.red.cgColor
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = floor((scrollView.contentOffset.x - self.view.frame.width / 2) / self.view.frame.width) + 1
        self.paginView.currentPage = Int(page)
    }
}

