import UIKit
import RealmSwift

class FavouriteTableViewController: UIViewController {
    
    private static let id = UUID().uuidString
    private var model: [FavouriteImageModel] = []
    private var filteredModel: [FavouriteImageModel] = []
    private let realmService = RealmServices()
    private let realm = try! Realm()
    
    
    lazy var favouriteTable: UITableView = {
        let favouriteTable = UITableView()
        favouriteTable.translatesAutoresizingMaskIntoConstraints = false
        favouriteTable.backgroundColor = .lightGray
        favouriteTable.separatorStyle = .singleLine
        favouriteTable.register(FavouriteTableViewCell.self, forCellReuseIdentifier: FavouriteTableViewController.id)
        return favouriteTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteTable.delegate = self
        favouriteTable.dataSource = self
        favouriteTable.reloadData()
        view.addSubview(favouriteTable)
        NSLayoutConstraint.activate([
            favouriteTable.topAnchor.constraint(equalTo: view.topAnchor),
            favouriteTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favouriteTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouriteTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            model = try realmService.getAllFavouriteObject()
            filteredModel = model
            favouriteTable.reloadData()
        } catch {
            print("error - \(error)")
        }
        
    }
}



extension FavouriteTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteTable.dequeueReusableCell(withIdentifier: FavouriteTableViewController.id, for: indexPath) as! FavouriteTableViewCell
        cell.configureCell(from: filteredModel[indexPath.row])
        return cell
    }
    
}


extension FavouriteTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let alert = UIAlertController(title: "Warning", message: "Are you really want to delete this cell?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            try! self.realm.write {
                self.realm.delete(self.model[indexPath.item])
            }
            self.model.remove(at: indexPath.row)
            self.filteredModel = self.model
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }))
        present(alert, animated:  true)
    }
}


