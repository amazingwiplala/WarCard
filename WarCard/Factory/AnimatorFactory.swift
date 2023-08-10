//
//  AnimatorFactory.swift
//  WarCard
//
//  Created by Jeanine Chuang on 2023/8/5.
//

import Foundation
import UIKit

class AnimatorFactory {
    
    static var countRotate = 0
    static var countDeal = 0
    static var countMove = 0
    
    //出牌
    static func showOnce(fromCard: UIView, fromPos: UIView, fromImage: UIImageView, toCard: UIView, toCardAlpha: CGFloat, toImage: UIImageView, defaultImage: UIImageView, times:Int, duration: Double){
        
        let move = UIViewPropertyAnimator(duration: duration, curve: .linear)
        
        if countMove >= times {
            move.stopAnimation(true)
            countMove = 0
            return
        }
        
        move.addAnimations {
            toCard.alpha = toCardAlpha
            fromCard.frame = toCard.frame
        }
        move.addCompletion{ _ in
            countMove += 1
            toCard.alpha = 1
            fromCard.frame = fromPos.frame
            toImage.image = fromImage.image
            fromImage.image = defaultImage.image
            self.showOnce(fromCard: fromCard, fromPos: fromPos, fromImage: fromImage, toCard: toCard, toCardAlpha:toCardAlpha, toImage: toImage, defaultImage:defaultImage, times: times, duration: duration)
        }
        
        move.startAnimation()
        
    }
    
    //移牌 - 單次
    static func moveOnce(fromCard: UIView, fromPos: UIView, fromImage: UIImageView, toCard: UIView, toCardAlpha: CGFloat, toImage: UIImageView, times:Int, duration: Double){
        
        let move = UIViewPropertyAnimator(duration: duration, curve: .linear)
        
        if countMove >= times {
            move.stopAnimation(true)
            countMove = 0
            return
        }
        
        move.addAnimations {
            toCard.alpha = toCardAlpha
            fromCard.frame = toCard.frame
            
        }
        move.addCompletion{ _ in
            countMove += 1
            toCard.alpha = 1
            fromCard.frame = fromPos.frame
            fromCard.alpha = 0
            toImage.image = fromImage.image
            self.moveOnce(fromCard: fromCard, fromPos: fromPos, fromImage: fromImage, toCard: toCard, toCardAlpha:toCardAlpha, toImage: toImage, times: times, duration: duration)
        }
        
        move.startAnimation()
        
    }
    
    //移牌 - 重複
    static func moveRepeat(fromCard: UIView, fromPos: UIView, fromImage: UIImageView, toCard: UIView, toImage: UIImageView, times:Int, duration: Double) {
        
        let move = UIViewPropertyAnimator(duration: duration, curve: .linear)
        
        move.addAnimations {
            toCard.alpha = 0
            fromCard.frame = toCard.frame
        }
        move.addCompletion{ _ in
            toCard.alpha = 1
            fromCard.frame = fromPos.frame
            self.moveRepeat(fromCard: fromCard, fromPos: fromPos, fromImage: fromImage, toCard: toCard, toImage: toImage, times: times, duration: duration)
        }
        
        if countMove<times {
            move.startAnimation()
            countMove += 1
        }else{
            move.stopAnimation(true)
            fromCard.frame = fromPos.frame
            fromCard.alpha = 0
            fromPos.alpha = 0
            toImage.image = fromImage.image
            countMove = 0
        }
    }
    
    //發牌
    static func dealRepeat(dealCard: [UIView], dealPos:UIView, ACard: UIView, BCard:UIView, times:Int, duration: Double) {
        
        let deal = UIViewPropertyAnimator(duration: duration, curve: .linear)
        
        deal.addAnimations {
            ACard.alpha = 0
            dealCard[0].frame = ACard.frame
        }
        deal.addAnimations {
            BCard.alpha = 0
            dealCard[1].frame = BCard.frame
        }
        deal.addCompletion{ _ in
            ACard.alpha = 1
            BCard.alpha = 1
            dealCard[0].frame = dealPos.frame
            dealCard[1].frame = dealPos.frame
            self.dealRepeat(dealCard: dealCard, dealPos: dealPos, ACard: ACard, BCard: BCard, times: times, duration: duration)
        }
        
        if countDeal<times {
            deal.startAnimation()
            countDeal += 1
        }else{
            deal.stopAnimation(true)
            for card in dealCard {
                card.frame = dealPos.frame
                card.alpha = 0
            }
            dealPos.alpha = 0
            countDeal = 0
        }
    }
    
    //旋轉
    static func rotateRepeat(view: UIView, times:Int) {
        
        let rotate = UIViewPropertyAnimator(duration: 1.0, curve: .linear)
        rotate.addAnimations {
            view.transform = CGAffineTransform(rotationAngle: .pi)
        }
        rotate.addCompletion{ _ in
            view.transform = .identity
            self.rotateRepeat(view: view, times: times)
            
        }
        if countRotate<times {
            rotate.startAnimation()
            countRotate += 1
        }else{
            rotate.stopAnimation(true)
            countRotate = 0
        }
        
    }
    
    

}
