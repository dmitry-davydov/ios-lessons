import UIKit

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}

struct Car {
    var fuelConsumption: UInt
    var manufacturedAtYear: UInt
}

protocol Validable: Error {
    var errorDescription: String {get set}
    var validator: (_ v: Any) -> Bool {get set}
    
    func isValid(_ a: Any) -> Bool
    func mustValid(_ a: Any) throws -> Void
}

extension Validable {
    
    func isValid(_ a: Any) -> Bool {
        return self.validator(a)
    }
    
    func mustValid(_ a: Any) throws -> Void {
        guard isValid(a) else {
            throw self
        }
    }
}

struct Validator: Validable {
    var errorDescription: String
    var validator: (Any) -> Bool
}

class CarValidator {
    var validators: [Validable] = []
    
    init(validators: [Validable]) {
        self.validators = validators
    }
    
    func validate(_ car: Car) -> (Car?, [Validable]) {
        var errors: [Validable] = []
        for validator in validators {
            if validator.isValid(car) {
                continue
            }
            
            errors.append(validator)
        }
        
        if errors.count > 0 {
            return (nil, errors)
        }
        
        return (car, [])
    }
}

var pragmaticCarValidator = CarValidator(validators: [
    Validator(
        errorDescription: "Fuel Consumption is too hight",
        validator: {(a: Any) -> Bool in
            let c = a as! Car
            return c.fuelConsumption <= 5
        }
    ),
    Validator(
        errorDescription: "Car is old",
        validator: {(a: Any) -> Bool in
            let c = a as! Car
            let components = Calendar.current.dateComponents([.year], from: Date())
            
            return UInt(components.year!) - c.manufacturedAtYear <= 10
        }
    ),
])

class PragmaticCarStorage {
    var storage: [Car] = []
    var validation: CarValidator
    
    init(validation: CarValidator) {
        self.validation = validation
    }
    
    func add(_ c: Car) throws -> Void {
        let (car, errors) = validation.validate(c)
        print(errors)
        guard errors.count == 0 else {
            throw "Car can not be pragmatic. " + errors.map({$0.errorDescription}).joined(separator: "; ")
        }
        
        storage.append(car!)
    }
}

let pragmaticCarStorage = PragmaticCarStorage(validation: pragmaticCarValidator)

pragmaticCarStorage.add(Car(fuelConsumption: 20, manufacturedAtYear: 1980))



