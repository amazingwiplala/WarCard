//
//  GameViewController.swift
//  WarCard
//
//  Created by Jeanine Chuang on 2023/8/8.
//

import UIKit
import GameplayKit

class GameViewController: UIViewController {
    
    //table
    @IBOutlet weak var TableImageView: UIImageView!
    @IBOutlet weak var DealerButton: UIButton!{
        didSet {
            DealerButton.configurationUpdateHandler = { [self] _ in
                DealerButton.alpha = DealerButton.isHighlighted ? 0.7 : waitForDealing
            }
        }
    }
    //Image
    let DefaultBackground = UIImage(named: "table")
    let WarBackground = UIImage(named: "table-war")
    let DefaultImage = UIImage(named: "CardPattern")
    
    //Cards
    var Cards:[Card] = [Card]()
    var APlayerCards:[Card] = [Card]()
    var BPlayerCards:[Card] = [Card]()
    var AGainCards = [Card]()
    var BGainCards = [Card]()
    var ACard = Card()
    var BCard = Card()
    var TempCards:[Card] = [Card]()
    
    //War
    var inWar:Bool = false
    var tapCount:Int = 0
   
    //A Player
    @IBOutlet weak var APlayerPosition: UIView!
    @IBOutlet weak var APlayerPosImage: UIImageView!
    @IBOutlet weak var APlayerCard: UIView!
    @IBOutlet weak var APlayerCardImage: UIImageView!
    
    //A Gain
    @IBOutlet weak var AGainPosition: UIView!
    @IBOutlet weak var AGainPosImage: UIImageView!
    @IBOutlet weak var AGainCard: UIView!
    @IBOutlet weak var AGainCardImage: UIImageView!
    
    //A Show
    @IBOutlet weak var AShowPosition: UIView!
    @IBOutlet weak var AShowCard: UIView!
    @IBOutlet weak var AShowCardImage: UIImageView!
    
    //B Player
    @IBOutlet weak var BPlayerPosition: UIView!
    @IBOutlet weak var BPlayerPosImage: UIImageView!
    @IBOutlet weak var BPlayerCard: UIView!
    @IBOutlet weak var BPlayerCardImage: UIImageView!
    
    //B Gain
    @IBOutlet weak var BGainPosition: UIView!
    @IBOutlet weak var BGainPosImage: UIImageView!
    @IBOutlet weak var BGainCard: UIView!
    @IBOutlet weak var BGainCardImage: UIImageView!
    
    //B Show
    @IBOutlet weak var BShowPosition: UIView!
    @IBOutlet weak var BShowCard: UIView!
    @IBOutlet weak var BShowCardImage: UIImageView!
    
    //Dealer
    @IBOutlet var DealerView: [UIView]!
    var waitForDealing:CGFloat = 1
    
