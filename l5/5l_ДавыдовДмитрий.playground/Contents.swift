import UIKit

enum StateCategory {
    case windows, engine
}

protocol TrunkProtocol {
    mutating func loadTrunk(_ size: UInt) -> Void
    mutating func unloadTrunk(_ size: UInt) -> Void
}

protocol Trunkable: TrunkProtocol {
    var trunk: Trunk {get set}
}

extension Trunkable {
    mutating func loadTrunk(_ size: UInt) -> Void {
        if !trunk.canLoad(size: size) {
            return
        }

        trunk.load(size)
    }

    mutating func unloadTrunk(_ size: UInt) -> Void {
        if !trunk.canUnload(size: size) {
            return
        }

        trunk.unload(size)
    }
}

protocol TrunkChainable: TrunkProtocol {
    var trunkChain: [Trunk] {get set}
    var maxTrunkChainNumber: UInt {get set}
    
    mutating func attachTrunk(size: UInt) -> Void
    mutating func detachTrunk() -> Void
}

extension TrunkChainable {
    mutating func loadTrunk(_ size: UInt) -> Void {
        for i in trunkChain.indices {
            if !trunkChain[i].canLoad(size: size) {
                continue
            }

            trunkChain[i].load(size)
            break
        }
    }

    mutating func unloadTrunk(_ size: UInt) -> Void {
        for i in trunkChain.indices.reversed() {
            print(i)
            if !trunkChain[i].canUnload(size: size) {
                continue
            }

            trunkChain[i].unload(size)
            break
        }
    }
    
    mutating func attachTrunk(size: UInt) -> Void {
        if maxTrunkChainNumber <= trunkChain.count {
            return
        }
        trunkChain.append(Trunk(size: size))
    }

    mutating func detachTrunk() -> Void {
        if trunkChain.count == 0 {
            return
        }
        trunkChain.remove(at: trunkChain.count - 1)
    }
}


protocol CarProtocol {
    var states: [StateCategory: BooleanStateProtocol] {get set}
    func asString() -> String
    func addState(state: BooleanStateProtocol) -> Self
    func changeState(stateCategory: StateCategory, value: Bool) -> Void
}

protocol BooleanStateProtocol {
    var category: StateCategory {get set}
    var name: String {get set}
    var trueStateTitle: String {get set}
    var falseStateTitle: String {get set}
    var value: Bool {get set}
    
    func asString() -> String
}

struct State: BooleanStateProtocol {
    var category: StateCategory
    var name: String
    var trueStateTitle: String
    var falseStateTitle: String
    
    var value: Bool = false
    
    func asString() -> String {
        return "\(name) is \(value ? trueStateTitle : falseStateTitle)"
    }
}

enum Actions {
    enum Cargo {
        case Load, Unload
    }

    enum Engine {
        case Start, Stop
    }

    enum Windows {
        case Open, Close
    }
}

struct Trunk {
    var totalSize: UInt
    var usedSize: UInt = 0
    var freeSize: UInt {
        return totalSize - usedSize
    }

    init(size: UInt) {
        self.totalSize = size
    }

    mutating func load(_ size: UInt) {
        self.usedSize += size
    }
    mutating func unload(_ size: UInt) {
        self.usedSize -= size
    }

    func canLoad(size: UInt) -> Bool {
        return freeSize >= size
    }

    func canUnload(size: UInt) -> Bool {
        return Int(freeSize) - Int(size) >= 0
    }

    func state() -> String {
        return "Used \(usedSize) of \(totalSize)"
    }
}

class Car: CarProtocol, CustomStringConvertible {
    let brand: String
    let manufacturedAtYear: UInt
    var description: String {
        get {
            return self.asString()
        }
    }
    var states: [StateCategory: BooleanStateProtocol] = [:]
    
    func addState(state: BooleanStateProtocol) -> Self {
        states[state.category] = state
        
        return self
    }
    
    func changeState(stateCategory: StateCategory, value: Bool) {
        guard states[stateCategory] != nil else {
            print("State \(stateCategory) is not available")
            return
        }
        
        states[stateCategory]!.value = value
    }

