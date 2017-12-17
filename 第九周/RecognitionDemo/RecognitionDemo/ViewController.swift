//
//  ViewController.swift
//  RecognitionDemo
//
//  Created by 刘勇刚 on 17/12/2017.
//  Copyright © 2017 刘勇刚. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    fileprivate lazy var captureSession: AVCaptureSession = {
        let c = AVCaptureSession()
        c.sessionPreset = .inputPriority
        return c
    }()
    /// 预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let p = AVCaptureVideoPreviewLayer(session: self.captureSession)
        p.videoGravity = .resizeAspectFill
        p.frame.origin = self.view.frame.origin
        p.frame.size = self.view.frame.size
        return p
    }()
    
    private let inceptionModel = Inceptionv3()
    
    private lazy var resultLabel:UILabel = {
        let r = UILabel(frame: CGRect(x: 10, y: view.bounds.size.height - 80, width: view.bounds.size.width - 20, height: 80))
        r.textAlignment = .center
        r.font = UIFont.systemFont(ofSize: 20)
        r.textColor = .white
        r.backgroundColor = .gray
        r.numberOfLines = 0
        self.view.addSubview(r)
        return r
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 输入
        if let d = addSupportDevice(),
            let inputDevice = try? AVCaptureDeviceInput(device: d) {
            captureSession.addInput(inputDevice)
        }
        // 输出
        let output = AVCaptureVideoDataOutput()
        let queue = DispatchQueue(label: "com.recherj.recognitionQueue")
        output.setSampleBufferDelegate(self, queue: queue)
        
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: NSNumber(value: kCVPixelFormatType_32BGRA)]
        output.alwaysDiscardsLateVideoFrames = true
        guard captureSession.canAddOutput(output) else {
            fatalError("can not add output device!")
        }
        captureSession.addOutput(output)
        
        view.layer.insertSublayer(previewLayer, at: 1)
        // 开始捕获
        captureSession.startRunning()
    }
    /// 添加支持的设备
    private func addSupportDevice() -> AVCaptureDevice? {
        guard let device = AVCaptureDevice.default(for: .video) else { return nil }
        var videoFormatArr = [AVCaptureDevice.Format]()
        let fps = Double(3)
        for format in device.formats {
            for range in format.videoSupportedFrameRateRanges where fps >= range.minFrameRate && fps <= range.maxFrameRate {
                videoFormatArr.append(format)
            }
        }
        
        let size = CGSize(width: 200, height: 200)
        var sizeFormat: AVCaptureDevice.Format?
        for format in videoFormatArr {
            let dimesions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            if dimesions.width >= Int32(size.width) && dimesions.height >= Int32(size.height) {
                sizeFormat = format
            }
        }
        guard let sizeF = sizeFormat else { return nil }
        try? device.lockForConfiguration()
        device.activeFormat = sizeF
        device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps))
        device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps))
        device.focusMode = .continuousAutoFocus
        device.unlockForConfiguration()
        return device
    }
    /// 处理捕获的图片流
    fileprivate func handleImageBuffer(_ imageBuffer: CMSampleBuffer) {
        guard let imgBuffer = CMSampleBufferGetImageBuffer(imageBuffer) else { return }
        let capturedImage: UIImage
        CVPixelBufferLockBaseAddress(imgBuffer, .readOnly)
        defer {
            CVPixelBufferLockBaseAddress(imgBuffer, .readOnly)
        }
        let address = CVPixelBufferGetBaseAddressOfPlane(imgBuffer, 0)
        let bytes = CVPixelBufferGetBytesPerRow(imgBuffer)
        let width = CVPixelBufferGetWidth(imgBuffer)
        let height = CVPixelBufferGetHeight(imgBuffer)
        let color = CGColorSpaceCreateDeviceRGB()
        let bits = 8
        let info = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let context = CGContext(data: address, width: width, height: height, bitsPerComponent: bits, bytesPerRow: bytes, space: color, bitmapInfo: info),
         let image = context.makeImage() else { return }
        
        capturedImage = UIImage(cgImage: image, scale: 1.0, orientation: .up)
        let size = CGSize(width: 299, height: 299)
        UIGraphicsBeginImageContext(size)
        capturedImage.draw(in: CGRect(origin: CGPoint(x: 0,y: 0), size: size))
        guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        guard let cvPixelBuffer = uiImageToCVPixelBuffer(from: scaledImage) else { return }
        let prediction = try? inceptionModel.prediction(image: cvPixelBuffer)
        DispatchQueue.main.async {
            var name: String = ""
            var confidence: Double = 0
            for index in (prediction?.classLabelProbs)! {
                if confidence < index.value {
                    confidence = index.value
                    name = index.key
                }
            }
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.resultLabel.frame.width, height: 0))
            label.text = "\(name):\(confidence)"
            label.font = self.resultLabel.font
            label.numberOfLines = 0
            label.sizeToFit()
            let height = label.frame.height * 2
            self.resultLabel.text = "\(name):\(confidence)"
            self.resultLabel.frame.size.height = height
        }
        
    }
    
    private func uiImageToCVPixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        handleImageBuffer(sampleBuffer)
    }
}

