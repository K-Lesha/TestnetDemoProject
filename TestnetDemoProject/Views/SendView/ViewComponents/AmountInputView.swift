import SwiftUI
import Combine

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
                .onReceive(Just(amountText)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.amountText = filtered
                    }
                }
        }
    }
}
