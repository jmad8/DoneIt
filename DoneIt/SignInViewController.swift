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
        
        btnGoogleLogin.colorScheme = GIDSignInButtonColorScheme.dark
    }
    
    @IBAction func createClicked(_ sender: Any) {
        FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if let error = error {
                self.show(error: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
        }
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: txtEmail.text!, password: txtPassword.text!) { (user, error) in
            if let error = error {
                self.show(error: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
        }
    }
    
    private func show(error: String) {
        
        let alert = UIAlertController(title: "Uh-Oh", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
