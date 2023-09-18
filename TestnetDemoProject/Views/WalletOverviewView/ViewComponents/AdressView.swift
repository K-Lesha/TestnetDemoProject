import SwiftUI

struct AddressView: View {
    var address: String
    
    var body: some View {
        VStack {
            Text("Wallet Address:")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(address)
                .font(.body)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = address
                    } label: {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                }
        }
    }
}
