//
//  ViewController.swift
//  VisionDetection
//
//  Created by Wei Chieh Tseng on 09/06/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import Photos

class ViewController: UIViewController {

    
    // VNRequest: Either Retangles or Landmarks
    var faceDetectionRequest: VNRequest!
    var takePhoto = false
    var image: UIImage? = nil
    var exifOrientation: CGImagePropertyOrientation?
    var newFacebounds = CGRect.zero {
        didSet { print("newFacebounds - \(newFacebounds)") }
    }
    
    
    
    @IBOutlet weak var shoot: UIButton!
    @IBOutlet weak var gallery: UIButton!
    @IBOutlet weak var rotate: UIButton!
    @IBOutlet weak var manyFacesWarning: UILabel!
    @IBOutlet weak var flashLight: UIButton!
    @IBOutlet weak var smallLogo: UIImageView!
    @IBOutlet weak var warningView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the video preview view.
        previewView.session = session
//        previewView.delegate = self
        
        // Set up Vision Request
        faceDetectionRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces) // Default
        setupVision()
        
        
        /*
         Check video authorization status. Video access is required and audio
         access is optional. If audio access is denied, audio is not recorded
         during movie recording.
         */
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video){
        case .authorized:
            // The user has previously granted access to the camera.
            break
            
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. We suspend the session queue to delay session
             setup until the access request has completed.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
            
            
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
        
        /*
         Setup the capture session.
         In general it is not safe to mutate an AVCaptureSession or any of its
         inputs, outputs, or connections from multiple threads at the same time.
         
         Why not do all of this on the main queue?
         Because AVCaptureSession.startRunning() is a blocking call which can
         take a long time. We dispatch session setup to the sessionQueue so
         that the main queue isn't blocked, which keeps the UI responsive.
         */
        
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
            sessionQueue.async { [unowned self] in
                switch self.setupResult {
                case .success:
                    // Only setup observers and start the session running if setup succeeded.
                    self.addObservers()
                    self.session.startRunning()
                    self.isSessionRunning = self.session.isRunning
                    
                case .notAuthorized:
                    DispatchQueue.main.async { [unowned self] in
                        let message = NSLocalizedString("AVCamBarcode doesn't have permission to use the camera, please change privacy settings", comment: "Alert message when the user has denied access to the camera")
                        let    alertController = UIAlertController(title: "AppleFaceDetection", message: message, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"), style: .`default`, handler: { action in
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                case .configurationFailed:
                    DispatchQueue.main.async { [unowned self] in
                        let message = NSLocalizedString("Unable to capture media", comment: "Alert message when something goes wrong during capture session configuration")
                        let alertController = UIAlertController(title: "AppleFaceDetection", message: message, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"), style: .cancel, handler: nil))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            }
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        

        
            sessionQueue.async { [unowned self] in
                if self.setupResult == .success {
                    self.session.stopRunning()
                    self.isSessionRunning = self.session.isRunning
                    self.removeObservers()
                }
            }
            
            super.viewWillDisappear(animated)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let videoPreviewLayerConnection = previewView.videoPreviewLayer.connection {
            let deviceOrientation = UIDevice.current.orientation
            guard let newVideoOrientation = deviceOrientation.videoOrientation, deviceOrientation.isPortrait || deviceOrientation.isLandscape else {
                return
            }
            
            videoPreviewLayerConnection.videoOrientation = newVideoOrientation
            
        }
    }

    
    
    @IBOutlet weak var previewView: PreviewView!
    
    // MARK: Session Management
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    var imagePicker = UIImagePickerController()
    
    var devicePosition: AVCaptureDevice.Position = .back
    
    var flashMode = AVCaptureDevice.FlashMode.off
    
    let session = AVCaptureSession()
    var isSessionRunning = false
    
    let sessionQueue = DispatchQueue(label: "session queue", attributes: [], target: nil) // Communicate with the session and other session objects on this queue.
    
    var setupResult: SessionSetupResult = .success
    
    var videoDeviceInput:   AVCaptureDeviceInput!
    
    var videoDataOutput:    AVCaptureVideoDataOutput!
    var videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
    
    
    
    var requests = [VNRequest]()
    
    func configureSession() {
        if self.setupResult != .success {
            return
        }
        
        
        session.beginConfiguration()
        session.sessionPreset = .high

        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            // Choose the back dual camera if available, otherwise default to a wide angle camera.
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            }
                
            else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                defaultVideoDevice = backCameraDevice
            }
                
            else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                DispatchQueue.main.async {
                    /*
                     Why are we dispatching this to the main queue?
                     Because AVCaptureVideoPreviewLayer is the backing layer for PreviewView and UIView
                     can only be manipulated on the main thread.
                     Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
                     on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                     
                     Use the status bar orientation as the initial video orientation. Subsequent orientation changes are
                     handled by CameraViewController.viewWillTransition(to:with:).
                     */
                    let statusBarOrientation = UIApplication.shared.statusBarOrientation
                    var initialVideoOrientation: AVCaptureVideoOrientation = .portrait
                    if statusBarOrientation != .unknown {
                        if let videoOrientation = statusBarOrientation.videoOrientation {
                            initialVideoOrientation = videoOrientation
                        }
                    }
                    self.previewView.videoPreviewLayer.connection!.videoOrientation = initialVideoOrientation
                }
            } else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            
        } catch {
            print("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        // add output
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32BGRA)]
        
        
        if session.canAddOutput(videoDataOutput) {
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            session.addOutput(videoDataOutput)
        }
        else {
            print("Could not add metadata output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
        
    }
    
    func availableSessionPresets() -> [String] {
        let allSessionPresets = [AVCaptureSession.Preset.photo,
                                 AVCaptureSession.Preset.low,
                                 AVCaptureSession.Preset.medium,
                                 AVCaptureSession.Preset.high,
                                 AVCaptureSession.Preset.cif352x288,
                                 AVCaptureSession.Preset.vga640x480,
                                 AVCaptureSession.Preset.hd1280x720,
                                 AVCaptureSession.Preset.iFrame960x540,
                                 AVCaptureSession.Preset.iFrame1280x720,
                                 AVCaptureSession.Preset.hd1920x1080,
                                 AVCaptureSession.Preset.hd4K3840x2160]
        
        var availableSessionPresets = [String]()
        for sessionPreset in allSessionPresets {
            if session.canSetSessionPreset(sessionPreset) {
                availableSessionPresets.append(sessionPreset.rawValue)
            }
        }
        
        return availableSessionPresets
    }
    
    func exifOrientationFromDeviceOrientation() -> UInt32 {
        enum DeviceOrientation: UInt32 {
            case top0ColLeft = 1
            case top0ColRight = 2
            case bottom0ColRight = 3
            case bottom0ColLeft = 4
            case left0ColTop = 5
            case right0ColTop = 6
            case right0ColBottom = 7
            case left0ColBottom = 8
        }
        var exifOrientation: DeviceOrientation
        
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            exifOrientation = .left0ColBottom
        case .landscapeLeft:
            exifOrientation = devicePosition == .front ? .bottom0ColRight : .top0ColLeft
        case .landscapeRight:
            exifOrientation = devicePosition == .front ? .top0ColLeft : .bottom0ColRight
        default:
            exifOrientation = devicePosition == .front ? .left0ColTop : .right0ColTop
            //exifOrientation = .right0ColTop
        }
        
        return exifOrientation.rawValue
    }
    
    
    
    
    @IBAction func Shoot(_ sender: UIButton) {
        
        takePhoto = true

    }
    
    
    @IBAction func switchCameras(_ sender: UIButton) {
        switchCamera()

    }
    
    
    @IBAction func openGallery(_ sender: UIButton) {
        
        session.stopRunning()
        isSessionRunning = session.isRunning
        self.removeObservers()
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: {
            })
        }
    }
    
    

    
    
  
    
    @IBAction func flashLightOnOff(_ sender: UIButton) {
        
        if devicePosition == .back {
            
            guard let device = AVCaptureDevice.default(for: AVMediaType.video)
                else {return}
            
            if device.hasTorch {
                do {
                    try device.lockForConfiguration()
                    
                    device.torchMode = device.torchMode == .off ? .on : .off
                    
                    device.unlockForConfiguration()
                } catch {
                    print("Torch could not be used")
                }
            } else {
                print("Torch is not available")
            }
        }
    }
    
    
    
    //Switch Camera
    func switchCamera() {
        session.beginConfiguration()
        let currentInput = session.inputs.first as? AVCaptureDeviceInput
        session.removeInput(currentInput!)
        
        let newCameraDevice = currentInput?.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
        devicePosition = currentInput?.device.position == .back ? .front : .back
        flashLight.isHidden = devicePosition == .back ? false : true
        
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        session.addInput(newVideoInput!)
        session.commitConfiguration()
    }
    
    
    
    func showHideWarning(willShow: Bool, withText: String?) {
        
        if willShow {
            
            self.warningView.isHidden = false
            self.manyFacesWarning.text = withText ?? ""
            self.shoot.isEnabled = false
            self.shoot.alpha = 0.5
            
        } else {
            
            self.warningView.isHidden = true
            self.shoot.isEnabled = true
            self.shoot.alpha = 1
        }
    }
    



    //Get Camera
    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else {
            return nil
        }
        
        let dev = devices.filter {
            $0.position == position
            }.first

        
        return dev
    }

    
    
   
    
    //Vision
    private var isManyFaces = false
    
    func setupVision() {
        self.requests = [faceDetectionRequest]
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            //perform all the UI updates on the main queue
            guard let results = request.results as? [VNFaceObservation] else { return }
            self.previewView.removeMask()
            for face in results {
                self.previewView.drawFaceboundingBox(face: face)
                
                
                if results.count > 1 {
                    
                    if self.isManyFaces == false {
                        self.showHideWarning(willShow: true, withText: "НЕ БОЛЕЕ ОДНОГО ЛИЦА")
                        self.isManyFaces = true
                    }
                
                } else {
                    
                    if self.isManyFaces {
                        self.showHideWarning(willShow: false, withText: nil)
                        self.isManyFaces = false
                    }
                }
            }
        }
    }
    

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageVC" {
            let destVC = segue.destination as! ImageViewController
            destVC.image = self.image
            destVC.completion = { [weak self] image in
                self?.image = image
            }
        }
    }
    
}





//extension ViewController: ChangesWithDistanceToHead {
//
//
//    func changeColor(toColor: UIColor) {
//        shoot.backgroundColor = toColor
//    }
//
//}







