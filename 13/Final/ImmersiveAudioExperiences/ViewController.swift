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

final class ViewController: UIViewController {
  
  // MARK: - Properties
  private let sceneView: ARSCNView = {
    let sceneView = ARSCNView()
    sceneView.translatesAutoresizingMaskIntoConstraints = false
    sceneView.automaticallyUpdatesLighting = true
    return sceneView
  }()
  
  private let audioSource: SCNAudioSource = {
    let fileName = "Lion-mono.mp3"
    guard let audioSource = SCNAudioSource(fileNamed: fileName)
      else { fatalError("\(fileName) can not be found.") }
    audioSource.loops = true
    audioSource.load()
    return audioSource
  }()
  
  private let lionNode: SCNNode = {
    guard let scene = SCNScene(named: "Lion.scn"),
      let node = scene.rootNode.childNode(
        withName: "Lion", recursively: false)
      else { fatalError("Lion node could not be found.") }
    return node
  }()
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSceneView()
    setupSceneViewCamera()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    resetTrackingConfiguration()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }
  
  // MARK: - Scene View
  private func setupSceneView() {
    sceneView.delegate = self
    view.addSubview(sceneView)
    NSLayoutConstraint.activate(
      [sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
       sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
       sceneView.topAnchor.constraint(equalTo: view.topAnchor),
       sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
  }
  
  // MARK: - Tracking Configuration
  private func resetTrackingConfiguration() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    sceneView.session.run(configuration, options: [.resetTracking,
                                                   .removeExistingAnchors])
  }
  
  private func turnOffPlaneDetectionTracking() {
    let configuration = ARWorldTrackingConfiguration()
    sceneView.session.run(configuration, options: [])
  }
  
  // MARK: - Camera
  private func setupSceneViewCamera() {
    guard let camera = sceneView.pointOfView?.camera else { return }
    camera.wantsHDR = true
  }
  
  // MARK: - Audio
  private func addAudioSource() {
    lionNode.removeAllAudioPlayers()
    lionNode.addAudioPlayer(SCNAudioPlayer(source: audioSource))
  }
  
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    node.addChildNode(lionNode)
    addAudioSource()
    turnOffPlaneDetectionTracking()
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    resetTrackingConfiguration()
  }
}