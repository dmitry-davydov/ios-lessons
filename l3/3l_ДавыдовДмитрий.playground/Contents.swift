import UIKit

/*
1. Описать несколько структур – любой легковой автомобиль SportCar и любой грузовик TrunkCar.
2. Описать в каждом наследнике специфичные для него свойства.Структуры должны содержать марку авто, год выпуска, объем багажника/кузова, запущен ли двигатель, открыты ли окна, заполненный объем багажника.
3. Описать перечисление с возможными действиями с автомобилем: запустить/заглушить двигатель, открыть/закрыть окна, погрузить/выгрузить из кузова/багажника груз определенного объема.
4. Добавить в структуры метод с одним аргументом типа перечисления, который будет менять свойства структуры в зависимости от действия.
5. Инициализировать несколько экземпляров структур. Применить к ним различные действия.
6. Вывести значения свойств экземпляров в консоль.
*/
enum CarType: String {
    case SportCar, TrunkCar
}

enum EngineState: String {
    case started, stopped
}

enum WindowsState: String {
    case opened, closed
}

enum PayloadActions {
    case load, unload
}


struct Car {
    let type: CarType
    let brand: String
    let manufacturedAtYear: UInt
    let payloadSize: UInt
    var usedPayloadSize: UInt = 0
    
    var isEngineStarted: EngineState = EngineState.stopped
    var isWindowsOpened: WindowsState = WindowsState.closed
    
    mutating func changeEngineState(newState: EngineState) {
        self.isEngineStarted = newState
    }
    
    mutating func changeWindowsState(newState: WindowsState) {
        self.isWindowsOpened = newState
    }
    
    mutating func changePayloadState(action: PayloadActions, size: UInt) {
        switch action {
        case .load:
            if self.usedPayloadSize + size > self.payloadSize {
                print("Error: Can not load more than total size")
                return
            }
            
            self.usedPayloadSize += size
        case .unload:
            let calculatedSize: Int = Int(self.usedPayloadSize) - Int(size)
            if calculatedSize < 0 {
                print("Error: can not unload \(size)")
                return
            }
            
            self.usedPayloadSize -= size
        }
        
    }
    
    func dumpState() {
        print("""
        Car Type: \(self.type)
        Brand: \(self.brand)
        Manufactured At: \(self.manufacturedAtYear)
        PayloadSizeUsed \(self.usedPayloadSize) of \(self.payloadSize)
        Windows is \(self.isWindowsOpened)
        Engine \(self.isEngineStarted)
        """)
    }
}

var car = Car(type: .SportCar, brand: "Honda", manufacturedAtYear: 1990, payloadSize: 1000)
car.dumpState()

car.changeEngineState(newState: .started)
car.changeWindowsState(newState: .opened)
car.changePayloadState(action: .load, size: 10)

car.dumpState()

car.changePayloadState(action: .unload, size: 20)
car.dumpState()

car .changeWindowsState(newState: .closed)
car.dumpState()
