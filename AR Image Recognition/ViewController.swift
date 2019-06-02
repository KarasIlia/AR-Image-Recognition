//
//  ViewController.swift
//  AR Image Recognition
//
//  Created by Илья Карась on 02/06/2019.
//  Copyright © 2019 Ilia Karas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 2
        configuration.planeDetection = [.horizontal, .vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        switch anchor {
        case let imageAnchor as ARImageAnchor:
            nodeAdded(node, for: imageAnchor)
        case let planeAnchor as ARPlaneAnchor:
            nodeAdded(node, for: planeAnchor)
        default:
            print(#line, #function, "\(anchor) added")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        node.removeFromParentNode()
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARImageAnchor) {
        
        let referenceImage = anchor.referenceImage
        let size = referenceImage.physicalSize
        let plane = SCNPlane(width: 1.02 * size.width, height: 1.02 * size.height)
        
        switch referenceImage.name {
        case "500faceLeft":
            plane.firstMaterial?.diffuse.contents = UIImage(named: "1000USDfaceLeft")
            
            remove(anchor)
        case "500faceRight":
            plane.firstMaterial?.diffuse.contents = UIImage(named: "1000USDfaceRight")
            
            remove(anchor)
        case "500backLeft":
            plane.firstMaterial?.diffuse.contents = UIImage(named: "1000USDbackLeft")
            
            remove(anchor)
        case "500backRight":
            plane.firstMaterial?.diffuse.contents = UIImage(named: "1000USDbackRight")
            
            remove(anchor)
        default:
            break
        }
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
    }
    
    func remove(_ anchor: ARImageAnchor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.sceneView.session.remove(anchor: anchor)
        })
    }
    
    func nodeAdded(_ node: SCNNode, for anchor: ARPlaneAnchor) {
        let extent = anchor.extent
        let width = CGFloat(extent.x)
        let height = CGFloat(extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.firstMaterial?.diffuse.contents = UIColor.blue
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.eulerAngles.x = -.pi / 2
        planeNode.opacity = 0
        
        node.addChildNode(planeNode)
    }
}

