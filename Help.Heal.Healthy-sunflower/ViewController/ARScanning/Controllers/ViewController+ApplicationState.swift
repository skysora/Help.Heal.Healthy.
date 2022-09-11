/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Management of the UI steps for scanning an object in the main view controller.
*/

import Foundation
import ARKit
import SceneKit

extension ViewController {
    
    enum State {
        case startARSession
        case notReady
        case scanning
        //case testing
        case finish
    }
    
    /// - Tag: ARObjectScanningConfiguration
    // The current state the application is in
    var state: State {
        get {
            return self.internalState
        }
        set {
            // 1. Check that preconditions for the state change are met.
            var newState = newValue
            switch newValue {
            case .startARSession:
                break
            case .notReady:
                // Immediately switch to .ready if tracking state is normal.
                if let camera = self.sceneView.session.currentFrame?.camera {
                    switch camera.trackingState {
                    case .normal:
                        newState = .scanning
                    default:
                        break
                    }
                } else {
                    newState = .startARSession
                }
            case .scanning:
                // Immediately switch to .notReady if tracking state is not normal.
                if let camera = self.sceneView.session.currentFrame?.camera {
                    switch camera.trackingState {
                    case .normal:
                        break
                    default:
                        newState = .notReady
                    }
                } else {
                    newState = .startARSession
                }
               
//            case .testing:
//                guard scan?.boundingBoxExists == true || referenceObjectToTest != nil else {
//                    print("Error: Scan is not ready to be tested.")
//                    return
//                }
            case .finish:
                guard scan?.boundingBoxExists == true || referenceObjectToTest != nil else {
                    print("Error: Scan is not ready to be tested.")
                    return
                }
            }
            
            // 2. Apply changes as needed per state.
            internalState = newState
            
            switch newState {
            case .startARSession:
                print("State: Starting ARSession")
                scan = nil
                //testRun = nil
                modelURL = nil
                self.setNavigationBarTitle("")
                instructionsVisible = false
                showBackButton(false)
                nextButton.isEnabled = false
                loadModelButton.isHidden = true
                flashlightButton.isHidden = true
                
                // Make sure the SCNScene is cleared of any SCNNodes from previous scans.
                sceneView.scene = SCNScene()
                
                let configuration = ARObjectScanningConfiguration()
                configuration.planeDetection = .horizontal
                sceneView.session.run(configuration, options: .resetTracking)
                cancelMaxScanTimeTimer()
                cancelMessageExpirationTimer()
            case .notReady:
                print("State: Not ready to scan")
                scan = nil
                //testRun = nil
                self.setNavigationBarTitle("")
                loadModelButton.isHidden = true
                flashlightButton.isHidden = true
                showBackButton(false)
                nextButton.isEnabled = false
                nextButton.setTitle("Next", for: [])
                displayInstruction(Message("Please wait for stable tracking"))
                cancelMaxScanTimeTimer()
            case .scanning:
                print("State: Scanning")
                if scan == nil {
                    self.scan = Scan(sceneView)
                    self.scan?.state = .ready
                }
                //testRun = nil
                
                startMaxScanTimeTimer()
//            case .testing:
//                print("State: Testing")
//                self.setNavigationBarTitle("Test")
//                loadModelButton.isHidden = true
//                flashlightButton.isHidden = false
//                showMergeScanButton()
//                nextButton.isEnabled = true
//                nextButton.setTitle("Share", for: [])
//
////                testRun = TestRun(sceneView: sceneView)
////                testObjectDetection()
//                cancelMaxScanTimeTimer()
            case .finish:
                ViewController.instance!.scan!.createReferenceObject { scannedObject in
                    if let object = scannedObject {
                        //self.testObjectDetection(of: object)
                        
                        self.displayInstruction(Message("raw feature points = \(object.rawFeaturePoints)"))
                        print("extent = \(object.extent)")
                    } else {
                        let title = "Scan failed"
                        let message = "Saving the scan failed."
                        let buttonTitle = "Restart Scan"
                        self.showAlert(title: title, message: message, buttonTitle: buttonTitle, showCancel: false) { _ in
                            self.state = .startARSession
                        }
                    }
                }
                cancelMaxScanTimeTimer()
            }
        
            
            NotificationCenter.default.post(name: ViewController.appStateChangedNotification,
                                            object: self,
                                            userInfo: [ViewController.appStateUserInfoKey: self.state])
        }
    }
    
