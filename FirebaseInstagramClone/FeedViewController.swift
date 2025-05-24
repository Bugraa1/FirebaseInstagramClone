import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var emailArray = [String]()
    var commentArray = [String]()
    var imageArray = [String]()
    var likeArray = [Int]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        getDataFirestore()
        
    }
    
    func getDataFirestore() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "error")
            } else {
                
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.emailArray.removeAll(keepingCapacity: false)
                    self.commentArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.emailArray.append(postedBy)
                        }
                        if let comment = document.get("postComment") as? String {
                            self.commentArray.append(comment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.imageArray.append(imageUrl)
                        }
                        
                     }
                    
                    self.tableView.reloadData()
                }
            }
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = emailArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: imageArray[indexPath.row]))
        cell.userCommentLabel.text = commentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        
        return cell
        
    }
    

   

}
