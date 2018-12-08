import UIKit


//Lightweith replacement of the UIViewController type
protocol UIViewControllerType{
    
}
/*
 Responsible for containing the global routing logic.
 */
class CoordinatorRepository{
    
    let theSharedState = NSObject()
    
    
    var masterCorrdinator : MasterCoordinatorType  {
        return MasterCoordinator(factory: DetailFactory(coordinator: detailCoordinator))
    }
    
    
    var detailCoordinator : DetailCoordinatorType{
        debugPrint("injected state \(theSharedState)")
        return DetailCoordinator(factory: MoreDetailFactory(userService: theSharedState)) //passing the shared state to the factory; you'd need to a coordinator if furthere navigation required from here
    }
    
    func start() -> Master{
        let initalVC = Master()
        initalVC.coordinator = masterCorrdinator
        
        return initalVC
    }
}


//MARK: MASTER VC Stack

/*
 Navigates based on concrete interfaces relevant only to the MASTER.
 */
protocol MasterCoordinatorType{
    
    func showDetail(from viewController: Master) -> UIViewControllerType//
}

/*
 Implements the navigation interface.  Holds a factory that creates the next instance.
 */
class MasterCoordinator : MasterCoordinatorType{
    
    let detailFactory : DetailFactoryType
    
    init(factory: DetailFactoryType) {
        
        detailFactory = factory
    }
    
    func showDetail(from viewController: Master) -> UIViewControllerType{ //returning instead of pushing for example sake; this may be ommitted if not needed
        //make the new VC using the factory
        let nextVC = detailFactory.makeDetail()
        
        //show the the Detail VC from a nav controller or through another presentor that can be injected into the coordinator
        return nextVC
    }
}
/*
 Defines an interface for creating a Detail VC.
 */
protocol DetailFactoryType {
    var detailCoordinator : DetailCoordinatorType {get}
    
    func makeDetail()-> UIViewControllerType
}
/*
 Creates an instance of a Detail VC and configures it with its relevant coordinator.
 */
class DetailFactory : DetailFactoryType{
    
    let detailCoordinator : DetailCoordinatorType
    
    required init(coordinator: DetailCoordinatorType) {
        self.detailCoordinator = coordinator
    }
    
    func makeDetail()-> UIViewControllerType{
        return Detail(coordinator: detailCoordinator)
    }
}

/*
 Serves as a stub for a ViewController. Depends only on its coordinator and passes the user action to its coordinator.
 */

class Master: UIViewControllerType{
    
    var coordinator : MasterCoordinatorType?
    
    func handleDetailPresentation() -> UIViewControllerType!{
        return coordinator?.showDetail(from: self)
    }
}


//MARK: DETAIL VC Stack. The individual types have the same responsibilities as in the MASTER stack.
protocol DetailCoordinatorType {
    
    func showMoreDetail(from detail: Detail) -> UIViewControllerType
}

class DetailCoordinator : DetailCoordinatorType{
    
    let moreDetailFactory : MoreDetailFactoryType
    
    init(factory: MoreDetailFactoryType){
        self.moreDetailFactory = factory
    }
    
    func showMoreDetail(from detail: Detail) -> UIViewControllerType{
        //make the new VC using the factory
        let nextVC = moreDetailFactory.makeMoreDetail()
        //show the the Detail VC from a nav controller or through another presentor that can be injected into the coordinator
        return nextVC
    }
}

protocol MoreDetailFactoryType {
    
    func makeMoreDetail() -> UIViewControllerType
}

class MoreDetailFactory : MoreDetailFactoryType{
    
    let userService : NSObject
    
    init(userService: NSObject){
        self.userService = userService
    }
    func makeMoreDetail() -> UIViewControllerType{
        
        let result = MoreDetail()
        result.someService = userService //injecting the shared state
        return result
    }
}

class Detail : UIViewControllerType{
    
    let coordinator : DetailCoordinatorType
    
    init(coordinator: DetailCoordinatorType) {
        self.coordinator = coordinator
    }
    
    func handelMoreDetailAction() -> UIViewControllerType{
        return coordinator.showMoreDetail(from: self)
    }
}

//MARK: MORE-DETAIL VC

class MoreDetail : UIViewControllerType, CustomStringConvertible{
    
    var someService : NSObject?
    
    var description: String{
        return "More detail VC with state \(someService?.description ?? "missing")"
    }
    
}

//MARK: USAGE

let repository = CoordinatorRepository()

let masterVC = repository.start()
let detailVC = masterVC.handleDetailPresentation()//simulates an action to present next vc
let moreDetailVC = (detailVC as! Detail).handelMoreDetailAction()//simulates an action to present next vc

debugPrint(moreDetailVC)
