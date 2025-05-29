import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        // 1. Создаем контроллеры в нужном порядке
        let savingsVC = SavingsViewController()
        let homeVC = HomeViewController()
        let profileVC = ProfileViewController()
        
        // 2. Оборачиваем в NavigationController
        let savingsNav = UINavigationController(rootViewController: savingsVC)
        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        // 3. Настраиваем иконки и заголовки
        savingsNav.tabBarItem = UITabBarItem(
            title: "Накопления",
            image: UIImage(systemName: "banknote.fill"),
            tag: 0
        )
        
        homeNav.tabBarItem = UITabBarItem(
            title: "Главная",
            image: UIImage(systemName: "house.fill"),
            tag: 1
        )
        
        profileNav.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.fill"),
            tag: 2
        )
        
        // 4. Устанавливаем контроллеры в нужном порядке
        viewControllers = [savingsNav, homeNav, profileNav]
        
        // 5. Делаем "Главную" активной по умолчанию
        selectedIndex = 1
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
        
        // Добавляем тень для красоты
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 3
    }
}
