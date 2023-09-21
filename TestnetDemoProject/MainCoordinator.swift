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
        Task {
            await tryToRestroreLoginData()
        }
    }
    
    func tryToRestroreLoginData() async {
        if let mnemonic = UserDefaults.standard.string(forKey: Keys.mnemonicKey),
        let password = UserDefaults.standard.string(forKey: Keys.passwordKey) {
            await login(mnemonic: mnemonic, password: password)
        } else {
            showCreateWallet()
        }
    }

    func showCreateWallet() {
        DispatchQueue.main.async {
            self.state = .createWallet
        }
    }
    
    func showOverview() {
        DispatchQueue.main.async {
            self.state = .walletOverview
        }
    }
    
    func showSendView() {
        DispatchQueue.main.async {
            self.state = .send
        }
    }
    
    func setErrorView(description: String) {
        DispatchQueue.main.async {
            self.state = .error(description: description)
        }
    }
    
    func login(mnemonic: String, password: String) async {
        save(mnemonic: mnemonic, password: password)
        await walletViewModel.start(mnemonic: mnemonic, password: password)
        walletViewModel.coordinator = self
        showOverview()
    }
    
    func logout() {
        UserDefaults.standard.set(nil, forKey: Keys.mnemonicKey)
        UserDefaults.standard.set(nil, forKey: Keys.passwordKey)
        showCreateWallet()
    }
    
    private func save(mnemonic: String, password: String) {
        UserDefaults.standard.set(mnemonic, forKey: Keys.mnemonicKey)
        UserDefaults.standard.set(password, forKey: Keys.passwordKey)
        UserDefaults.standard.synchronize()
    }
}
