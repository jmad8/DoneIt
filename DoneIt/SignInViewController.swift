import UIKit
import FirebaseAuth
import FBSDKLoginKit
import Firebase

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: CustomButton!
    @IBOutlet weak var btnCreateAccount: CustomButton!
    @IBOutlet weak var btnGoogleLogin: GIDSignInButton!
    @IBOutlet weak var btnFacebookLogin: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        btnGoogleLogin.colorScheme = GIDSignInButtonColorScheme.light
    }
    
    @IBAction func createClicked(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
        }
    }
}
