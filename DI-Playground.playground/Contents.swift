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
 Pushes routes to other VC based on concrete interfaces relevant to the MASTER. Contains a factory(ies) relevant to the individual navigation action.
 */
protocol MasterCoordinatorType{
    
    func showDetail(from viewController: Master)
}

class MasterCoordinator : MasterCoordinatorType{
    
    let detailFactory : DetailFactoryType
    
    init(factory: DetailFactoryType) {
        
        detailFactory = factory
    }
    
    func showDetail(from viewController: Master){
        
        //make the new VC using the factory
        //show the the Detail VC from a nav controller or through another presentor that can be injected into the coordinator
    }
}
/*
 Creates an instance of a VC and configures it with its relevant coordinator. Depends on the next VC's coordinatory protocol.
 */
protocol DetailFactoryType {
    var detailCoordinator : DetailCoordinatorType {get}
    
    func makeDetail()-> UIViewControllerType
}

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
 Serves as a stub for a ViewController. Depends only on its coordinator and passes user action to it, where the next VC is created and configured.
 */

class Master: UIViewControllerType{
    
    var coordinator : MasterCoordinatorType?
    
    func handleDetailPresentation(){
        coordinator?.showDetail(from: self)
    }
}


//MARK: DETAIL VC Stack. The individual have the same responsibilities as in the MASTER stack.
protocol DetailCoordinatorType {
    
    func pushMoreDetail(from detail: Detail)
}

class DetailCoordinator : DetailCoordinatorType{
    
    let moreDetailFactory : MoreDetailFactoryType
    
    init(factory: MoreDetailFactoryType){
        self.moreDetailFactory = factory
    }
    
    func pushMoreDetail(from detail: Detail){
        
        //make the new VC using the factory
        //show the the Detail VC from a nav controller or through another presentor that can be injected into the coordinator
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
    
    func handelMoreDetailAction(){
        coordinator.pushMoreDetail(from: self)
    }
}

//MARK: MORE-DETAIL VC

class MoreDetail : UIViewControllerType{
    
    var someService : NSObject?
    
}
