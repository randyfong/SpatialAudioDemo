//
//  ViewController.swift
//  SpatialAudioDemo
//
//  Created by Randy Fong on 4/16/19.
//  Copyright © 2019 Randall Fong Inc. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var cameraPositionLabel: UILabel!
    @IBOutlet weak var arSceneView: ARSCNView!
    
    // MARK: - Properties
    var audioSource: SCNAudioSource!
    var sceneGraph: SCNScene!
    var audioNode: SCNNode!
    var listenerNode: SCNNode!
    var cameraPosition = SCNVector3(x:0, y:0, z:0)
    
    // MARK: - View Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureAugmentedRealityScene()
        
        createAudioSource(using: "fishermansWharf.mp3")
        createAudioNode()
        createListenerNode()
        
        addNodesToScene()
        setSceneAudioListener()
        setListenerNodePositionToCameraPosition()
        
        playAudio()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioNode.removeAllAudioPlayers()
        audioNode.removeFromParentNode()
        listenerNode.removeFromParentNode()
        arSceneView.session.pause()
    }
    
    // MARK: - Configure for Augmented Reality
    
    func configureAugmentedRealityScene() {
        let configuration = ARWorldTrackingConfiguration()
        arSceneView.session.run(configuration)
    }
    
    // MARK: - Prepare SceneKit Nodes
    func createAudioSource(using source: String) {
        audioSource = SCNAudioSource(fileNamed: "fishermansWharf.mp3")!
        audioSource.loops = true
        audioSource.isPositional = true
        audioSource.load()
    }
    func createAudioNode() {
        audioNode = SCNNode()
        audioNode.position = SCNVector3(x:0, y:0, z: -0.3)
    }
    func createListenerNode() {
        listenerNode = SCNNode()
        listenerNode.isHidden = true
        listenerNode.position = SCNVector3(x:0, y:0, z:0)
    }
    func addNodesToScene() {
        arSceneView.scene.rootNode.addChildNode(audioNode)
        arSceneView.scene.rootNode.addChildNode(listenerNode)
    }
    func setSceneAudioListener() {
        arSceneView.audioListener = audioNode
    }
    
    func setListenerNodePositionToCameraPosition() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getCameraPosition), userInfo: nil, repeats: true)
    }
    
    // MARK: - Run Audio
    private func playAudio() {
        audioNode.removeAllAudioPlayers()
        audioNode.addAudioPlayer(SCNAudioPlayer(source: audioSource))
    }

    // MARK: - Selector Methods
    @objc
    private func getCameraPosition() {
        guard let _ = audioNode else { return }
        cameraPosition = self.arSceneView.pointOfView?.worldPosition ?? SCNVector3(x:0, y:0, z:0)
        audioNode.position = cameraPosition 
        cameraPositionLabel.text = String(format: "x: %.2f \ny: %.2f \nz: %.2f",
                                              cameraPosition.x,
                                              cameraPosition.y,
                                              cameraPosition.z)
        }
        
}

extension ViewController: ARSessionDelegate {
    
}

