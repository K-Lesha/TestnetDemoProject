import Foundation

enum AppState {
    case loading
    case createWallet
    case walletOverview
    case send
    case error(description: String)
}

class MainCoordinator: ObservableObject {
    
    @Published var state: AppState = .loading
    var walletViewModel: WalletViewModel = .init()
        
    init() {
        tryToRestroreLoginData()
    }
    
    func tryToRestroreLoginData() {
        if let mnemonic = UserDefaults.standard.string(forKey: Keys.mnemonicKey),
        let password = UserDefaults.standard.string(forKey: Keys.passwordKey) {
            login(mnemonic: mnemonic, password: password)
        } else {
            state = .createWallet
        }
    }
    
    func login(mnemonic: String, password: String) {
        save(mnemonic: mnemonic, password: password)
        walletViewModel.start(mnemonic: mnemonic, password: password)
        walletViewModel.coordinator = self
        state = .walletOverview
    }
    private func save(mnemonic: String, password: String) {
        UserDefaults.standard.set(mnemonic, forKey: Keys.mnemonicKey)
        UserDefaults.standard.set(password, forKey: Keys.passwordKey)
        UserDefaults.standard.synchronize()
    }
    
    func showOverview() {
        state = .walletOverview
    }
    
    func showSendView() {
        state = .send
    }
    
    func setErrorView(description: String) {
        state = .error(description: description)
    }
    
    func logout() {
        UserDefaults.standard.set(nil, forKey: Keys.mnemonicKey)
        UserDefaults.standard.set(nil, forKey: Keys.passwordKey)
        state = .createWallet
    }
}
