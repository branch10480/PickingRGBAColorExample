//
//  UIImage+.swift
//  PickingRGBAColorExample
//
//  Created by branch10480 on 2022/02/05.
//

import UIKit
import CoreGraphics

extension UIImage {
  
  func pickColor(at point: CGPoint) -> UIColor? {
    guard let imageRef = cgImage else {
      return nil
    }
    let width = imageRef.width
    let height = imageRef.height
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bytesPerPixel = imageRef.bitsPerPixel / imageRef.bitsPerComponent
    let bytesPerRow = bytesPerPixel * width
    let bitsPerComponent = imageRef.bitsPerComponent
    guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue) else {
      return nil
    }
    context.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
    var data = context.data
    let index = bytesPerRow * Int(point.y) + Int(point.x) * bytesPerPixel
    let color = color(of: &data, index: index)
    return color
  }
  
  private func color(of data: inout UnsafeMutableRawPointer?, index i: Int) -> UIColor? {
    guard let data = data else { return nil }
    let red = CGFloat(data.advanced(by: i).load(as: UInt8.self)) / 255.0
    let green = CGFloat(data.advanced(by: i + 1).load(as: UInt8.self)) / 255.0
    let blue = CGFloat(data.advanced(by: i + 2).load(as: UInt8.self)) / 255.0
    let alpha = CGFloat(data.advanced(by: i + 3).load(as: UInt8.self)) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
  
}
