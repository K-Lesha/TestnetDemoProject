import SwiftUI

struct ActionButtonsView: View {
    let refreshAction: () async -> ()
    var sendAction: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                Task {
                    await refreshAction()
                }
            } label: {
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
