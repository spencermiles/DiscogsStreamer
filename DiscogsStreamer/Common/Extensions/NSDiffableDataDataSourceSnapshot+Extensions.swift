import UIKit

extension NSDiffableDataSourceSnapshot {
    func itemIdentifier(at indexPath: IndexPath) -> ItemIdentifierType {
        itemIdentifiers(inSection: sectionIdentifiers[indexPath.section])[indexPath.row]
    }
}
