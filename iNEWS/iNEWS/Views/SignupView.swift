//
//  SignUpView.swift
//  iNEWS
//
//  Created by Darpon Chakma on 28/9/23.
//

import SwiftUI
import FirebaseAuth


struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmpassword: String = ""
    @State private var isPasswordVisible = false
    @State private var isPasswordVisible2 = false
    @AppStorage("uid") var userID: String = ""
    @Binding var currentShowingView: String
    @State private var showToast = false // Add state variable for toast message
    @State private var loginSuccess = false
    @State private var flag: Bool  = false
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: -5) {
                HStack {
                    Text("Create an Account!")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack {
                    Image(systemName: "mail").foregroundColor(.white)
                    TextField("Email", text: $email).foregroundColor(.white)
                    
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
                        .foregroundColor(.white)
                    
                )
                
                .padding()
                
                
                HStack {
                    Image(systemName: "lock").foregroundColor(.white)
                                if isPasswordVisible {
                                    TextField("Password", text: $password).foregroundColor(.white)
                                } else {
                                    SecureField("Password", text: $password).foregroundColor(.white)
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
                                        .foregroundColor(.white)
                                }
                            }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    
                )
                
                .padding()
                
                
                HStack {
                    Image(systemName: "lock").foregroundColor(.white)
                                if isPasswordVisible2 {
                                    TextField("Confirm Password", text: $confirmpassword).foregroundColor(.white)
                                } else {
                                    SecureField("Confirm Password", text: $confirmpassword).foregroundColor(.white)
                                }
                                
                                Spacer()
                                
                    if(confirmpassword.count < 6 && confirmpassword.count >= 1) {
                                            
                                            Image(systemName: "xmark")
                                                .fontWeight(.bold)
                                                .foregroundColor(.red)
                                        }
                    else if(confirmpassword.count != 0 && confirmpassword.count >= 6){
                        Image(systemName: "checkmark")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                                Button(action: {
                                    isPasswordVisible2.toggle() // Toggle visibility when the button is pressed
                                }) {
                                    Image(systemName: isPasswordVisible2 ? "eye.slash" : "eye")
                                        .foregroundColor(.white)
                                }
                            }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                    
                )
                
                .padding()
                Spacer().frame(height: 30)
                
              
                    Button(action: {
                        withAnimation {
                            self.currentShowingView = "login"
                        }
                    }) {
                        Text("Already have an account?")
                            //.foregroundColor(.black.opacity(0.7))
                            .underline().foregroundColor(.white)
                    }
                
                
                Spacer()
                Spacer()
                
                
                Button {
                    
                    if(confirmpassword != password || password.count < 6){
                        flag = true
                        showToast = true
                        
                    }else{
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                           
                           if let error = error {
                               print(error)
                               showToast = true
                               loginSuccess = false
                               return
                           }
                           
                           if let authResult = authResult {
                               print(authResult.user.uid)
                               userID = authResult.user.uid
                               
                           }
                            showToast = true
                            loginSuccess = true
                       }
                    }
                     
                    
                } label: {
                    Text("Create New Account")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                    
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
                
                
            }
            
            if showToast {
                            if loginSuccess {
                                ToastMessageView(message: "Account created successfully", isShowing: $showToast)
                            } else {
                                if !flag {
                                    ToastMessageView(message: "Something went wrong", isShowing: $showToast)
                                }else {
                                    ToastMessageView(message: "Passwords don't match", isShowing: $showToast)
                                }
                                
                            }
                        }
            
        }
        
     
    }
}
