import XCTest

extension XCTestCase {
    func waitForDelay(_ delay: TimeInterval) {
        let expectation = self.expectation(description: "expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: delay + 1)
    }

    /// Waits for already-scheduled main thread work to be completed before continuing with the test.
    func waitForNextLoop() {
        let done = self.expectation(description: "done")
        DispatchQueue.main.async {
            done.fulfill()
        }
        wait(for: [done], timeout: 1)
    }
}
