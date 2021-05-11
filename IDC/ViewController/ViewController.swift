import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var searchResults: [Event] = []
    var searchBar: UISearchBar!
    var array = UserDefaults.standard.array(forKey: "favoriteIds")
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        navigationController?.navigationBar.tintColor = .white
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        getEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        array = UserDefaults.standard.array(forKey: "favoriteIds")
        tableView.reloadData()
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 40, height: 40))
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search by event name"
        navigationItem.titleView = searchBar
    }

    func getEvents(_ query: String = "") {
        ServerHelper.shared.getEventsForSearchQuery(query) { [weak self] (response, status) in
            if let data = response as? [Event] {
                self?.searchResults = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let event = searchResults[indexPath.row]
        cell.titleLabel.text = event.title
        cell.detailLabel.text = """
            \(event.venue?.displayLocation ?? "")
            \(Date.getFormattedDate(string: event.datetime ?? ""))
            """
        if let imageUrl = event.performers?.first?.image {
            cell.iconImageView?.sd_setImage(with: URL(string: imageUrl), completed: { (image, error, SDImageCacheType, url) in
                cell.iconImageView?.image = image
            })
        }
        
        if let filtered = array?.filter({ ($0 as? Int) == event.id }), filtered.count > 0 {
            cell.favoriteButton.isHidden = false
        } else {
            cell.favoriteButton.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: indexPath)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail", let indexPath = sender as? IndexPath {
            if let vc = segue.destination as? DetailViewController {
                vc.event = searchResults[indexPath.row]
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getEvents(searchText)
    }
}
