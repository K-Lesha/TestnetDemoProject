import SwiftUI
import Foundation

class WalletViewModel: ObservableObject {
    var coordinator: MainCoordinator?
    
    private var walletManager = WalletManager()

    @Published private(set) var address: String = "refreshing..."
    @Published private(set) var balanceText = "refreshing..."
    
    
    func start(mnemonic: String, password: String) async {
        do {
            try walletManager.start(mnemonic: mnemonic, password: password)
            await refresh()
            fetchTheAdress()
        } catch let error {
            self.coordinator?.setErrorView(description: "can't fetch a wallet: \(error)")
        }
    }
    
    func refresh() async {
        setBalanceText("refreshing...")
        do {
            let newBalance = try await walletManager.refresh()
            setBalanceText(newBalance)
        } catch {
            setBalanceText("try to refresh it later")
        }
    }
    
    func setBalanceText(_ balanceText: String) {
        DispatchQueue.main.async {
            self.balanceText = balanceText
        }
    }
    
    func fetchTheAdress() {
        DispatchQueue.main.async {
            self.address = self.walletManager.address
        }
    }
    
    func send(to recipient: String, bitcoinAmount: Double) throws -> String {
        try walletManager.send(to: recipient, bitcoinAmount: bitcoinAmount)
    }
    func showSendScreen() {
        coordinator?.showSendView()
    }
    
    func showOverview() {
        coordinator?.showOverview()
    }
    
    func logout() {
        coordinator?.logout()
    }
}
