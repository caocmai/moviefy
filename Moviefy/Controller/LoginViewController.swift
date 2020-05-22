//
//  LoginViewController.swift
//  Moviefy
//
//  Created by Cao Mai on 5/4/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import UIKit
import AuthenticationServices


class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {
    @IBOutlet weak var logInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        APIClient.shared.createRequestToken { (result) in
            switch result{
            case let .success(token):
                DispatchQueue.main.async {
                    print(token.request_token)
                    self.authorizeRequestToken(from: self, requestToken: token.request_token)
                }
            case let .failure(error):
                print(error)
            }
        }
        
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizeRequestToken(from viewController: UIViewController, requestToken: String) {
        let url = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=moviefy://auth")!
        // Use the URL and callback scheme specified by the authorization provider.
        guard let authURL = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)?redirect_to=moviefy://auth") else { return }
        let scheme = "auth"
        // Initialize the session using the class from AuthenticationServices
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { callbackURL, error in
            // Handle the callback.
            guard error == nil, let callbackURL = callbackURL else { return }
            
            // The callback URL format depends on the provider.
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
//            print(queryItems)
            guard let requestToken = queryItems?.first(where: { $0.name == "request_token" })?.value else { return }
            let approved = (queryItems?.first(where: { $0.name == "approved" })?.value == "true")
            
            print("Request token \(requestToken) \(approved ? "was" : "was NOT") approved")
            
            self.startSession(requestToken: requestToken) { success in
                print("Session started")
                
            }
        }
        session.presentationContextProvider = self
        session.start()
    }
    
    func startSession(requestToken: String, completion: @escaping (Bool) -> Void) {
        APIClient.shared.createSession(requestToken: requestToken) { (result) in
            switch result{
            case let .success(session):
                DispatchQueue.main.async {
//                    print(session.session_id)
                    self.getUsername(from: session.session_id)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getUsername(from sessionID: String){
        APIClient.shared.getAccount(sessionID: sessionID) { (result) in
            switch result{
            case let .success(userObject):
                DispatchQueue.main.async {
                    self.logInLabel.text = "Login As: \(userObject.username!)"
                }
            case let .failure(error):
                print(error)
            }
        }
        
    }
}
