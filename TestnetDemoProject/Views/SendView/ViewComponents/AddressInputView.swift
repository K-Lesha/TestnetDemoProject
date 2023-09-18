import SwiftUI

struct AddressInputView: View {
    @Binding var address: String
    @ObservedObject var viewModel: WalletViewModel
    
    var body: some View {
        VStack {
            Text("Recipient Address:")
                .font(.headline)
                .fontWeight(.bold)
            
            TextField("Enter recipient address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}
