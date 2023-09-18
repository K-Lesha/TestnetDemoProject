import SwiftUI

struct BalanceView: View {
    var balanceText: String
    
    var body: some View {
        VStack {
            Text("Balance:")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(balanceText)
                .font(.title)
        }
    }
}

