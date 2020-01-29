# Page Controls - swipe cards (carousel) like

```
import UIKit

class PageControls: UIViewController {
    
   let pageViewController = PageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pageViewContainer = UIView()
        view.addSubview(pageViewContainer)
        pageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        pageViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        pageViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        pageViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        pageViewContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
                
        /// !!!!!
        addChild(pageViewController)
        
        pageViewContainer.addSubview(pageViewController.view)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.leftAnchor.constraint(equalTo: pageViewContainer.leftAnchor, constant: 0).isActive = true
        pageViewController.view.rightAnchor.constraint(equalTo: pageViewContainer.rightAnchor, constant: 0).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: pageViewContainer.topAnchor, constant: 0).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: pageViewContainer.bottomAnchor, constant: 0).isActive = true
        
        /// !!!!!
        pageViewController.didMove(toParent: self)
        
        
        
        let close = UIButton()
        view.addSubview(close)
        close.setTitle("close", for: .normal)
        close.setTitleColor(.black, for: .normal)
        close.backgroundColor = .white
        close.frame = CGRect(x: 100, y: 500, width: 250, height: 30)
        close.addTarget(self, action: #selector(closeAction), for: .touchDown)
    }
    
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
    
}

class PageViewController: UIPageViewController {
    
    var pages: [UIViewController] = []
    let pageControl = UIPageControl()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        let p1 = PageView()
        p1.bgColor = .green
        let p2 = PageView()
        p2.bgColor = .black
        let p3 = PageView()
        p3.bgColor = .blue
        pages = [p1, p2, p3]
        
        setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        
        
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        pageControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
}


// MARK: - Page View Controller Data Source
extension PageViewController: UIPageViewControllerDataSource {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
//            if viewControllerIndex == 0 {
//                return nil // self.pages.last
//            } else {
//                return self.pages[viewControllerIndex - 1]
//            }
            
            if viewControllerIndex > 0 {
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.firstIndex(of: viewController) {
//            if viewControllerIndex < self.pages.count - 1 {
//                return self.pages[viewControllerIndex + 1]
//            } else {
//                return nil // self.pages.first
//            }
            
            if viewControllerIndex < self.pages.count - 1 {
                return self.pages[viewControllerIndex + 1]
            }
        }
        return nil
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {

        guard let firstVC = pageViewController.viewControllers?.first else {
            return 0
        }
        guard let firstVCIndex = pages.firstIndex(of: firstVC) else {
            return 0
        }

        return firstVCIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
}


class PageView: UIViewController {
    var bgColor: UIColor? {
        didSet {
            self.view.backgroundColor = self.bgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
}

```