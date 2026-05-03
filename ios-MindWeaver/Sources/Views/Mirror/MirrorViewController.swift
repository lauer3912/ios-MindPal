import UIKit

class MirrorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#0F0F14")
        title = "Mirror"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
