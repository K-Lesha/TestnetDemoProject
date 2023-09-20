import SwiftUI
import BitcoinDevKit

struct SendButtonView: View {
    @ObservedObject var viewModel: WalletViewModel

    @Binding var recipientAddress: String
    @Binding var sendAmountText: String
    @Binding var transactionHash: String?
    
    @State var alertText: String = ""
    @State private var showAlert = false
    
    var body: some View {
        Button(action: {
            tryToSend()
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
        
        viewModel.send(to: recipientAddress, bitcoinAmount: bitcoinAmount) { result in
            switch result {
            case .success(let txid):
                transactionHash = txid
                recipientAddress = ""
                sendAmountText = ""
            case .failure(let error):
                var errorMessage = error.localizedDescription
                
                if let bdkError = error as? BdkError {
                    switch bdkError {
                    case .InvalidU32Bytes(let message),
                            .Generic(let message),
                            .Rpc(let message),
                            .OutputBelowDustLimit(let message),
                            .InsufficientFunds(message: let message):
                        errorMessage = message
                    default:
                        errorMessage = bdkError.localizedDescription
                    }
                }
                
                alertText = errorMessage
                showAlert = true
            }
        }
    }
}
