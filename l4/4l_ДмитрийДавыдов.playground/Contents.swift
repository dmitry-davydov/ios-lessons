import UIKit

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


@propertyWrapper
struct PrintableState {
    let name: String
    let trueStateTitle: String
    let falseStateTitle: String
    
    var wrappedValue: Bool = false
    var projectedValue: String {
        return "\(name) is \(wrappedValue ? trueStateTitle : falseStateTitle)"
    }
    
    init(name: String, trueStateTitle: String, falseStateTitle: String) {
        self.name = name
        self.trueStateTitle = trueStateTitle
        self.falseStateTitle = falseStateTitle
        self.wrappedValue = false
    }
    
    mutating func toggle() {
        wrappedValue = !wrappedValue
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

class Car {
    let brand: String
    let manufacturedAtYear: UInt
    
    @PrintableState(name: "Engine", trueStateTitle: "started", falseStateTitle: "stopped") var engineState: Bool
    @PrintableState(name: "Windows", trueStateTitle: "opened", falseStateTitle: "closed") var windowsState: Bool

    init(brand: String, manufacturedAtYear: UInt) {
        self.brand = brand
        self.manufacturedAtYear = manufacturedAtYear
    }
    
    func description() -> String {
        return """
        Brand: \(self.brand)
        Manufactured At: \(self.manufacturedAtYear)
        \(self.$engineState)
        \(self.$windowsState)
        """
    }
    
    func loadTrunk(size: UInt) {
        print("Err: Trunk is not found")
    }
    func unloadTrunk(size: UInt) {
        print("Err :Trunk is not found")
    }
    
    func handleAction(_ a: Any) {
        
        switch a {
        case Actions.Cargo.Load:
            loadTrunk(size: 10)
        case Actions.Cargo.Unload:
            unloadTrunk(size: 10)
        case Actions.Engine.Start:
            engineState = true
        case Actions.Engine.Stop:
            engineState = false
        case Actions.Windows.Open:
            windowsState = true
        case Actions.Windows.Close:
            windowsState = false
        default:
            print("Unknown a:Any \(a)")
        }
        
    }
}

class SportCar: Car {
    var trunk: Trunk
    
    init(brand: String, manufacturedAtYear: UInt, trunkSize: UInt) {
        self.trunk = Trunk(size: trunkSize)
        super.init(brand: brand, manufacturedAtYear: manufacturedAtYear)
        
    }
    
    override func description() -> String {
        return """
        \(super.description())
        Trunk: \(trunk.state())
        """
    }
    
    override func loadTrunk(size: UInt) {
        if !trunk.canLoad(size: size) {
            return
        }
        
        trunk.load(size)
    }
    
    override func unloadTrunk(size: UInt) {
        if !trunk.canUnload(size: size) {
            return
        }
        
        trunk.unload(size)
    }
}

class TrunkCar: Car {
    var maxTrunksCount: UInt8
    var trunkTrain: [Trunk] = []
    
    init(brand: String, manufacturedAtYear: UInt, maxTrunksCount: UInt8) {
        self.maxTrunksCount = maxTrunksCount
        super.init(brand: brand, manufacturedAtYear: manufacturedAtYear)
    }
    
    func attachTrunk(size: UInt) {
        if maxTrunksCount <= trunkTrain.count {
            return
        }
        trunkTrain.append(Trunk(size: size))
    }
    
    func detachTrunk() {
        if trunkTrain.count == 0 {
            return
        }
        trunkTrain.remove(at: trunkTrain.count - 1)
    }
    
    override func description() -> String {
        var descriptionParts: [String] = [
            super.description()
        ]
        
        if trunkTrain.count == 0 {
            descriptionParts.append("Trunk is not attached")
        } else {
            descriptionParts.append("Attached \(trunkTrain.count) trunks")
        }
        
        for t in trunkTrain {
            descriptionParts.append(t.state())
        }
        
        return descriptionParts.joined(separator: "\n")
    }
    
    
    override func loadTrunk(size: UInt) {
        for i in trunkTrain.indices {
            if !trunkTrain[i].canLoad(size: size) {
                continue
            }
            
            trunkTrain[i].load(size)
            break
        }
    }
    
    override func unloadTrunk(size: UInt) {
        for i in trunkTrain.indices.reversed() {
            print(i)
            if !trunkTrain[i].canUnload(size: size) {
                continue
            }
            
            trunkTrain[i].unload(size)
            break
        }
    }
}


let tc1 = TrunkCar(brand: "Volvo", manufacturedAtYear: 2020, maxTrunksCount: 3)

tc1.attachTrunk(size: 10)
tc1.attachTrunk(size: 100)
tc1.attachTrunk(size: 1_000)

tc1.loadTrunk(size: 11)
tc1.loadTrunk(size: 11)
tc1.loadTrunk(size: 79)

tc1.engineState.toggle()

let tc2 = TrunkCar(brand: "MB", manufacturedAtYear: 1990, maxTrunksCount: 1)
tc2.attachTrunk(size: 20_000)
tc2.loadTrunk(size: 10_000)
tc2.handleAction(Actions.Engine.Start)

let sc1 = SportCar(brand: "VAZ 2108", manufacturedAtYear: 1988, trunkSize: 50)
sc1.loadTrunk(size: 30)
sc1.handleAction(Actions.Windows.Open)
sc1.handleAction(Actions.Engine.Start)

let sc2 = SportCar(brand: "VAZ 2104", manufacturedAtYear: 1989, trunkSize: 100)
sc2.loadTrunk(size: 30)
sc2.handleAction(Actions.Engine.Start)


print(tc1.description())
print("--")
print(tc2.description())
print("--")
print(sc1.description())
print("--")
print(sc2.description())
