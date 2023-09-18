import Foundation
import BitcoinDevKit

extension TransactionDetails: Comparable {
    public static func < (lhs: TransactionDetails, rhs: TransactionDetails) -> Bool {
        
        let lhs_timestamp: UInt64 = lhs.confirmationTime?.timestamp ?? UInt64.max;
        let rhs_timestamp: UInt64 = rhs.confirmationTime?.timestamp ?? UInt64.max;
        
        return lhs_timestamp < rhs_timestamp
    }
}

extension TransactionDetails: Equatable {
    public static func == (lhs: TransactionDetails, rhs: TransactionDetails) -> Bool {
        
        let lhs_timestamp: UInt64 = lhs.confirmationTime?.timestamp ?? UInt64.max;
        let rhs_timestamp: UInt64 = rhs.confirmationTime?.timestamp ?? UInt64.max;
        
        return lhs_timestamp == rhs_timestamp
    }
}
