import SwiftUI

struct BackButton: View {
    @ObservedObject var viewModel: WalletViewModel

    var body: some View {
        Button(action: {
            viewModel.showOverview()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Spacer()
            }
        }
    }
}
