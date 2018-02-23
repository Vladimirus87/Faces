//
//  VideoDataOutput.swift
//  VisionDetection
//
//  Created by Владимир Моисеев on 07.02.2018.
//  Copyright © 2018 Willjay. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let exifOrientation = CGImagePropertyOrientation(rawValue: exifOrientationFromDeviceOrientation()) else { return }
        
        
        self.exifOrientation = exifOrientation
        
        var requestOptions: [VNImageOption : Any] = [:]
        
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics : cameraIntrinsicData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(requests)
        }
            
        catch {
            print(error)
        }
        if takePhoto {
            guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
            print(outputImage.size)
            
            if let _facebounds = previewView.facebounds {
                self.newFacebounds = _facebounds
                
                DispatchQueue.main.async {
                    self.image = outputImage
                    
                }
                takePhoto = false
                
                self.performSegue(withIdentifier: "toImageVC", sender: self)
                
            } else {
                
                DispatchQueue.main.async {
                    self.takePhoto = false
                    self.showHideWarning(willShow: true, withText: "В кадре нет лиц")
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self.showHideWarning(willShow: false, withText: nil)
                    }
                }
            }
        }
    }
    
    
    
    
    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return image
    }
    
}
