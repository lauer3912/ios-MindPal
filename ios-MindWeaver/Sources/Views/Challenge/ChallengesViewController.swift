import UIKit

class ChallengesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0F0F14")
        title = "Challenges"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
