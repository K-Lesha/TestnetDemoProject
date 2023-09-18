import SwiftUI
import Foundation
import BitcoinDevKit

class WalletViewModel: ObservableObject {
    var coordinator: MainCoordinator?
    
    private var wallet: Wallet? {
        didSet {
            DispatchQueue.main.async {
                self.setTheAdress()
                self.refresh()
            }
        }
    }
    private var blockchain: Blockchain?
    private var databaseConfig = DatabaseConfig.memory
    
    @Published private(set) var address: String = "refreshing..."
    private var balance: UInt64 = 0
    @Published private(set) var balanceText = "refreshing..."
    @Published private(set) var transactions: [BitcoinDevKit.TransactionDetails] = []
    
    func start(mnemonic: String, password: String) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            do {
                let mnemonik = try Mnemonic.fromString(mnemonic: mnemonic)
                let descriptorKey = DescriptorSecretKey(network: Network.testnet,
                                                        mnemonic: mnemonik,
                                                        password: password)
                let descriptor = Descriptor.newBip44(secretKey: descriptorKey,
                                                     keychain: .external,
                                                     network: .testnet)
                
                let electrum = ElectrumConfig(url: "ssl://electrum.blockstream.info:60002",
                                              socks5: nil,
                                              retry: 5,
                                              timeout: nil,
                                              stopGap: 10,
                                              validateDomain: true)
                
                let blockchainConfig = BlockchainConfig.electrum(config: electrum)
                blockchain = try Blockchain(config: blockchainConfig)
                wallet = try Wallet(descriptor: descriptor, changeDescriptor: nil, network: Network.testnet, databaseConfig: databaseConfig)
                
            } catch let error {
                DispatchQueue.main.async {
                    self.coordinator?.setErrorView(description: "can't fetch a wallet: \(error)")
                }
            }
        }
    }
    
    func refresh() {
        self.balanceText = "refreshing..."
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  let wallet,
                  let blockchain else {
                return
            }
            
            do {
                try wallet.sync(blockchain: blockchain, progress: nil)
                let balance = try wallet.getBalance().confirmed
                let wallet_transactions: [TransactionDetails] = try wallet.listTransactions(includeRaw: false)

                DispatchQueue.main.async {
                    self.balance = balance
                    self.balanceText = String(format: "%.8f", Double(self.balance) / Double(100000000))
                    self.transactions = wallet_transactions
                }
          } catch {
              self.balanceText = "try to refresh it later"
          }
        }
    }
    
    func send(to recipient: String, amount: UInt64, completion: @escaping (Result<String, Error>) -> Void) {
        guard let wallet, let blockchain else {
            completion(.failure(WalletError.missingWalletOrBlockchain))
            return
        }
        
        DispatchQueue.global().async {
            do {
                let address = try Address(address: recipient)
                let script = address.scriptPubkey()
                let txBuilder = TxBuilder().addRecipient(script: script, amount: amount)
                let details = try txBuilder.finish(wallet: wallet)
                let _ = try wallet.sign(psbt: details.psbt, signOptions: nil)
                let tx = details.psbt.extractTx()
                try blockchain.broadcast(transaction: tx)
                let txid = details.psbt.txid()
                self.refresh()
                completion(.success(txid))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func isValidBitcoinAddress(_ address: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let _ = try Address(address: address)
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func setTheAdress() {
        do {
            let addressInfo = try wallet?.getAddress(addressIndex: AddressIndex.lastUnused)
            address = addressInfo?.address.asString() ?? "sync to recieve an adress"
        } catch {
            address = "sync to recieve an adress"
        }
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