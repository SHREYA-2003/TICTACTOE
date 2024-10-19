import UIKit

class ViewController: UIViewController {
    enum GameMode {
        case humanVsHuman
        case humanVsAI
    }
    var gameMode: GameMode = .humanVsHuman

   
    enum Turn{
        case cross
        case nought
    }
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    var firstTurn = Turn.cross
    var currentTurn = Turn.cross
    
    var CROSS = "X"
    var NOUGHT = "O"
    var board = [UIButton]()
    var noughtScore = 0
    var crossScore = 0
    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)
        if checkForVictory(CROSS){
            crossScore += 1
            resultAlert(title: "Cross wins")
           
        }
        if checkForVictory(NOUGHT){
            noughtScore += 1
            resultAlert(title: "Nought wins")
        }
        if(fullBoard()){
            resultAlert(title: "Draw")
        }
        if gameMode == .humanVsAI && currentTurn == Turn.cross {
                    aiMove()
                }
    }
    
    func checkForVictory(_ s : String) -> Bool{
        //horizontal victory
        if thisSymbol(a1, s) && thisSymbol(a2, s)  && thisSymbol(a3, s){
            return true
        }
        if thisSymbol(b1, s) && thisSymbol(b2, s)  && thisSymbol(b3, s){
            return true
        }
        if thisSymbol(c1, s) && thisSymbol(c2, s)  && thisSymbol(c3, s){
            return true
        }
        
        //vertical victory
        if thisSymbol(a1, s) && thisSymbol(b1, s)  && thisSymbol(c1, s){
            return true
        }
        if thisSymbol(a2, s) && thisSymbol(b2, s)  && thisSymbol(c2, s){
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b3, s)  && thisSymbol(c3, s){
            return true
        }
        //diagonal victory
        if thisSymbol(a1, s) && thisSymbol(b2, s)  && thisSymbol(c3, s){
            return true
        }
        if thisSymbol(a3, s) && thisSymbol(b2, s)  && thisSymbol(c1, s){
            return true
        }
        
        return false
    }
    
    func thisSymbol (_ button: UIButton , _ symbol: String)-> Bool{
        return button.title(for: .normal) == symbol
    }
    func resultAlert(title: String){
        let message = "\nNoughts " + String(noughtScore) + "\n\nCross" + String(crossScore)
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: {(_)in self.resetBoard()
            
        }))
        self.present(ac, animated:  true)
    }
    func resetBoard(){
        for button in board{
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if (firstTurn == Turn.nought){
            firstTurn = Turn.cross
            turnLabel.text = CROSS
        }
       else if (firstTurn == Turn.cross){
            firstTurn = Turn.nought
            turnLabel.text = NOUGHT
        }
    }
    func fullBoard() -> Bool{
        for button in board
        {
            if button.title(for: .normal) == nil
            {
                return false
            }
        }
        return true
    }
    func addToBoard(_ sender: UIButton) {
        if sender.title(for: .normal) == nil {
            if currentTurn == Turn.nought {
                sender.setTitle(NOUGHT, for: .normal)
                currentTurn = (gameMode == .humanVsAI) ? Turn.cross : Turn.nought
                currentTurn = Turn.cross
                turnLabel.text = CROSS
            } else if currentTurn == Turn.cross {
                sender.setTitle(CROSS, for: .normal)
                currentTurn = Turn.nought
                turnLabel.text = NOUGHT
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBoard()
        // Do any additional setup after loading the view.
        func initBoard(){
            board.append(a1)
            board.append(a2)
            board.append(a3)
            board.append(b1)
            board.append(b2)
            board.append(b3)
            board.append(c1)
            board.append(c2)
            board.append(c3)
        }
    }
    
    func aiMove() {
           var availableButtons = board.filter { $0.title(for: .normal) == nil }
           
           if let buttonToPress = availableButtons.randomElement() {
               addToBoard(buttonToPress)
               
               // Check for victory after AI's move
               if checkForVictory(CROSS) {
                   crossScore += 1
                   resultAlert(title: "Cross wins")
               } else if fullBoard() {
                   resultAlert(title: "Draw")
               }
           }
       }

    @IBAction func humanVsHuman(_ sender: Any) {
        gameMode = .humanVsHuman
        resetBoard()
    }
    @IBAction func humanVsAI(_ sender: Any) {
        gameMode = .humanVsAI
        resetBoard()
    }
}
