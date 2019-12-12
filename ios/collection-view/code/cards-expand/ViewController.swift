import UIKit

class ViewController: UIViewController {
    
    var containerView: UICollectionView!
    var items: [String] = ["A", "B", "C", "D", "E", "F", "G", "H"]
    let pinterestLayout = PinterestLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow

        createLayout()
    }
    
    private func createLayout() {
        
//        containerView = UICollectionView(frame: .zero, collectionViewLayout: CustomCollectionViewLayout(cardSize: CGSize(width: 250, height: 350)))
        
        pinterestLayout.delegate = self
        containerView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        containerView.dataSource = self
        containerView.delegate = self
        containerView.register(CellView.self, forCellWithReuseIdentifier: CellView.identifier)

        containerView.backgroundColor = .gray
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellView.identifier, for: indexPath) as! CellView
        
        cell.labelData = items[indexPath.row]
        cell.setData(containerCollectionView: collectionView, cellSize: CGSize(width: 250, height: 350), index: indexPath.row)
        
        return cell
    }
    
    
}


