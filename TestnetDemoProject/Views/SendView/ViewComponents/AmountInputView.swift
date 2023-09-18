import SwiftUI

struct AmountInputView: View {
    @Binding var amountText: String
    @ObservedObject var viewModel: WalletViewModel
    
    var body: some View {
        VStack {
            Text("Send Amount:")
                .font(.headline)
                .fontWeight(.bold)
            
            TextField("Enter send amount", text: $amountText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.decimalPad)
        }
    }
}
