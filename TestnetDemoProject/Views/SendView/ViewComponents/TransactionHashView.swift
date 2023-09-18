import SwiftUI

struct TransactionHashView: View {
    var hash: String
    
    var body: some View {
        VStack {
            Text("Transaction Hash:")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(hash)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = hash
                    } label: {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                }
        }
        .padding()
    }
}

