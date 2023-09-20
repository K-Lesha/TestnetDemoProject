import Foundation

enum WalletError: Error {
    case missingWalletOrBlockchain
    case transactionSumIsTooBig
    case sumIsTooSmall
}

extension WalletError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingWalletOrBlockchain:
            return NSLocalizedString("The wallet or blockchain is missing.", comment: "Missing Wallet or Blockchain Error")
        case .transactionSumIsTooBig:
            return NSLocalizedString("The transaction sum is too large.", comment: "Transaction Sum Too Big Error")
        case .sumIsTooSmall:
            return NSLocalizedString("The sum is too small.", comment: "Sum Too Small Error")
        }
    }
}
