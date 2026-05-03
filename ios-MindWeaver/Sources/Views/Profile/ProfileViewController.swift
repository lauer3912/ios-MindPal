import UIKit

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0F0F14")
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
