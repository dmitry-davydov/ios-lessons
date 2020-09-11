import UIKit

enum PayloadPriority {
    case Low, Normal, High
}

protocol Workable {
    func work()
}

struct PayloadQueue: Workable {
    var id: UUID
    var priority: PayloadPriority
    
    init(priority: PayloadPriority) {
        id = UUID.init()
        self.priority = priority
    }
    
    func work() {
        print("Working: Payload: \(id); Priority \(priority)")
    }
}

extension PayloadQueue: CustomStringConvertible {
    var description: String {
        return id.uuidString
    }
}

struct Worker<T: Workable> {
    func work(_ payload: T) {
        payload.work()
    }
}

struct Queue<T: Workable> {
    private var queue: [T] = []
    
    mutating func push(_ payload: T) {
        queue.append(payload)
    }
    
    mutating func pop() -> T {
        return queue.removeLast()
    }
    
    mutating func popMany(by: (T) -> Bool) -> [T] {
        var resultPayloadList: [T] = []
        
        for payloadItem in queue {
            if !by(payloadItem) {
                continue
            }
            resultPayloadList.append(payloadItem)
        }
        
        queue.removeAll(where: {by($0)})
        
        return resultPayloadList
    }
    
    var count: Int {
        return queue.count
    }
    
    subscript(index: Int) -> Optional<T> {
        if !queue.indices.contains(index) {
            return nil
        }
        
        return queue[index]
    }
}

var worker = Worker<PayloadQueue>()
var queue = Queue<PayloadQueue>()

for i in 1...20 {
    
    if i % 2 == 0 {
        queue.push(PayloadQueue(priority: .High))
        continue
    }
    
    if i % 3 == 0 {
        queue.push(PayloadQueue(priority: .Normal))
        continue
    }
    
    queue.push(PayloadQueue(priority: .Low))
}

print("Total: \(queue.count)")

for payload in queue.popMany(by: {$0.priority == .High}) {
    worker.work(payload)
}

for payload in queue.popMany(by: {$0.priority == .Low}) {
    worker.work(payload)
}

print("Last elements")

while(queue.count > 0) {
    worker.work(queue.pop())
}

print("Items left: \(queue.count)")

print("subscript")
queue.push(PayloadQueue(priority: .High))

print(queue[2] as Any)
print(queue[0] as Any)
