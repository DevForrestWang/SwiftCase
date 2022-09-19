//
//===--- DesignPatternViewController.swift - Defines the DesignPatternViewController class ----------===//
//
// This source file is part of the SwiftCase open source project
//
// Created by wangfd on 2021/9/26.
// Copyright © 2021 SwiftCase. All rights reserved.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See more information
//
//===----------------------------------------------------------------------===//

import UIKit

class DesignPatternViewController: ItemListViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pattern"
    }

    // MARK: - Public

    override func itemDataSource() -> [ItemListViewController.SCItemModel]? {
        return [
            SCItemModel(title: "Creational-Singleton", controllerName: "Singleton", action: #selector(testSingleton)),
            SCItemModel(title: "Creational-Factory", controllerName: "CurrencyFactory", action: #selector(testFactoryPattern)),
            SCItemModel(title: "Creational-Factory2", controllerName: "ProjectorFactoryClientCode", action: #selector(testProjectorFactory)),
            SCItemModel(title: "Creational-AbstractFactory", controllerName: "BurgerFactoryType", action: #selector(testAbstractFactory)),
            SCItemModel(title: "Creational-AbstractFactory2", controllerName: "AuthViewClientCode", action: #selector(testAuthViewAbstractFactory)),
            SCItemModel(title: "Creational-Builder", controllerName: "URLBuilder", action: #selector(testBuilder)),
            SCItemModel(title: "Creational-Builder2", controllerName: "BuilderClient", action: #selector(testStepBuilder)),
            SCItemModel(title: "Creational-Prototype", controllerName: "PPAuthor", action: #selector(testPagePrototype)),

            SCItemModel(title: "Structural-Proxy", controllerName: "ProxyClient", action: #selector(testProfileProxy)),
            SCItemModel(title: "Structural-Bridge", controllerName: "BridgeClient", action: #selector(testContentShareBridge)),
            SCItemModel(title: "Structural-Decorator", controllerName: "DecoratorClient", action: #selector(testImageDecorator)),
            SCItemModel(title: "Structural-Adapte", controllerName: "FaceBookAuthSDK", action: #selector(testAdapteAuth)),
            SCItemModel(title: "Structural-Flyweight", controllerName: "FlyweightFactory", action: #selector(testFlyweight)),
            SCItemModel(title: "Structural-Composite", controllerName: "ComponentClient", action: #selector(testDPComposite)),

            SCItemModel(title: "Behavioral-Observer", controllerName: "CarManager", action: #selector(testCartSubscriber)),
            SCItemModel(title: "Behavioral-Template Method", controllerName: "CameraAccessor", action: #selector(testAccessorTemplate)),
            SCItemModel(title: "Behavioral-Strategy", controllerName: "StrategyClient", action: #selector(testDataSouceStrategy)),
            SCItemModel(title: "Behavioral-ChainResponsibility", controllerName: "SignUpHandler", action: #selector(testChainResponsibility)),
            SCItemModel(title: "Behavioral-Iterator", controllerName: "TreeIterator", action: #selector(testTreeIterator)),
            SCItemModel(title: "Behavioral-State", controllerName: "LocationTracker", action: #selector(testTrackingState)),
            SCItemModel(title: "Behavioral-Visitor", controllerName: "VisitorClient", action: #selector(testNotificationVisitor)),
            SCItemModel(title: "Behavioral-Memento", controllerName: "TMUndoStack", action: #selector(testTextViewMemento)),
            SCItemModel(title: "Behavioral-Mediator", controllerName: "ScreenMediator", action: #selector(testScreenMediator)),
            SCItemModel(title: "Behavioral-Interpreter", controllerName: "IntegerVariableExpression", action: #selector(testDPInterpreter)),
        ]
    }

    // MARK: - Protocol

    // MARK: - IBActions

    // MARK: - Private

    // MARK: - Creational

    @objc func testSingleton() throws {
        fwPrintEnter(message: "Run testSingleton")
        let slgp = SingletonPattern.shared
        slgp.publicFunction()
        fwShowToast("Successed run publicFunction")

        // methods2：
        let instance1 = Singleton.shared
        let instance2 = Singleton.shared
        fwDebugPrint(instance1.someBusinessLogic())
        fwDebugPrint(instance1 === instance2)
    }

    @objc func testFactoryPattern() throws {
        fwPrintEnter(message: "Run testFactoryPattern")
        let noCurrencyCode = "No Currency Code Available"

        fwDebugPrint(CurrencyFactory.currency(for: .greece)?.code ?? noCurrencyCode)
        fwDebugPrint(CurrencyFactory.currency(for: .spain)?.code ?? noCurrencyCode)
        fwDebugPrint(CurrencyFactory.currency(for: .unitedStates)?.code ?? noCurrencyCode)

        let uk = CurrencyFactory.currency(for: .uk)?.code ?? noCurrencyCode
        fwDebugPrint(uk)
    }

    @objc func testProjectorFactory() {
        fwPrintEnter(message: "Run testProjectorFactory")

        let info = "Very important info of the presentation"
        let clientCode = ProjectorFactoryClientCode()

        /// Present info over WiFi
        clientCode.present(info: info, with: WifiFactory())

        /// Present info over Bluetooth
        clientCode.present(info: info, with: BluetoothFactory())
    }

    @objc func testAbstractFactory() throws {
        fwPrintEnter(message: "Run testAbstractFactory")
        let bigKahuna = BurgerFactoryType.bigKahuna.make()
        fwDebugPrint(bigKahuna)

        let jackInTheBox = BurgerFactoryType.jackInTheBox.make()
        fwDebugPrint(jackInTheBox)
    }

    @objc func testAuthViewAbstractFactory() throws {
        fwPrintEnter(message: "Run testAuthViewAbstractFactory")

        let teacherMode = false
        let clientCode: AuthViewClientCode

        if teacherMode {
            clientCode = AuthViewClientCode(factoryType: TeacherAuthViewFactory.self)
        } else {
            clientCode = AuthViewClientCode(factoryType: StudentAuthViewFactory.self)
        }

        /// Present LogIn flow
        clientCode.presentLogin()
        fwDebugPrint("Login screen has been presented")

        /// Present SignUp flow
        clientCode.presentSignUp()
        fwDebugPrint("Sign up screen has been presented")
    }

    @objc func testBuilder() throws {
        fwPrintEnter(message: "Run testBuilder")
        let url = URLBuilder()
            .set(scheme: "https")
            .set(host: "localhost")
            .set(path: "api/v1")
            .addQueryItem(name: "sort", value: "name")
            .addQueryItem(name: "order", value: "asc")
            .build()
        fwDebugPrint(url ?? "URL is nil")
        fwPrintLine()
    }

    @objc func testStepBuilder() throws {
        fwPrintEnter(message: "Client: Start testStepBuilder")
        let client = BuilderClient()
        client.clientCode(builder: RealmQueryBuilder<SBUser>())

        fwDebugPrint()

        fwPrintEnter(message: "Client: Start fetching data from CoreData")
        client.clientCode(builder: CoreDataQueryBuilder<SBUser>())
        fwPrintLine()
    }

    @objc func testPagePrototype() throws {
        fwPrintEnter(message: "Client: Start testPagePrototype")
        let author = PPAuthor(id: 10, username: "Ivan_83")
        let page = PPPage(title: "My First Page", contents: "Hello world", author: author)
        page.add(comment: PPComment(message: "Keep is up!"))

        guard let anotherPage = page.copy() as? PPPage else {
            fwDebugPrint("Page was not copyied")
            return
        }

        /// Comments should be empty as it is a new page.
        fwDebugPrint(author.pageCount == 2)

        fwDebugPrint("Original title: " + page.title)
        fwDebugPrint("Copied title: " + anotherPage.title)
        fwDebugPrint("Count of pages: " + String(author.pageCount))

        fwPrintLine()
    }

    // MARK: - Structural

    @objc func testProfileProxy() throws {
        fwPrintEnter(message: "Client: Start testProfileProxy")

        fwDebugPrint("Client: Loading a profile WITHOUT proxy")
        let profile = ProxyClient()
        profile.loadBasicProfile(with: PPKeychain())
        profile.loadProfileWithBankAccount(with: PPKeychain())

        fwDebugPrint("\nClient: Let's load a profile WITH proxy")
        profile.loadBasicProfile(with: ProfileProxy())
        profile.loadProfileWithBankAccount(with: ProfileProxy())

        fwPrintLine()
    }

    @objc func testContentShareBridge() throws {
        fwPrintEnter(message: "Client: Start testProfileProxy")

        let bridge = BridgeClient()
        fwDebugPrint("Client: Pushing Photo View Controller...")
        bridge.push(PhotoViewController())

        fwDebugPrint()

        fwDebugPrint("Client: Pushing Feed View Controller...")
        bridge.push(FeedViewController())

        fwPrintLine()
    }

    @objc func testImageDecorator() {
        fwPrintEnter(message: "Client: Start testImageDecorator")
        let client = DecoratorClient()
        var image = client.loadImage(urlString: "https://refactoring.guru/images/content-public/logos/logo-new-3x.png")

        fwDebugPrint("Client: set up an editors stack")
        let resizer = Resizer(image, xScale: 0.2, yScale: 0.2)
        image = resizer.applay()

        let blurFilter = BlurFilter(resizer)
        blurFilter.update(radius: 2)
        image = blurFilter.applay()

        let colorFilter = ColorFilter(blurFilter)
        colorFilter.update(contrast: 0.53)
        colorFilter.update(brightness: 0.12)
        colorFilter.update(saturation: 4)
        image = colorFilter.applay()

        client.clientCode(editor: colorFilter)
        fwPrintLine()
    }

    @objc func testAdapteAuth() throws {
        fwPrintEnter(message: "Client: Start testAdapteAuth")
        let topViewController = UIViewController()
        let faceBookSDK = FaceBookAuthSDK()
        faceBookSDK.presentAuthFlow(form: topViewController)

        let twitterSDK = TwitterAuthSDK()
        twitterSDK.presentAuthFlow(form: topViewController)
        fwPrintLine()
    }

    @objc func testFlyweight() throws {
        fwPrintEnter(message: "Client: Start testDPInterpreter")

        /// The client code usually creates a bunch of pre-populated flyweights
        /// in the initialization stage of the application.
        let factory = FlyweightFactory(states:
            [
                ["Chevrolet", "Camaro2018", "pink"],
                ["Mercedes Benz", "C300", "black"],
                ["Mercedes Benz", "C500", "red"],
                ["BMW", "M5", "red"],
                ["BMW", "X6", "white"],
            ])
        factory.printFlyweights()

        let client = FlyweightClient()
        client.addCarToPoliceDatabase(factory,
                                      "CL234IR",
                                      "James Doe",
                                      "BMW",
                                      "M5",
                                      "red")

        client.addCarToPoliceDatabase(factory,
                                      "CL234IR",
                                      "James Doe",
                                      "BMW",
                                      "X1",
                                      "red")

        factory.printFlyweights()

        fwPrintLine()
    }

    @objc func testDPComposite() throws {
        fwPrintEnter(message: "Client: Start testDPInterpreter")

        /// This way the client code can support the simple leaf components...
        fwDebugPrint("Client: I've got a simple component:")
        ComponentClient.clientCode(component: DPLeaf())

        /// ...as well as the complex composites.
        let tree = DPComposite()

        let branch1 = DPComposite()
        branch1.add(component: DPLeaf())
        branch1.add(component: DPLeaf())

        let branch2 = DPComposite()
        branch2.add(component: DPLeaf())
        branch2.add(component: DPLeaf())

        tree.add(component: branch1)
        tree.add(component: branch2)

        fwDebugPrint("\nClient: Now I've got a composite tree:")
        ComponentClient.clientCode(component: tree)

        fwDebugPrint("\nClient: I don't need to check the components classes even when managing the tree:")
        ComponentClient.moreComplexClient(leftComponent: tree, rightComponent: DPLeaf())

        fwPrintLine()
    }

    // MARK: - Behavioral

    @objc func testCartSubscriber() {
        fwPrintEnter(message: "Client: Start testCartSubscriber")

        let cartManager = CarManager()
        cartManager.add(subscriber: UINavigationBar())
        cartManager.add(subscriber: CartViewController())

        let apple = DSFood(id: 111, name: "Apple", price: 10, calories: 20)
        cartManager.add(product: apple)

        let tShirt = DSClothes(id: 222, name: "T-shirt", price: 200, size: "L")
        cartManager.add(product: tShirt)

        cartManager.remove(product: apple)
        fwPrintLine()
    }

    @objc func testAccessorTemplate() throws {
        fwPrintEnter(message: "Client: Start testAccessorTemplate")
        let accessors = [CameraAccessor(), MicrophoneAccessor(), PhotoLibraryAccessor()]
        accessors.forEach { item in
            item.requestAccessIfNeeded { status in
                let message = status ? "You have access to " : "You do not have access to "
                fwDebugPrint(message + item.description + "\n")
            }
        }

        fwPrintLine()
    }

    @objc func testDataSouceStrategy() throws {
        fwPrintEnter(message: "Client: Start testDataSouceStrategy")
        let client = StrategyClient()
        let strategy = DataSourceStrategy()
        let memoyrStorage = MemoryStorage<DSUser>()
        memoyrStorage.add(client.usersFormNetWork())

        client.clientCode(use: strategy, with: memoyrStorage)
        client.clientCode(use: strategy, with: CoreDataStorage())
        client.clientCode(use: strategy, with: RealmStorage())

        fwPrintLine()
    }

    @objc func testChainResponsibility() throws {
        fwPrintEnter(message: "Client: Start testChainResponsibility")
        fwDebugPrint("Client: Let's test Login flow!")
        let loginHandler = LoginHandler(with: LocationHandler())
        let loginController = LoginViewController(handler: loginHandler)
        loginController.loginButtonSelected()

        fwDebugPrint("\nClient: Let's test SignUp flow!")
        let signUpHandler = SignUpHandler(with: LocationHandler(with: NotificationHandler()))
        let signUpController = SignUpViewController(handler: signUpHandler)
        signUpController.signUpButtonSelected()

        fwPrintLine()
    }

    @objc func testTreeIterator() throws {
        fwPrintEnter(message: "Client: Start testTreeIterator")
        let tree = TreeIterator(1)
        tree.left = TreeIterator(2)
        tree.right = TreeIterator(3)

        let client = IteratorClient()
        fwDebugPrint("Tree traversal: Inorder")
        client.clientCode(iterator: tree.iterator(.inOrder))

        fwDebugPrint("Tree traversal: Preorder")
        client.clientCode(iterator: tree.iterator(.preOrder))

        fwDebugPrint("Tree traversal: Postorder")
        client.clientCode(iterator: tree.iterator(.postOrder))

        fwPrintLine()
    }

    @objc func testTrackingState() throws {
        fwPrintEnter(message: "Client: Start testTrackingState")
        fwDebugPrint("Client: I'm starting working with a location tracker")
        let tracker = LocationTracker()

        fwDebugPrint()
        tracker.startTracking()

        fwDebugPrint()
        tracker.pauseTracking(for: 2)

        fwDebugPrint()
        tracker.makeCheckIn()

        fwDebugPrint()
        tracker.findMyChildren()

        fwDebugPrint()
        tracker.stopTracking()
        fwPrintLine()
    }

    @objc func testNotificationVisitor() throws {
        fwPrintEnter(message: "Client: Start testNotificationVisitor")

        let email = NVEmail(emailOfSender: "some@email.com")
        let sms = NVSMS(phoneNumberOfSender: "+3806700000")
        // 在黑名单里
        let push = NVPush(userNameOfSender: "Spammer")
        let notifications: [NVNotification] = [email, sms, push]
        let client = VisitorClient()

        client.clientCode(handle: notifications, with: DefaultPolicyVisitor())
        client.clientCode(handle: notifications, with: NightPolicyVistor())
        fwPrintLine()
    }

    @objc func testTextViewMemento() throws {
        fwPrintEnter(message: "Client: Start testTextViewMemento")
        let textView = UITextView()
        let undoStack = TMUndoStack(textView)

        textView.text = "First Change"
        undoStack.save()

        textView.text = "Second Change"
        undoStack.save()

        textView.text = (textView.text ?? "") + " & Third Change"
        textView.textColor = .red
        undoStack.save()

        fwDebugPrint(undoStack)

        fwDebugPrint("Client: Perform Undo operation 2 times\n")
        undoStack.undo()
        undoStack.undo()
        fwDebugPrint(undoStack)

        fwPrintLine()
    }

    @objc func testScreenMediator() throws {
        fwPrintEnter(message: "Client: Start testScreenMediator")

        let newsArray = [SMNews(id: 1, title: "News1", likeCount: 1),
                         SMNews(id: 2, title: "News2", likeCount: 2)]

        let numberOfGivenLikes = newsArray.reduce(0) { $0 + $1.likeCount }

        let mediator = ScreenMediator()

        let feedVC = NewFeedViewController(mediator, newsArray)
        let newsDetailVC = NewDetailViewController(mediator, newsArray.first!)
        let profileVC = ProfileViewController(mediator, numberOfGivenLikes)

        mediator.update([feedVC, newsDetailVC, profileVC])

        feedVC.userLikedAllNews()
        feedVC.userDislikedAllNews()

        fwPrintLine()
    }

    @objc func testDPInterpreter() throws {
        fwPrintEnter(message: "Client: Start testDPInterpreter")

        let aV = 5
        let bV = 1
        let cV = 3
        let a = IntegerVariableExpression(name: "A")
        let b = IntegerVariableExpression(name: "B")
        let c = IntegerVariableExpression(name: "C")

        let context = IntegerContext()
        context.assign(expression: a, value: aV)
        context.assign(expression: b, value: bV)
        context.assign(expression: c, value: cV)

        let addExpression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c)) // a + (b + c)
        var result = addExpression.evaluate(context)
        fwDebugPrint("A + (B + C) = \(aV) + (\(bV) + \(cV)) = \(result)")

        let subExpression = SubtractionExpresion(op1: a, op2: AddExpression(op1: b, op2: c))
        result = subExpression.evaluate(context)
        fwDebugPrint("A - (B + C) = \(aV) - (\(bV) + \(cV)) = \(result)")
        fwPrintLine()
    }

    // MARK: - UI

    // MARK: - Constraints

    // MARK: - Constraints

    // MARK: - Property
}
