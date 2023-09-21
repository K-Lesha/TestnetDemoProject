import SwiftUI

struct CreateWalletView: View {
    var coordinator: MainCoordinator

    @State var mnemonicText: String = "keep item toward warrior trumpet tonight slim swear crash surround shoe erosion"
    @State var passwordText: String = "somePass123##22123fsd"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Mnemonic:")
                .font(.headline)
                .fontWeight(.bold)
            
            TextField("Enter your mnemonic", text: $mnemonicText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Password:")
                .font(.headline)
                .fontWeight(.bold)
            
            TextField("Enter your password", text: $passwordText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                Task {
                    await coordinator.login(mnemonic: mnemonicText, password: passwordText)
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding()
    }
}