    init(brand: String, manufacturedAtYear: UInt) {
        self.brand = brand
        self.manufacturedAtYear = manufacturedAtYear
    }

    func asString() -> String {
        var descriptionParts: [String] = [
            "Brand: \(self.brand)",
            "Manufactured At: \(self.manufacturedAtYear)",
        ]
        
        for (_, state) in states {
            descriptionParts.append(state.asString())
        }
        
        return descriptionParts.joined(separator: "\n")
    }
}

class SportCar: Car, Trunkable {
    var trunk: Trunk

    init(brand: String, manufacturedAtYear: UInt, trunkSize: UInt) {
        self.trunk = Trunk(size: trunkSize)
        super.init(brand: brand, manufacturedAtYear: manufacturedAtYear)

    }

    override func asString() -> String {
        return """
        \(super.asString())
        Trunk: \(trunk.state())
        """
    }
}

class TrunkCar: Car, TrunkChainable {
    var trunkChain: [Trunk] = []
    var maxTrunkChainNumber: UInt
    

    init(brand: String, manufacturedAtYear: UInt, maxTrunksCount: UInt) {
        self.maxTrunkChainNumber = maxTrunksCount
        super.init(brand: brand, manufacturedAtYear: manufacturedAtYear)
    }

    override func asString() -> String {
        var descriptionParts: [String] = [
            super.asString()
        ]

        if trunkChain.count == 0 {
            descriptionParts.append("Trunk is not attached")
        } else {
            descriptionParts.append("Attached \(trunkChain.count) trunks")
        }

        for t in trunkChain {
            descriptionParts.append(t.state())
        }

        return descriptionParts.joined(separator: "\n")
    }
}


var tc1 = TrunkCar(brand: "Volvo", manufacturedAtYear: 2020, maxTrunksCount: 3)
tc1
    .addState(state: State(category: StateCategory.engine, name: "Engine", trueStateTitle: "started", falseStateTitle: "closed"))
    .addState(state: State(category: StateCategory.windows, name: "Windows", trueStateTitle: "opened", falseStateTitle: "closed"))

tc1.attachTrunk(size: 10)
tc1.attachTrunk(size: 100)
tc1.attachTrunk(size: 1_000)

tc1.loadTrunk(11)
tc1.loadTrunk(11)
tc1.loadTrunk(79)

tc1.changeState(stateCategory: .engine, value: true)

var tc2 = TrunkCar(brand: "MB", manufacturedAtYear: 1990, maxTrunksCount: 1)
tc2
    .addState(state: State(category: StateCategory.engine, name: "Engine", trueStateTitle: "started", falseStateTitle: "closed"))
    .addState(state: State(category: StateCategory.windows, name: "Windows", trueStateTitle: "opened", falseStateTitle: "closed"))

tc2.attachTrunk(size: 20_000)
tc2.loadTrunk(10_000)
tc2.changeState(stateCategory: .engine, value: true)

var sc1 = SportCar(brand: "VAZ 2108", manufacturedAtYear: 1988, trunkSize: 50)
sc1
    .addState(state: State(category: StateCategory.engine, name: "Engine", trueStateTitle: "started", falseStateTitle: "closed"))
    .addState(state: State(category: StateCategory.windows, name: "Windows", trueStateTitle: "opened", falseStateTitle: "closed"))

sc1.loadTrunk(30)
sc1.changeState(stateCategory: .windows, value: true)
sc1.changeState(stateCategory: .engine, value: true)

var sc2 = SportCar(brand: "VAZ 2104", manufacturedAtYear: 1989, trunkSize: 100)
sc2.addState(state: State(category: StateCategory.engine, name: "Engine", trueStateTitle: "started", falseStateTitle: "closed"))
sc2.loadTrunk(30)
sc2.changeState(stateCategory: .engine, value: true)


print(tc1)
print("--")
print(tc2)
print("--")
print(sc1)
print("--")
print(sc2)
