//
//  LoginView.swift
//  iNEWS
//
//  Created by Darpon Chakma on 28/9/23.
//

import SwiftUI
import FirebaseAuth

struct ToastMessageView: View {
    let message: String
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .padding(.top, 500)
        }
        .transition(.opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isShowing = false
                }
            }
        }
    }
}
struct LoginView: View {
    @Binding var currentShowingView: String
    @AppStorage("uid") var userID: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var showToast = false // Add state variable for toast message
    @State private var loginSuccess = false
    
   
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack (spacing: -5){
                HStack {
                    Text("Welcome to iNEWS!")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    
                    Spacer()
                    
                    
                    if(email.count != 0) {
                        
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                    
                )
                
                .padding()
                
                
                HStack {
                    Image(systemName: "lock")
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    
                    Spacer()
                    
                    if(password.count < 6 && password.count >= 1) {
                                            
                                            Image(systemName: "xmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(.red)
                                        }
                    else if(password.count != 0 && password.count >= 6){
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    Button(action: {
                        isPasswordVisible.toggle() // Toggle visibility when the button is pressed
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                    
                )
                .padding()
                
                Spacer().frame(height: 20)
                Button(action: {
                    withAnimation {
                        self.currentShowingView = "signup"
                    }
                    
                    
                }) {
                    Text("Don't have an account?")
                        //.foregroundColor(.black.opacity(0.7))
                        .underline().foregroundColor(.blue)
                }
                
                Spacer()
                Spacer()
                
                
                Button {
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print(error)
                            showToast = true
                            loginSuccess = false
                            return
                        }
                        
                        if let authResult = authResult {
                            print(authResult.user.uid)
                            showToast = true
                            loginSuccess = true
                            withAnimation {
                                userID = authResult.user.uid
                            }
                        }
                        
                        
                    }
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                        .padding(.horizontal)
                }
                
                
            }
            
            if showToast {
                            if loginSuccess {
                                ToastMessageView(message: "Login successful", isShowing: $showToast)
                            } else {
                                ToastMessageView(message: "Login failed! Incorrect Email or Password", isShowing: $showToast)
                            }
                        }
            
        }
    }
}
