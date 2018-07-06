//
//  CaptureDevice.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/06.
//

import AVFoundation

protocol CaptureDeviceDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
}

final class CaptureDevice: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
  private lazy var device = AVCaptureDevice.default(for: .video)!
  private lazy var session = AVCaptureSession()
  private lazy var input = try! AVCaptureDeviceInput(device: device)
  private lazy var output = AVCaptureVideoDataOutput()
  private let cameraQueue = DispatchQueue.init(label: "com.noppelabs.babymetal.camera")
  var delegate: CaptureDeviceDelegate? = nil
  
  override init() {
    super.init()
    session.sessionPreset = .hd1280x720
    session.addInput(input)
    session.addOutput(output)
    output.setSampleBufferDelegate(self, queue: cameraQueue)
    output.connections.forEach({ $0.videoOrientation = .portrait })
    output.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA] as [String : Any]
  }
  
  func startRunning() {
    session.startRunning()
  }
  
  func stopRunning() {
    session.stopRunning()
  }
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    delegate?.captureOutput(output, didOutput: sampleBuffer, from: connection)
  }
}
