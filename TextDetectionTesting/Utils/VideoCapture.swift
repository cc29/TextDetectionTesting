//
//  VideoCapture.swift
//  ObjectDetectionTesting
//
//  Created by Theseus on 10/07/20.
//  Copyright © 2020 Theseus. All rights reserved.
//

import UIKit
import AVFoundation
//import CoreVideo

public protocol VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame: CVPixelBuffer?, timeStamp: CMTime)
}



public class VideoCapture: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    public var previewLayer: AVCaptureVideoPreviewLayer?
    public var delegate: VideoCaptureDelegate?
    public var fps = 15
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    let queue = DispatchQueue(label: "sideWork")
    
    var lastTimeStamp = CMTime()
    
    public func setUp(sessionPreset: AVCaptureSession.Preset = .vga640x480, completion: @escaping (Bool) -> Void) {
        print(3)
        setUpCamera(sessionPreset: sessionPreset) { (success) in
            completion(success)
        }
    }
    
    private func setUpCamera(sessionPreset: AVCaptureSession.Preset, completion: @escaping (_ success: Bool)-> Void) {
        print(4)
        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset
        
        guard let captureDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else {fatalError("No Video Device found")}
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {fatalError("Problem with crating of VideoInout")}
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect BY Default
        previewLayer?.connection?.videoOrientation = .portrait
        
        
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA)]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        videoOutput.connection(with: AVMediaType.video)?.videoOrientation = .portrait
        
        captureSession.commitConfiguration()
        
        let success = true
        completion(success)
        }
    
    public func start() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    public func stop() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print(4)
        
        let timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let deltaTime = timeStamp - lastTimeStamp
        if deltaTime >= CMTimeMake(value: 1, timescale: Int32(fps)) {
            
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        delegate?.videoCapture(self, didCaptureVideoFrame: imageBuffer, timeStamp: timeStamp)
        }
    }
}
