struct WalletCodable: Codable {
    let address: String
    let totalReceived: Int
    let totalSent: Int
    let balance: Int
    let unconfirmedBalance: Int
    let finalBalance: Int
    let nTx: Int
    let unconfirmedNTx: Int
    let finalNTx: Int
    let txUrl: String
    
    enum CodingKeys: String, CodingKey {
        case address
        case totalReceived = "total_received"
        case totalSent = "total_sent"
        case balance
        case unconfirmedBalance = "unconfirmed_balance"
        case finalBalance = "final_balance"
        case nTx = "n_tx"
        case unconfirmedNTx = "unconfirmed_n_tx"
        case finalNTx = "final_n_tx"
        case txUrl = "tx_url"
    }
}
