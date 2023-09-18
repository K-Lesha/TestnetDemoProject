import SwiftUI

struct ErrorView: View {
    
    var coordinator: MainCoordinator
    var errorText: String

    var body: some View {
        
        Text(errorText)
        
        Button(action: {
            coordinator.logout()
        }) {
            HStack {
                Text("back to login")
            }
        }
        
        Button(action: {
            coordinator.showOverview()
        }) {
            HStack {
                Text("back to walet overview")
            }
        }
    }
}

