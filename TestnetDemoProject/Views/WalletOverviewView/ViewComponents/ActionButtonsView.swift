import SwiftUI

struct ActionButtonsView: View {
    var refreshAction: () -> Void
    var sendAction: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: refreshAction) {
                Text("Refresh")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button(action: sendAction) {
                Text("Send")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
    }
}
