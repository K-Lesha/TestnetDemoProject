import SwiftUI

struct SendView: View {
    @ObservedObject var walletViewModel: WalletViewModel
    @State private var recipientAddress: String = ""
    @State private var sendAmountText: String = ""
    @State private var transactionHash: String?
    
    
    var body: some View {
        VStack(spacing: 20) {
            BackButton(viewModel: walletViewModel)
            
            Spacer()
            VStack {
                AddressInputView(address: $recipientAddress, viewModel: walletViewModel)
                
                AmountInputView(amountText: $sendAmountText, viewModel: walletViewModel)
                
                SendButtonView(
                    viewModel: walletViewModel,
                    recipientAddress: $recipientAddress,
                    sendAmountText: $sendAmountText,
                    transactionHash: $transactionHash
                )
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)

            Spacer()
            
            if let hash = transactionHash {
                TransactionHashView(hash: hash)
            }
            
            Spacer()

        }
        .padding()
        .cornerRadius(15)
    }
}
