//
//  ViewController.swift
//  TextDetectionTesting
//
//  Created by Theseus on 20/07/20.
//  Copyright © 2020 Theseus. All rights reserved.
//

import UIKit
import Vision
import CoreMedia

class ViewController: UIViewController {
   
    

    
    @IBOutlet weak var drawingView: DrawingView!
    @IBOutlet weak var videoPreview: UIView!
    
    
    @IBOutlet weak var inferenceLabel: UILabel!
    @IBOutlet weak var etimeLabel: UILabel!
    @IBOutlet weak var fpsLabel: UILabel!
    
    var videoCapture: VideoCapture!
    var request: VNDetectTextRectanglesRequest?
    private let measure = Measure()
    
    override func viewDidLoad() {
        print(1)
        super.viewDidLoad()
        measure.delegate = self
        
        setUpModel()
        setUpCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoCapture.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoCapture.stop()
    }
    
    func setUpModel() {
        print(2)
        let request = VNDetectTextRectanglesRequest(completionHandler: self.visionDidComplete)
        request.reportCharacterBoxes = true 
        self.request = request
        
    }
    
    func setUpCamera() {
        print(3)
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.setUp { (success) in
            if success {
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                self.videoCapture.start()
                
                
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
    }
    
    func resizePreviewLayer() {
        print(4)
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
}

extension ViewController: VideoCaptureDelegate {
    
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timeStamp: CMTime) {
        if let pixelBuffer = pixelBuffer {
            print(5)
            self.measure.startMeasuring()
            self.predictUsingVision(pixelBuffer)
            
        }
        
    }
    
}

extension ViewController {
    func predictUsingVision(_ pixelBuffer: CVPixelBuffer) {
        print(6)
        guard let request = request else {return}
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
        }
    
    func visionDidComplete(request: VNRequest, error: Error?) {
        self.measure.labeling(with: "endInference")

        guard let observations = request.results  else {
            
            self.measure.stopMeasuring()
            return
        }
       // print(regions)
        DispatchQueue.main.async {
            let regions: [VNTextObservation?] = observations.map({$0 as? VNTextObservation})
            print(7)
            print(regions)
            self.drawingView.regions = regions
            
            self.measure.stopMeasuring()
            
        }
        
      }
    
}

extension ViewController: MeasureDelegate {
    
    func updateMeasure(inferenceTime: Double, executiontime: Double, fps: Int) {
        self.inferenceLabel.text = "inference: \(Int(inferenceTime*1000.0)) mm"
        self.etimeLabel.text = "execution: \(Int(executiontime*1000.0)) mm"
        self.fpsLabel.text = "fps: \(fps)"
        
    }
}

