import Combine
import Foundation
import UIKit

/// This protocol defines the phases of view construction.
///
/// When conforming to this protocol, implement the construction phaeses and call `construct()` immediately after
/// `super.init()`.
protocol ViewConstructable {
    /// Initializes the properties of this view.
    ///
    /// **Do not call this method directly.** Conforming types should trigger this method by calling `construct()`.
    func constructView()

    /// Assembles the subviews into the correct hierarchy.
    ///
    /// **Do not call this method directly.** Conforming types should trigger this method by calling `construct()`.
    func constructSubviewHierarchy()

    /// Adds constraints to lay out the subviews.
    ///
    /// **Do not call this method directly.** Conforming types should trigger this method by calling `construct()`.
    func constructSubviewLayoutConstraints()
}

extension ViewConstructable {
    func construct() {
        constructView()
        constructSubviewHierarchy()
        constructSubviewLayoutConstraints()
    }

    // Note: Do not add default implementations of the `constructX()` methods. Default implementations are not
    // compatible with subclassing.
}

class BaseView: UIView, ViewConstructable {

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        construct()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("not implemented") }

    // MARK: Construction

    func constructView() {
        // No-op: implement in subclass
    }

    func constructSubviewHierarchy() {
        // No-op: implement in subclass
    }

    func constructSubviewLayoutConstraints() {
        // No-op: implement in subclass
    }

    /// MARK: - Handling View Removal Subscriptions

    let removeFromSuperviewPublisher = PassthroughSubject<Void, Never>()

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        guard superview != nil,
            newSuperview == nil
            else {
                return
        }

        removeFromSuperviewPublisher.send(())
    }
}

class BaseTableViewCell: UITableViewCell, ViewConstructable {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        construct()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("not implemented") }

    // MARK: Construction

    func constructView() {
        // No-op: implement in subclass
    }

    func constructSubviewHierarchy() {
        // No-op: implement in subclass
    }

    func constructSubviewLayoutConstraints() {
        // No-op: implement in subclass
    }
}
