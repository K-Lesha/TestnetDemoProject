import Foundation
import BitcoinDevKit

class WalletManager {
    
    private var wallet: Wallet? {
        didSet {
            self.setTheAdress()
        }
    }
    private var blockchain: Blockchain?
    private var databaseConfig = DatabaseConfig.memory
    private var balance: UInt64 = 0
    public var address = ""

    
    func start(mnemonic: String, password: String) throws {
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
    }
    
    func refresh() async throws -> String {
        guard let wallet,
              let blockchain else {
            throw WalletError.cantSyncBalance
        }
        do {
            try wallet.sync(blockchain: blockchain, progress: nil)
            self.balance = try wallet.getBalance().confirmed
            return try await stringBalance()
        } catch {
            throw WalletError.cantSyncBalance
        }
    }
    
    private func stringBalance() async throws -> String {
        let url = URL(string: "https://api.blockcypher.com/v1/btc/test3/addrs/\(address)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WalletCodable.self, from: data)
            return String(format: "%.8f", Double(decodedData.balance) / Double(100000000))
        } catch {
            throw WalletError.cantSyncBalance
        }
    }
    
    func send(to recipient: String, bitcoinAmount: Double) throws -> String {
        guard let wallet = self.wallet, let blockchain = self.blockchain else {
            throw WalletError.missingWalletOrBlockchain
        }
        
        guard bitcoinAmount > 0 else {
            throw WalletError.sumIsTooSmall
        }
        
        let address = try Address(address: recipient)
        let script = address.scriptPubkey()
        let satoshisAmount = UInt64(bitcoinAmount * 100_000_000)
        let txBuilder = TxBuilder().addRecipient(script: script, amount: satoshisAmount)
        let details = try txBuilder.finish(wallet: wallet)
        
        if let fee = details.transactionDetails.fee {
            if (fee + satoshisAmount) >= self.balance {
                throw WalletError.transactionSumIsTooBig
            }
        }
        
        let _ = try wallet.sign(psbt: details.psbt, signOptions: nil)
        let tx = details.psbt.extractTx()
        try blockchain.broadcast(transaction: tx)
        
        let txid = details.psbt.txid()
        return txid
    }

    func setTheAdress()  {
          do {
              let addressInfo = try wallet?.getAddress(addressIndex: AddressIndex.lastUnused)
              address = addressInfo?.address.asString() ?? "sync to recieve an adress"
          } catch {
              address = "sync to recieve an adress"
          }
      }
}