    //Label
    @IBOutlet weak var APlayerLabel: UILabel!
    @IBOutlet weak var AGainLabel: UILabel!
    @IBOutlet weak var BGainLabel: UILabel!
    @IBOutlet weak var BPlayerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDealer()
        initDealing()
        Cards = initCards()
        
    }
    
    //==================================================================//
    // 初始
    //==================================================================//
    //初始卡牌
    func initCards() -> [Card] {
        var cards:[Card] = [Card]()
        var value:Int = 2
        var rank:String = ""
        while value<15 {
            switch value {
            case 14:
                rank = "ACE"
            case 11:
                rank = "JACK"
            case 12:
                rank = "QUEEN"
            case 13:
                rank = "KING"
            default:
                rank = String(format: "%02d", value)
            }
            cards.append(Card(Suit: "SPADES", Rank: rank, Value: value))
            cards.append(Card(Suit: "HEARTS", Rank: rank, Value: value))
            cards.append(Card(Suit: "DIAMONDS", Rank: rank, Value: value))
            cards.append(Card(Suit: "CLUBS", Rank: rank, Value: value))
            value += 1
        }
        
        return cards
    }
    
    //發牌準備
    func initDealing(){
        
        waitForDealing = 1
        DealerButton.alpha = 1
        DealerView[0].alpha = 1
        DealerView[1].alpha = 1
        
        APlayerPosition.alpha = 0
        APlayerCard.alpha = 0
        AGainPosition.alpha = 0
        AGainCard.alpha = 0
        //AShowPosition.alpha = 0
        AShowCard.alpha = 0
        
        BPlayerPosition.alpha = 0
        BPlayerCard.alpha = 0
        BGainPosition.alpha = 0
        BGainCard.alpha = 0
        BShowPosition.alpha = 0
        BShowCard.alpha = 0
        
        APlayerLabel.text = "0"
        AGainLabel.text = "0"
        BPlayerLabel.text = "0"
        BGainLabel.text = "0"
    }
    //初始按鈕
    func initDealer(){
        DealerButton.configuration?.background.strokeWidth = 3
        DealerButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        DealerButton.layer.shadowOpacity = 1
        DealerButton.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    //==================================================================//
    // 發牌
    //==================================================================//
    
    //發牌
    @IBAction func dealing(_ sender: Any) {
        
        waitForDealing = 0
        
        //資料
        let newCards:[Card] = shuffleCards(beforeShuffle: Cards) //洗牌
        APlayerCards.removeAll()
        BPlayerCards.removeAll()
        var count = 0
        for card in newCards {
            if count % 2 == 1 {
                APlayerCards.append(card)
            }else{
                BPlayerCards.append(card)
            }
            count += 1
        }
        
        //動畫
        AnimatorFactory.dealRepeat(
                dealCard: DealerView,
                dealPos: AShowPosition,
                ACard: APlayerPosition,
                BCard: BPlayerPosition,
                times: 20, duration: 0.1)
        
        APlayerCard.alpha = 1
        BPlayerCard.alpha = 1
        
        //更新持有卡牌數
        updateCount()
        
    }
    
    //洗牌
    func shuffleCards(beforeShuffle:[Card]) -> [Card] {
        //亂數排序
        let afterShuffle:[Any] = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: beforeShuffle)
        //資料型態
        var cards:[Card] = [Card]()
        for item in afterShuffle {
            cards.append(item as! Card)
        }
        return cards
    }
    
    //==================================================================//
    // 出牌
    //==================================================================//
    
    //輕點 B
    @IBAction func TapBPlayer(_ sender: Any) {
        
        //檢查剩下牌數
        if !checkPlayerCards() {
            //若需要整理卡牌，此次不出牌
            return
        }
        
        //停止Tap
        BPlayerCard.isUserInteractionEnabled = false
        
        //出牌
        ACard = APlayerCards.popLast() ?? Card()
        BCard = BPlayerCards.popLast() ?? Card()
        
        TempCards.append(ACard)
        TempCards.append(BCard)
        
        var ACardImage = UIImage(named: "\(ACard.Suit)_\(ACard.Rank)")
        var BCardImage = UIImage(named: "\(BCard.Suit)_\(BCard.Rank)")
        
        //in a War
        if inWar && tapCount<3 {
            ACardImage = DefaultImage
            BCardImage = DefaultImage
            tapCount += 1
            
        //not in War
        }else{
            inWar = false
            tapCount = 0
            TableImageView.image = DefaultBackground
        }
        
        BPlayerShowCard(BCardImage ?? UIImage())    //B出牌
        APlayerShowCard(ACardImage ?? UIImage())    //A出牌
        
        perform(#selector(keepCard), with: nil, afterDelay: 1)
        perform(#selector(whoWins), with: nil, afterDelay: 2)
        
        //更新持有卡牌數
        updateCount()
        
    }
    
    //判斷卡牌大小
    @objc func whoWins(){
        
        //War狀態下先不判斷輸贏
        if inWar {
            //啟用Tap
            BPlayerCard.isUserInteractionEnabled = true
            return
        }
        
        //一樣
        if ACard == BCard {
            inWar = true
            TableImageView.image = WarBackground
            
        //Ａ WIN
        }else if ACard > BCard {
            APlayerWin()
            
        //Ｂ WIN
        }else{
            BPlayerWin()
        }
        
        //啟用Tap
        BPlayerCard.isUserInteractionEnabled = true
    }
    
    //保留牌桌上的卡牌
    @objc func keepCard(){
        AShowPosition.alpha = inWar && tapCount<3 ? 1 : 0
        BShowPosition.alpha = inWar && tapCount<3 ? 1 : 0
    }
    
    //檢查Player還有卡牌嗎？
    //若沒有要從Gain整理進來
    //若Gain也都沒有了，產生贏家，遊戲結束！
    func checkPlayerCards() -> Bool{
        var keepGoing = true
        //A Player
        if APlayerCards.isEmpty {
            if AGainCards.isEmpty {
                //B贏了
                gameOverAlert(title: "Congratulations!!!", message: "恭喜您贏得卡牌戰爭！")
            }else{
                //移牌：A Gain -> A Player
                collectToAPlayer()
            }
            keepGoing = false
        }
        
        //B Player
        if BPlayerCards.isEmpty {
            if BGainCards.isEmpty {
                //A贏了
                gameOverAlert(title: "GAME OVER", message: "oh oh you lose...")
            }else{
                //移牌：B Gain -> B Player
                collectToBPlayer()
            }
            keepGoing = false
        }
        
        return keepGoing
        
    }
    
    //==================================================================//
    // 移動卡牌
    //==================================================================//
    
    //A 出牌
    func APlayerShowCard(_ cardImage:UIImage){
        
        APlayerCardImage.image = cardImage
        AnimatorFactory.showOnce(
            fromCard: APlayerCard,
            fromPos: APlayerPosition,
            fromImage: APlayerCardImage,
            toCard: AShowCard,
            toCardAlpha: 0,
            toImage: AShowCardImage,
            defaultImage: APlayerPosImage,
            times: 1, duration: 0.8)
    }
    
    //B 出牌
    func BPlayerShowCard(_ cardImage:UIImage){
        
        BPlayerCardImage.image = cardImage
        AnimatorFactory.showOnce(
            fromCard: BPlayerCard,
            fromPos: BPlayerPosition,
            fromImage: BPlayerCardImage,
            toCard: BShowCard,
            toCardAlpha: 0,
            toImage: BShowCardImage,
            defaultImage: BPlayerPosImage,
            times: 1, duration: 0.8)

    }
    
    //A 大於 B
    //A Win - ShowCards to A GainCard
    func APlayerWin(){
        
        //資料
        AGainCards.append(contentsOf: TempCards)
        TempCards.removeAll()
        
        //動畫
        //A Show -> A Gain
        AnimatorFactory.moveOnce(
            fromCard: AShowCard,
            fromPos: AShowPosition,
            fromImage: AShowCardImage,
            toCard: AGainCard,
            toCardAlpha: 1,
            toImage: AGainCardImage,
            times: 1, duration: 0.9)
        AShowPosition.alpha = 0
        
        //B Show -> A Gain
        AnimatorFactory.moveOnce(
            fromCard: BShowCard,
            fromPos: BShowPosition,
            fromImage: BShowCardImage,
            toCard: AGainCard,
            toCardAlpha: 1,
            toImage: AGainCardImage,
            times: 1, duration: 0.5)
        BShowPosition.alpha = 0
        
        //更新持有卡牌數
        updateCount()
        
    }
    
    //A 小於 B
    //B Win - ShowCards to B GainCard
    func BPlayerWin(){
        
        //資料
        BGainCards.append(contentsOf: TempCards)
        TempCards.removeAll()
        
        //動畫
        //A Show -> B Gain
        AnimatorFactory.moveOnce(
            fromCard: AShowCard,
            fromPos: AShowPosition,
            fromImage: AShowCardImage,
            toCard: BGainCard,
            toCardAlpha: 1,
            toImage: BGainCardImage,
            times: 1, duration: 0.5)
        AShowPosition.alpha = 0
        
        //B Show -> B Gain
        AnimatorFactory.moveOnce(
            fromCard: BShowCard,
            fromPos: BShowPosition,
            fromImage: BShowCardImage,
            toCard: BGainCard,
            toCardAlpha: 1,
            toImage: BGainCardImage,
            times: 1, duration: 0.9)
        BShowPosition.alpha = 0
        
        //更新持有卡牌數
        updateCount()
        
    }
    
    //A Gain -> A Player 整理卡牌
    func collectToAPlayer(){
        
        //資料
        let newGainCards:[Card] = shuffleCards(beforeShuffle: AGainCards) //洗牌
        APlayerCards.append(contentsOf: newGainCards)
        AGainCards.removeAll()
        
        //動畫
        AGainCardImage.image = DefaultImage
        AnimatorFactory.moveRepeat(
            fromCard: AGainCard,
            fromPos: AGainPosition,
            fromImage: AGainPosImage,
            toCard: APlayerPosition,
            toImage: APlayerPosImage,
            times: 6, duration: 0.2)
        
        //更新持有卡牌數
        updateCount()
    }
    
    //B Gain -> B Player 整理卡牌
    func collectToBPlayer(){
        
        //資料
        let newGainCards:[Card] = shuffleCards(beforeShuffle: BGainCards) //洗牌
        BPlayerCards.append(contentsOf: newGainCards)
        BGainCards.removeAll()
        
        //動畫
        BGainCardImage.image = DefaultImage
        AnimatorFactory.moveRepeat(
            fromCard: BGainCard,
            fromPos: BGainPosition,
            fromImage: BGainPosImage,
            toCard: BPlayerPosition,
            toImage: BPlayerPosImage,
            times: 6, duration: 0.2)
        
        //更新持有卡牌數
        updateCount()
        
    }
    
    //更新持有牌數
    func updateCount(){
        APlayerLabel.text = String(APlayerCards.count)
        AGainLabel.text = String(AGainCards.count)
        BPlayerLabel.text = String(BPlayerCards.count)
        BGainLabel.text = String(BGainCards.count)
    }
    
    //訊息 - 遊戲結束
    func gameOverAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.initDealing()
        })
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
