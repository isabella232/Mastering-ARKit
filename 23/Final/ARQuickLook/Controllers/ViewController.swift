/// Copyright (c) 2021 Jayven Nhan
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import ARKit
import RealityKit

final class ViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var stackView: UIStackView!

  // MARK: - Stored Properties
  private let quickLookPreviewController = QLPreviewController()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupQuickLookPreviewController()
  }

  // MARK: - Initial setup
  private func setupQuickLookPreviewController() {
    quickLookPreviewController.dataSource = self
    quickLookPreviewController.delegate = self
  }

  // MARK: - IBActions
  @IBAction func previewARContentButtonDidTap(_ sender: UIButton) {
    present(quickLookPreviewController, animated: true, completion: nil)
  }
}

// MARK: - QLPreviewControllerDataSource
extension ViewController: QLPreviewControllerDataSource {
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    return 1
  }

  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    let resourceName = "gramophone"
    let resourceExtension = "usdz"
    guard let previewItemURL = Bundle.main.url(
            forResource: resourceName,
            withExtension: resourceExtension) else {
      fatalError("Unable to locate \(resourceName).\(resourceExtension)")
    }
    let previewItem = ARQuickLookPreviewItem(fileAt: previewItemURL)
    guard #available(iOS 13.0, *) else {
      return previewItem as QLPreviewItem
    }
    guard let canonicalWebPageURL = URL(string: "https://www.appcoda.com") else {
      fatalError("Unable to construct canonical web page URL.")
    }
    previewItem.canonicalWebPageURL = canonicalWebPageURL
    previewItem.allowsContentScaling = false
    return previewItem
  }
}

// MARK: - QLPreviewControllerDelegate
extension ViewController: QLPreviewControllerDelegate {
  func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
    return stackView
  }
}
