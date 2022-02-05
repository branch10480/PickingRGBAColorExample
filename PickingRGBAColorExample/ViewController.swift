//
//  ViewController.swift
//  PickingRGBAColorExample
//
//  Created by branch10480 on 2022/02/05.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var previewView: UIView!
  @IBOutlet weak var pickedColorLabel: UILabel!
  
  private enum PositionType: Int {
    case topLeft = 0
    case topRight = 1
    case bottomLeft = 2
    case bottomRight = 3
    case center = 4
    
    var title: String {
      switch self {
      case .topLeft: return "Top Left"
      case .topRight: return "Top Right"
      case .bottomLeft: return "Bottom Left"
      case .bottomRight: return "Bottom Right"
      case .center: return "Center"
      }
    }
  }
  
  private let defaultURLString = "https://gaugau.ismcdn.jp/mwimgs/1/8/576wm/img_1837965a2b7d6483af900fc801a3d262785637.jpg"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  @IBAction func didTapPickingButton(_ sender: UIButton) {
    guard let type = PositionType(rawValue: sender.tag) else {
      return
    }
    previewView.backgroundColor = pickColor(at: type, in: imageView.image)
    pickedColorLabel.text = type.title
  }
  
  private func setup() {
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .black
    textField.text = defaultURLString
    previewView.layer.cornerRadius = 8
    previewView.layer.masksToBounds = true
    showImage()
  }
  
  private func showImage() {
    guard let string = textField.text, let url = URL(string: string) else {
      return
    }
    do {
      let data = try Data(contentsOf: url)
      imageView.image = .init(data: data)
    } catch(let e) {
      print(e.localizedDescription)
    }
  }
  
  private func pickColor(at type: PositionType, in image: UIImage?) -> UIColor? {
    guard let image = image, let cgImage = image.cgImage else {
      return nil
    }
    let point: CGPoint
    switch type {
    case .topLeft:
      point = .zero
    case .topRight:
      point = .init(x: cgImage.width - 1, y: 0)
    case .bottomLeft:
      point = .init(x: 0, y: cgImage.height - 1)
    case .bottomRight:
      point = .init(x: cgImage.width - 1, y: cgImage.height - 1)
    case .center:
      point = .init(x: cgImage.width / 2, y: cgImage.height / 2)
    }
    return image.pickColor(at: point)
  }

}

