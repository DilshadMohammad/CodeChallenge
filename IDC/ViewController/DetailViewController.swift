import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    var event: Event!
    var array = UserDefaults.standard.array(forKey: "favoriteIds")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Details"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = event.title
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonAction(_:)), for: .touchUpInside)

        if let imageUrl = event.performers?.first?.image {
            cell.imgView?.sd_setImage(with: URL(string: imageUrl), completed: { (image, error, SDImageCacheType, url) in
                cell.imgView?.image = image
            })
        }
        cell.dateLabel.text = Date.getFormattedDate(string: event.datetime ?? "")
        cell.locationLabel.text = event.venue?.displayLocation

        if let filtered = array?.filter({ ($0 as? Int) == event.id }), filtered.count > 0 {
            cell.favoriteButton.isSelected = true
        } else {
            cell.favoriteButton.isSelected = false
        }
        return cell
    }
    
    @objc func favoriteButtonAction(_ sender: UIButton) {
        if array == nil {
            array = []
        }
        if let filtered = array?.filter({ ($0 as? Int) == event.id }), filtered.count > 0 {
            if let index = array?.index(where: { ($0 as? Int) == (event.id ?? 0) }) {
                array?.remove(at: index)
            }
        } else {
            array?.append(event.id)
        }
        let uniqueArray = NSSet(array: array ?? []).allObjects
        UserDefaults.standard.setValue(uniqueArray, forKey: "favoriteIds")
        detailTableView.reloadData()
    }
}
