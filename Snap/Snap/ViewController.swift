//
//  ViewController.swift
//  Snap
//
//  Created by Bhumeshwer KATRE on 9/9/19.
//  Copyright © 2019 Bhumeshwer KATRE. All rights reserved.
//

import UIKit

enum Player: Int {
    case one = 1
    case second
}
class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var remainingCards: UILabel!

    @IBOutlet weak var playerOneCard: UILabel!
    @IBOutlet weak var playerTwoCard: UILabel!

    @IBOutlet weak var playerOneButton: UIButton!
    @IBOutlet weak var playerTwoButton: UIButton!

    @IBOutlet weak var startButton: UIButton!

    var snap: Snap!
    var isStarted: Bool = false
    var nextTurn: Player = .one

    var animationTimer: Timer!
    var animationTimerFade: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.changeButtonState(forButton: playerOneButton, withStatus: false)
        self.changeButtonState(forButton: playerTwoButton, withStatus: false)
        setUpUI()
    }

    func setUpUI() {
        self.applyBorderToView(self.playerOneCard)
        self.applyBorderToView(self.playerTwoCard)
        self.applyBorderToView(self.remainingCards)
        self.makeCornerRounded(self.remainingCards)
    }

    @IBAction func player1DrawCard(_ sender: Any) {
        self.changeButtonState(forButton: playerOneButton, withStatus: false)
        self.changeButtonState(forButton: playerTwoButton, withStatus: true)

        if isStarted, snap.isCardRemain {
            snap.flipNextCardByPlayer(0)
            snap.update()
            snap.playerHit(0)
            drawGame(forPlayer: 0)
            if !snap.started {
                endGame()
                self.resultLabel.text = "Player 1 Won!".uppercased()
                self.playerOneCard.text = "\(self.playerOneCard.text ?? "")\n **SNAP**"
                self.resultLabel.textColor = UIColor.red
                self.playerWinAnimation(0)
            } else if !snap.isCardRemain {
                makeItDraw()
            }
        }
    }

    @IBAction func player2DrawCard(_ sender: Any) {
        self.changeButtonState(forButton: playerOneButton, withStatus: true)
        self.changeButtonState(forButton: playerTwoButton, withStatus: false)

        if isStarted, snap.isCardRemain {
            snap.flipNextCardByPlayer(1)
            snap.update()
            snap.playerHit(1)
            drawGame(forPlayer: 1)
            if !snap.started {
                endGame()
                self.resultLabel.text = "Player 2 Won!".uppercased()
                self.playerTwoCard.text = "\(self.playerTwoCard.text ?? "")\n **SNAP**"
                self.resultLabel.textColor = UIColor.red
                self.playerWinAnimation(1)
            } else if !snap.isCardRemain {
                makeItDraw()
            }
        }
    }

    private func makeItDraw() {
        reset()
        endGame()
        self.resultLabel.text = "Match draw".uppercased()
        self.resultLabel.textColor = UIColor.red
    }

    private func drawGame(forPlayer player: Int) {
        if player == 0 {
            self.playerOneCard.text = "\(snap.topCard.getRank)\n\(snap.topCard.getSuit)"
        } else if player == 1 {
            self.playerTwoCard.text = "\(snap.topCard.getRank)\n\(snap.topCard.getSuit)"
        }
        self.resultLabel.text = "MATCH IS IN PROGRESS..."
        self.remainingCards.text = "\(self.snap.remainingCard)"
    }

    @IBAction func startGame(_ sender: Any) {
        if self.startButton.title(for: .normal) == "START GAME" {
            self.startButton.setTitle("END GAME", for: .normal)
            self.startGame()
        } else if self.startButton.title(for: .normal) == "END GAME" {
            self.startButton.setTitle("START GAME", for: .normal)
            self.endGame(updateRemainingCard: true)
        }

        self.playerOneCard.text = "Player#1"
        self.playerTwoCard.text = "Player#2"
         self.resultLabel.textColor = .black
    }

    private func reset() {
        isStarted = false
        self.resultLabel.text = ""
        self.startButton.isEnabled = true
    }

    private func startGame() {
        snap = Snap()
        isStarted = true
        snap.start()

        self.changeButtonState(forButton: playerOneButton, withStatus: true)
        self.changeButtonState(forButton: playerTwoButton, withStatus: false)

        self.resultLabel.text = ""
        self.remainingCards.text = "\(self.snap.remainingCard)"
    }

    private func endGame(updateRemainingCard: Bool = false) {
        reset()
        self.changeButtonState(forButton: playerOneButton, withStatus: false)
        self.changeButtonState(forButton: playerTwoButton, withStatus: false)

        if self.animationTimer != nil {
            self.animationTimer.invalidate()
        }
        if self.animationTimerFade != nil {
            self.animationTimerFade.invalidate()
        }

        self.playerOneCard.backgroundColor = UIColor.white
        self.playerTwoCard.backgroundColor = UIColor.white
        if updateRemainingCard {
            self.remainingCards.text = "\(Card.getTotalCard)"
        }
    }

    func applyBorderToView(_ component: UIView?) {
        if let view = component {
            view.layer.cornerRadius = 5.0
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 2.0
        }
    }

    func makeCornerRounded(_ component: UIView?) {
        if let view = component {
            view.layer.cornerRadius = view.frame.size.width / 2
        }
    }

    func changeButtonState(forButton button: UIButton, withStatus status: Bool) {
        button.isEnabled = status
        button.alpha = status ? 1.0 : 0.5
    }

    func playerWinAnimation(_ player: Int) {
        self.animationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.animatePlayer(_:)), userInfo: player, repeats: true)
    }

    @objc func animatePlayer(_ timer: Timer) {
        if let player = timer.userInfo as? Int {
            if player == 0 {
                self.playerOneCard.backgroundColor = UIColor.green
            } else if player == 1 {
                self.playerTwoCard.backgroundColor = UIColor.green
            }
            self.playerWinAnimationFade(player)
        }
    }

    func playerWinAnimationFade(_ player: Int) {
        self.animationTimerFade = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.animatePlayerFade(_:)), userInfo: player, repeats: false)
    }

    @objc func animatePlayerFade(_ timer: Timer) {
        if let player = timer.userInfo as? Int {
            if player == 0 {
                self.playerOneCard.backgroundColor = UIColor.white
            } else if player == 1 {
                self.playerTwoCard.backgroundColor = UIColor.white
            }
        }
    }
}
