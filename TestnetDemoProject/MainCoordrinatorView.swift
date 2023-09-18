import SwiftUI

struct MainCoordrinatorView: View {
    @ObservedObject var coordinator: MainCoordinator
    
    var body: some View {
        switch coordinator.state {
        case .loading:
            Text("Loading...")
        case .createWallet:
            CreateWalletView(coordinator: coordinator)
        case .walletOverview:
            WalletOverviewView(walletViewModel: coordinator.walletViewModel)
        case .send:
            SendView(walletViewModel: coordinator.walletViewModel)
        case .error(let description):
            ErrorView(coordinator: coordinator, errorText: description)
        }
    }
}
