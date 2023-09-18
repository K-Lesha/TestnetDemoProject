import SwiftUI

struct SendButtonView: View {
    @ObservedObject var viewModel: WalletViewModel

    @Binding var recipientAddress: String
    @Binding var sendAmountText: String
    @Binding var transactionHash: String?
    
    @State var alertText: String = ""
    @State private var showAlert = false
    
    var body: some View {
        Button(action: {
            viewModel.isValidBitcoinAddress(recipientAddress) { result in
                switch result {
                case .success(_):
                    tryToSend()
                case .failure(let error):
                    alertText = error.localizedDescription
                    showAlert = true
                }
            }
        }) {
            Text("Send")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .alert(isPresented: $showAlert) {
              Alert(
                  title: Text("Error"),
                  message: Text(alertText),
                  dismissButton: .default(Text("OK"))
              )
          }
    }
    
    func tryToSend() {
        
        let bitcoinAmount: Double = Double(sendAmountText) ?? 0
        let satoshis = UInt64(bitcoinAmount * 100_000_000)
        print(satoshis)

        
        viewModel.send(to: recipientAddress, amount: satoshis) { result in
            switch result {
            case .success(let txid):
                transactionHash = txid
                recipientAddress = ""
                sendAmountText = ""
            case .failure(let error):
                alertText = error.localizedDescription
                showAlert = true
            }
        }
    }
}
