//
//  LoginView.swift
//  MyAudible
//
//  Created by Keanu Interone on 2/16/20.
//  Copyright © 2020 Keanu Interone. All rights reserved.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @State var goToHome = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(destination: ContentView(), isActive: self.$goToHome) {
                    Text("")
                }.hidden()
                Form {
                    TextField("Email", text: self.$email).autocapitalization(.none)
                    SecureField("Password", text: self.$password)
                }
                Button(action: signIn) {
                  Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
                }
            }
            
        }
    }
    
    func signIn() {
        print(self.$email.wrappedValue)
        let email = self.$email.wrappedValue
        let password = self.$password.wrappedValue
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = authResult?.user {
                print(user.email ?? "something")
                self.goToHome = true;
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