    @objc
    func scanningStateChanged(_ notification: Notification) {
        guard self.state == .scanning, let scan = notification.object as? Scan, scan === self.scan else { return }
        guard let scanState = notification.userInfo?[Scan.stateUserInfoKey] as? Scan.State else { return }
        
        DispatchQueue.main.async {
            switch scanState {
            case .ready:
                print("State: Ready to scan")
                self.setNavigationBarTitle("Ready to scan")
                self.showBackButton(false)
                self.nextButton.setTitle("Next", for: [])
                self.loadModelButton.isHidden = true
                self.flashlightButton.isHidden = true
                if scan.ghostBoundingBoxExists {
                    self.displayInstruction(Message("點擊“下一步”來創造相近的外框以便於掃瞄物體"))
                    //"Tap 'Next' to create an approximate bounding box around the object you want to scan."
                    self.nextButton.isEnabled = true
                } else {
                    self.displayInstruction(Message("指向你要掃描的物件"))
                    //"Point at a nearby object to scan."
                    self.nextButton.isEnabled = false
                }
            case .defineBoundingBox:
                print("State: Define bounding box")
                self.displayInstruction(Message("移動改變正方體的大小或者常按邊框可進行放大縮小"))
                //"Position and resize bounding box using gestures.\n" +"Long press sides to push/pull them in or out. "
                self.setNavigationBarTitle("Define bounding box")
                self.showBackButton(true)
                self.nextButton.isEnabled = scan.boundingBoxExists
                self.loadModelButton.isHidden = true
                self.flashlightButton.isHidden = true
                self.nextButton.setTitle("Scan", for: [])
                
            case .scanning:
                self.displayInstruction(Message("掃描物件的每一個面，掃描中請勿移動物件"))
                //"Scan the object from all sides that you are " + "interested in. Do not move the object while scanning!"
                if let boundingBox = scan.scannedObject.boundingBox {
                    self.setNavigationBarTitle("Scan (\(boundingBox.progressPercentage)%)")
                } else {
                    self.setNavigationBarTitle("Scan 0%")
                }
                self.showBackButton(true)
                self.nextButton.isEnabled = true
                self.loadModelButton.isHidden = true
                self.flashlightButton.isHidden = true
                self.nextButton.setTitle("Finish", for: [])
                // Disable plane detection (even if no plane has been found yet at this time) for performance reasons.
                self.sceneView.stopPlaneDetection()
            case .adjustingOrigin:
                print("State: Adjusting Origin")
                //self.displayInstruction(Message("Adjust origin using gestures.\n" + "You can load a *.usdz 3D model overlay."))
                self.setNavigationBarTitle("Finish")
                self.showBackButton(true)
                self.nextButton.isEnabled = true
                //self.loadModelButton.isHidden = false
                self.loadModelButton.isHidden = true
                self.flashlightButton.isHidden = true
                self.nextButton.setTitle("finish", for: [])
            }
        }
    }
    
    func switchToPreviousState() {
        switch state {
        case .startARSession:
            break
        case .notReady:
            state = .startARSession
        case .scanning:
            if let scan = scan {
                switch scan.state {
                case .ready:
                    restartButtonTapped(self)
                case .defineBoundingBox:
                    scan.state = .ready
                case .scanning:
                    scan.state = .defineBoundingBox
                case .adjustingOrigin:
                    scan.state = .scanning
                }
            }
//        case .testing:
//            state = .scanning
//            scan?.state = .adjustingOrigin
        case .finish:
            print("finish")
        }
    }
    
    func switchToNextState() {
        switch state {
        case .startARSession:
            state = .notReady
        case .notReady:
            state = .scanning
        case .scanning:
            if let scan = scan {
                switch scan.state {
                case .ready:
                    scan.state = .defineBoundingBox
                case .defineBoundingBox:
                    scan.state = .scanning
                case .scanning:
                    scan.state = .adjustingOrigin
                case .adjustingOrigin:
//                    state = .testing
                    state = .finish
                }
                
            }
//        case .testing:
//            print("test")
            // Testing is the last state, show the share sheet at the end.
            //createAndShareReferenceObject()
        case .finish:
            print("finish")
            performSegue(withIdentifier: "goToIngredient", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if segue.identifier == "goToIngredient" {
//            let controller = segue.destination as! IngredientViewController
//            controller.bool = true
//        }
    }
    
    @objc
    func ghostBoundingBoxWasCreated(_ notification: Notification) {
        if let scan = scan, scan.state == .ready {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = true
                self.displayInstruction(Message("點擊“下一步”來創造相近的外框以便於掃瞄物體"))
                //"Tap 'Next' to create an approximate bounding box around the object you want to scan."
                
            }
        }
    }
    
    @objc
    func ghostBoundingBoxWasRemoved(_ notification: Notification) {
        if let scan = scan, scan.state == .ready {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = false
                self.displayInstruction(Message("指向你要掃描的物件"))
                //"Point at a nearby object to scan."
                
            }
        }
    }
    
    @objc
    func boundingBoxWasCreated(_ notification: Notification) {
        if let scan = scan, scan.state == .defineBoundingBox {
            DispatchQueue.main.async {
                self.nextButton.isEnabled = true
            }
        }
    }
}
