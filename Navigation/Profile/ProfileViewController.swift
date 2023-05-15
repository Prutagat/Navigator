
import UIKit

class ProfileViewController: UIViewController {
    
    let profileHeaderView = Bundle.main.loadNibNamed(
        "ProfileHeaderView",
        owner: nil
    )? .first as? UIView
    
    override func viewWillLayoutSubviews() {
        profileHeaderView!.frame = view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        view.addSubview(profileHeaderView!)
    }

}
