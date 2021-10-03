//
//  LoginViewController.swift
//  TrainingRecord
//
//  Created by 邱宣策 on 2021/8/4.
//

import UIKit
import Firebase
import AuthenticationServices
import CryptoKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
class MemberLoginViewController: UIViewController, UITextFieldDelegate, LoginButtonDelegate, UIGestureRecognizerDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            mbProgress(false)
            return
          }
        mbProgress(true)
        guard let token = AccessToken.current?.tokenString else {
            mbProgress(false)
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: .ProfileDidChange, object: nil)
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                let loginManager = LoginManager()
                loginManager.logOut()
                self.mbProgress(false)
                return
            }
            // User is signed in
            // ...
            self.mbProgress(false)
            let loginMethod = "FaceBook"
            UserDefaults.standard.setValue(loginMethod, forKey: "loginMethod")
            UserDefaults.standard.synchronize()
            MemberUserDataToFirestore.share.createUserDocument()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn") as? MemberAlreadyLoginViewController
            self.navigationController?.pushViewController(vc!,animated: true)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        mbProgress(false)
    }
    
    @objc func updateProfile(){
        //更新大頭貼
        if let profile = Profile.current {
            print(profile.userID)
           print(profile.name)
        
        }
    }
    
    var userName: String?
    
    @IBOutlet weak var memberEmailTextView: UITextField!
    @IBOutlet weak var memberPasswordTextView: UITextField!
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberEmailTextView.delegate = self
        memberPasswordTextView.delegate = self
        // Do any additional setup after loading the view.
        setupSignInButton()
        dismissOnTap()
    }
    func dismissOnTap() {
            self.view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.delegate = self
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
     }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is GIDSignInButton || touch.view is ASAuthorizationAppleIDButton {
                return false
            }
            return true
        }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var appleLogInBtn: ASAuthorizationAppleIDButton!
    @IBOutlet weak var googleLogInBtn: GIDSignInButton!
    @IBOutlet weak var fbLogInBtn: FBLoginButton!
    
    func setupSignInButton(){
        appleLogInBtn.addTarget(self, action: #selector(handleSignInWithAppleTapped), for: .touchUpInside)
        appleLogInBtn.backgroundColor = .black
        appleLogInBtn.cornerRadius = 0
        googleLogInBtn.addTarget(self, action: #selector(googleSignInBtnPressed), for: .touchUpInside)
        fbLogInBtn.permissions = ["public_profile", "email"]
        fbLogInBtn.delegate = self
    }
    
    @objc func handleSignInWithAppleTapped(){
        mbProgress(true)
        print("good")
        performSignIn()
    }
    
    func performSignIn() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest{
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
       @objc func googleSignInBtnPressed(_ sender: Any) {
        mbProgress(true)
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                mbProgress(false)
                return }
    
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
    
            // Start the sign in flow!
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
    
              if let error = error {
                mbProgress(false)
                return
              }
    
              guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
              else {
                mbProgress(false)
                return
              }
    
              let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: authentication.accessToken)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("error = \(error.localizedDescription)")
                        self.mbProgress(false)
                      return
                    }
                    // User is signed in
                    // ...
                    let loginMethod = "Google"
                    UserDefaults.standard.setValue(loginMethod, forKey: "loginMethod")
                    UserDefaults.standard.synchronize()
                    self.mbProgress(false)
                    MemberUserDataToFirestore.share.createUserDocument()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn") as? MemberAlreadyLoginViewController
                    self.navigationController?.pushViewController(vc!,animated: true)
                }        }
        }
    
    @IBAction func LogInBtnPressed(_ sender: Any) {
        if memberEmailTextView.text == "" || memberPasswordTextView.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            
            } else {
                Auth.auth().signIn(withEmail: memberEmailTextView.text!, password: memberPasswordTextView.text!) { [self] result, error in
                    if let e = error {
                        print( "error \(e)")
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        return
                    }
                    var zz = false
                    let userc = Auth.auth().currentUser
                    if let user = userc {
//                        print(user.displayName)
                        if user.isEmailVerified {
                        DispatchQueue.global().sync {
                            
                            self.userName = user.displayName ?? "精壯使用者"
                            if self.userName != nil {
                                zz = true
                            }
                            DispatchQueue.main.async {
                                if zz {
                                    MemberUserDataToFirestore.share.loadUserdatas()
                                    mbProgress(true)
                                goAlreadylogin()
                                }
                            }
                        }
                        }else{
                            Auth.auth().currentUser?.sendEmailVerification { error in
                            }
                            mbProgress(true)
                            TimerUse.share.setTimer(1, self, #selector(checkVeried), false, 1)
                        }
                        
                    }
                    
                }
        }
    }
    
    
    @objc func checkVeried(){
        TimerUse.share.stopTimer(1)
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        TimerUse.share.setTimer(1, self, #selector(cV), false, 1)
    }
    
    @objc func cV(){
        TimerUse.share.stopTimer(1)
        Auth.auth().signIn(withEmail: memberEmailTextView.text!, password: memberPasswordTextView.text!) { result, error in
            if let e = error {
                print( "error \(e)")
                return
            }
            
        }
        TimerUse.share.setTimer(1, self, #selector(checkVerified), false, 1)
    }
    
    @objc func checkVerified(){
        TimerUse.share.stopTimer(1)
        if let isemailverified = Auth.auth().currentUser?.isEmailVerified, isemailverified{
            let userc = Auth.auth().currentUser
            var zz = false
            if let user = userc {
                DispatchQueue.global().sync {
                    
                    self.userName = user.displayName!
                    if self.userName != nil {
                        zz = true
                    }
                    DispatchQueue.main.sync {
                        if zz {
                            MemberUserDataToFirestore.share.loadUserdatas()
                            UserDefaults.standard.setValue("email", forKey: "loginMethod")
                            UserDefaults.standard.synchronize()
                        goAlreadylogin()
                        }
                    }
                }
                }
        }else{
        TimerUse.share.setTimer(1, self, #selector(checkVeried), false, 1)
        }
    }
    
    func mbProgress(_ onoff: Bool){
        if onoff{
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    @IBAction func forgetPasswordBtnPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "注意", message: "請將您印象中的email填至帳號欄內後再按下確認，確認後重設密碼的郵件便會送出。", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "確認", style: .default) { (action) -> Void in
            if let email = self.memberEmailTextView.text {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
              // ...
            }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func goAlreadylogin(){
        mbProgress(false)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn") as? MemberAlreadyLoginViewController
        if let username = self.userName {
        vc?.userName = username
        }
        
        self.dismiss(animated: true)
        self.navigationController?.pushViewController(vc!,animated: true)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    
        // 不能輸入空白
        if string.isContainsSpaceCharacters() {
            return false
        }

        // 不能輸入中文字
        if string.isContainsChineseCharacters() {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == memberEmailTextView{
            memberPasswordTextView.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
            if memberEmailTextView.text != "" && memberPasswordTextView.text != ""{
                      LogInBtnPressed(self)
                  }
        }
        return true
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
// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}

extension MemberLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential{
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received")
        }
    
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            mbProgress(false)
            return
        }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string")
                mbProgress(false)
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { (authDataResult, error) in
                if let user = authDataResult?.user{
                    print("Nice! You're now signed in  as \(user.uid), email: \(user.email ?? "unknown")")
                    self.mbProgress(false)
                    let loginMethod = "Apple"
                    UserDefaults.standard.setValue(loginMethod, forKey: "loginMethod")
                    UserDefaults.standard.synchronize()
                    MemberUserDataToFirestore.share.createUserDocument()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoggedIn") as? MemberAlreadyLoginViewController
                    self.navigationController?.pushViewController(vc!,animated: true)
                }
            }
    
    }
        
}
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        mbProgress(false)
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
    
}

// Unhashed nonce.
fileprivate var currentNonce: String?

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
  let inputData = Data(input.utf8)
  let hashedData = SHA256.hash(data: inputData)
  let hashString = hashedData.compactMap {
    return String(format: "%02x", $0)
  }.joined()

  return hashString
}
