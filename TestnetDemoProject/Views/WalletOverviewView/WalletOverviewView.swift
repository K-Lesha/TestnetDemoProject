import SwiftUI

struct WalletOverviewView: View {
    @ObservedObject var walletViewModel: WalletViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            LogoutButton(action: walletViewModel.logout)
            
            Spacer ()
            
            AddressView(address: walletViewModel.address)
            
            BalanceView(balanceText: walletViewModel.balanceText)
            
            ActionButtonsView(refreshAction: walletViewModel.refresh, sendAction: walletViewModel.showSendScreen)
            
            Spacer ()

        }
        .padding()
    }
}


