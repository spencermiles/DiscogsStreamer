import UIKit

extension UIView {
    /// Sets a view's `translatesAutoresizingMaskIntoConstraints` to false prior to adding the view as a subview.
    func addAutoLayoutSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}
