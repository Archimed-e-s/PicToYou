import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let favouriteTableViewController = FavouriteTableViewController()
        let imagesCollectionViewController = ImagesCollectionViewController()


        
        viewControllers = [
            generateNavigationController(rootViewController: imagesCollectionViewController, title: "Picture", image: UIImage(systemName: "figure.walk.diamond.fill")!),
            generateNavigationController(rootViewController: favouriteTableViewController, title: "Favourite", image: UIImage(systemName: "heart.fill")!),
        ]
    }
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
