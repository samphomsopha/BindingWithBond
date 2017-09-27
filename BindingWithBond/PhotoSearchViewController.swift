/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class PhotoSearchViewController: UIViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var resultsTable: UITableView!
  
  private let viewModel = PhotoSearchViewModel()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    _ = searchTextField.reactive.text
        .map { $0!.characters.count > 0 }
        .bind(to: activityIndicator.reactive.isAnimating)
    
    bindViewModel()
  }

    func bindViewModel() {
        viewModel.searchString.bidirectionalBind(to: searchTextField.reactive.text)
        viewModel.validSearchtext.map { $0 ? .black : .red}
            .bind(to: searchTextField.reactive.textColor)
        
        viewModel.searchResults.bind(to: resultsTable) { dataSource, IndexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: IndexPath) as! PhotoTableViewCell
            let photo = dataSource[IndexPath.row]
            cell.title.text = photo.title
            
            let backgroundQueue = DispatchQueue(label: "backgroundQueue",
                                                qos: .background,
                                                attributes: .concurrent,
                                                autoreleaseFrequency: .inherit,
                                                target: nil)
            cell.photo.image = nil
            backgroundQueue.async {
                if let imageData = try? Data(contentsOf: photo.url) {
                    DispatchQueue.main.async() {
                        cell.photo.image = UIImage(data: imageData)
                    }
                }
            }
            return cell
            
        }
        
        viewModel.searchInProgress
            .map { !$0 }
            .bind(to: activityIndicator.reactive.isHidden)
        
        viewModel.searchInProgress
            .map { $0 ? CGFloat(0.5) : CGFloat(1.0)}
            .bind(to: resultsTable.reactive.alpha)
        
        _ = viewModel.errorMessages.observeNext {
            [unowned self] error in
            
            let alertController = UIAlertController(title: "Something went wrong :-(", message: error, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let actionOk = UIAlertAction(title: "OK", style: .default,
                                         handler: { action in alertController.dismiss(animated: true, completion: nil) })
            
            alertController.addAction(actionOk)
        }
    }
}
