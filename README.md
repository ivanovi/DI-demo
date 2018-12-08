# DI-demo

This is just a playground containing a mental exercise on dependency injection. 

It should illustrate a structure of three view controllers, displayed sequentionally one after the other:

Master -> Detail -> MoreDetail

The architecture allows for injecting a dependency into the last ViewController node without passing it through the entire chain. It also attempts to decouple the individual view controllers from each other. This may help to significanly improve the testability of the individual ViewController type.

The main building blocks are:

- *Coordinator Repository*: Contains all  and other shared states. Implements the linking logic between the different stacks (Master, MasterCoordinator, DetailFactory etc. )
- *Concrete Cooordinator*: Each specific ViewController depends on a coordinator; it performs the navigation actions by delegation. The coordinator holds a factory relevant to each navigation action. The current assimption is that the Coordinator can present the next ViewControlller without an additional presenter (e.g. using its navigation controller), should this not be the case a presenter can be created and passed from the *Coordinator Repository*.
- *Concrete factory*: Responsible for initialising and configuring a specific ViewController. It is normally owned by a coordinator and injected by the *CoordinatorRepository* into the Coordinator.
- *Concrete ViewController*: The ViewController to be presented on the screen.

All types that are marked as concrete are actually passed between the different layers as a protocol dependency.

