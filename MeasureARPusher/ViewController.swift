//
//  ViewController.swift
//  MeasureARPusher
//
//  Created by Celina on 2/18/19.
//  Copyright © 2019 Celina. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension SCNGeometry {
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
}

extension SCNVector3 {
    static func distanceFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> Float {
        let x0 = vector1.x
        let x1 = vector2.x
        let y0 = vector1.y
        let y1 = vector2.y
        let z0 = vector1.z
        let z1 = vector2.z
        
        return sqrtf(powf(x1-x0, 2) + powf(y1-y0, 2) + powf(z1-z0, 2))
    }
}

extension Float {
    func metersToInches() -> Float {
        return self * 39.3701
    }
}

class ViewController: UIViewController, ARSCNViewDelegate {

    var objs: [SCNNode] = []
    var startPoint: SCNVector3!
    var endPoint: SCNVector3!
    var numberOfTaps = 0
    var point: SCNVector3!
    var sendingTime : TimeInterval = 0
    var status: String!
    var trackingState: ARCamera.TrackingState!
    
    enum Mode {
        case waitingForMeasuring
        case measuring
    }
    
    var mode: Mode = .waitingForMeasuring {
        didSet {
            switch mode {
            case .waitingForMeasuring:
                status = "NOT READY"
            case .measuring:
                setStatusText()
            }
        }
    }
    
    @IBOutlet weak var sceneView: ARSCNView!
//    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var statusText: UITextView!
    
    @IBAction func onDone(_ sender: Any) {
        self.performSegue(withIdentifier: "scanDone", sender: self)
    }
    @IBAction func onRestart(_ sender: Any) {
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        objs.removeAll()
        numberOfTaps = 0
    }
    
    @IBAction func onUndo(_ sender: Any) {
        if objs.count == 1 {
            objs.last?.removeFromParentNode()
            objs.removeLast()
            numberOfTaps = 0
        } else {
            for i in 1...3 {
                objs.last?.removeFromParentNode()
                objs.removeLast()
            }
            if objs.count == 1 {
                startPoint = objs.last?.position
            } else {
                startPoint = objs[objs.count-3].position
            }
        }
    }
    
    
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) {
        if (status == "READY") {
            numberOfTaps += 1
            
            // Get 2D position of touch event on screen
            let touchPosition = sender.location(in: sceneView)
            
            // Translate those 2D points to 3D points using hitTest (existing plane)
            let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlane)
            
            guard let hitTest = hitTestResults.first else {
                return
            }
            
            // If first tap, add red marker. If second tap, add green marker and reset to 0
            if numberOfTaps == 1 {
                startPoint = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
                addRedMarker(hitTestResult: hitTest)
            }
            else {
                endPoint = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
                
                addRedMarker(hitTestResult: hitTest)
                
                addLineBetween(start: startPoint, end: endPoint)
                
                addDistanceText(distance: SCNVector3.distanceFrom(vector: startPoint, toVector: endPoint), at: endPoint)
                
                startPoint = endPoint
            }
        }
    }
    
    func addRedMarker(hitTestResult: ARHitTestResult) {
        addMarker(hitTestResult: hitTestResult, color: .red)
    }
    
    func addMarker(hitTestResult: ARHitTestResult, color: UIColor) {
        let geometry = SCNSphere(radius: 0.01)
        geometry.firstMaterial?.diffuse.contents = color
        
        let markerNode = SCNNode(geometry: geometry)
        markerNode.position = SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)
        print(markerNode.position)
        
        sceneView.scene.rootNode.addChildNode(markerNode)
        objs.append(markerNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        if (ARConfiguration.isSupported) {
            // ARKit is supported. You can work with ARKit
            print("supported")
        } else {
            // ARKit is not supported. You cannot work with ARKit
            print("not Supported")
        }
        // Set a padding in the text view
//        statusTextView.textContainerInset =
//            UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 0.0)
        // Set the initial mode
        mode = .waitingForMeasuring
        // Display the initial status
        setStatusText()
    }
    
    func setStatusText() {
//        var text = "Status: \(status!)\n"
//        text += "Tracking: \(getTrackingDescription())\n"
//        statusTextView.text = text
//
        var txt = "Status: \(status!)!\n Find a horizontal plane to start scan\n"
        if status == "READY" {
            txt = "Status: \(status!)!\n Begin placing markers on screen.\n"
        }
        txt += "Tracking: \(getTrackingDescription())\n"
        statusText.text = txt
        
    }
    
    func getTrackingDescription() -> String {
        var description = ""
        if let t = trackingState {
            switch(t) {
            case .notAvailable:
                description = "UNAVAILABLE"
            case .normal:
                description = "NORMAL"
            case .limited(let reason):
                switch reason {
                case .excessiveMotion:
                    description =
                    "LIMITED - Too much camera movement"
                case .insufficientFeatures:
                    description =
                    "LIMITED - Not enough surface detail"
                case .initializing:
                    description = "INITIALIZING"
                case .relocalizing:
                    print("error")
                }
            }
        }
        return description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration with plane detection
        let configuration = ARWorldTrackingConfiguration()
        
        //horizontal plane will be added to the scene view's session
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        trackingState = camera.trackingState
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Call the method asynchronously to perform
        //  this heavy task without slowing down the UI
        DispatchQueue.main.async {
            self.measure(time: time)
        }
    }
    
    func measure(time: TimeInterval) {
        let screenCenter : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        let planeTestResults = sceneView.hitTest(screenCenter, types: [.existingPlaneUsingExtent])
        if let result = planeTestResults.first {
            status = "READY"
            
            if mode == .measuring {
                status = "MEASURING"
            }
        } /*else {
            status = "NOT READY"
        }*/
        setStatusText()
    }
    
    func addLineBetween(start: SCNVector3, end: SCNVector3) {
        let lineGeometry = SCNGeometry.lineFrom(vector: start, toVector: end)
        let lineNode = SCNNode(geometry: lineGeometry)
        
        sceneView.scene.rootNode.addChildNode(lineNode)
        objs.append(lineNode)
    }
    
    func addDistanceText(distance: Float, at point: SCNVector3) {
        let textGeometry = SCNText(string: String(format: "%.1f\"", distance.metersToInches()), extrusionDepth: 1)
        textGeometry.font = UIFont.systemFont(ofSize: 10)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.black
        
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3Make(point.x, point.y, point.z);
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(textNode)
        objs.append(textNode)
    }
}

