import UIKit
import PlaygroundSupport

class ManuallyWiringUpUIViewController : UIViewController, UITextFieldDelegate {
  
  var slider:UISlider!
  var textField:UITextField!
  var setToMinimumButton:UIButton!
  var setToMaximumButton:UIButton!
  
  let min:Float = 0
  let max:Float = 100
  
  override func loadView() {
    
    // UI
    
    let view = UIView()
    view.backgroundColor = .white
    
    slider = UISlider()
    slider.minimumValue = min
    slider.maximumValue = max
    
    textField = UITextField()
    textField.text = "\(slider.value)"
    
    setToMinimumButton = UIButton(type: .system)
    setToMinimumButton.setTitle("Set to Minimum", for: .normal)
    
    setToMaximumButton = UIButton(type: .system)
    setToMaximumButton.setTitle("Set to Maximum", for: .normal)
    
    view.addSubview(slider)
    view.addSubview(textField)
    view.addSubview(setToMinimumButton)
    view.addSubview(setToMaximumButton)
    
    // Layout
    
    slider.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
      slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      slider.widthAnchor.constraint(equalToConstant: 200)
      ])
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
      textField.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 20),
      textField.widthAnchor.constraint(equalToConstant: 100)
      ])
    
    setToMinimumButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      setToMinimumButton.topAnchor.constraint(equalTo: slider.topAnchor, constant: 40),
      setToMinimumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      ])
    
    setToMaximumButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      setToMaximumButton.topAnchor.constraint(equalTo: slider.topAnchor, constant: 40),
      setToMaximumButton.leadingAnchor.constraint(equalTo: setToMinimumButton.trailingAnchor, constant: 20),
      ])
    
    // 'Wire up' the UI to reflect changes everywhere
    slider.addTarget(self, action: #selector(ManuallyWiringUpUIViewController.sliderChanged), for: .valueChanged)
    textField.delegate = self
    setToMinimumButton.addTarget(self, action: #selector(ManuallyWiringUpUIViewController.setToMinimumButtonClicked), for: .touchUpInside)
    setToMaximumButton.addTarget(self, action: #selector(ManuallyWiringUpUIViewController.setToMaximumButtonClicked), for: .touchUpInside)
    
    self.view = view
  }
  
  // Handle changes to value
  
  func sliderChanged() {
    textField.text = "\(slider.value)"
  }
  
  func setToMinimumButtonClicked() {
    slider.value = min
    textField.text = "\(min)"
  }
  
  func setToMaximumButtonClicked() {
    slider.value = max
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if (textField == textField) {
      // Update the slider
      if let text = textField.text, let float = Float(text) {
        if (min <= float && float <= max) {
          slider.value = float
        }
      }
      
      textField.resignFirstResponder()
      return false
    }
    return true
  }
  
}

PlaygroundPage.current.liveView = ManuallyWiringUpUIViewController()
