import UIKit
//
// 1. Написать функцию, которая определяет, четное число или нет.
func isEven(_ number: Int) -> Bool {
    return number % 2 == 0
}

// 2. Написать функцию, которая определяет, делится ли число без остатка на 3.
func isDevisibleBy3(_ number: Int) -> Bool {
    return number % 3 == 0
}

// 3. Создать возрастающий массив из 100 чисел.
var arr = [Int](stride(from: 1, to: 101, by: 1))

// 4. Удалить из этого массива все четные числа и все числа, которые не делятся на 3.
arr = arr.filter({(num) -> Bool in
    return !isEven(num) && !isDevisibleBy3(num)
})

// 5. * Написать функцию, которая добавляет в массив новое число Фибоначчи, и добавить при помощи нее 100 элементов.
func fib(_ num: Int) -> Decimal {
    var a: Decimal = 1
    var b: Decimal = 1
    guard num > 1 else { return a }
    
    (2...num).forEach { _ in
        (a, b) = (a + b, a)
    }
    return a
}

var fibbArr: [Decimal] = []

for num in 1...100 {
    let f = fib(num)
    fibbArr.append(f)
}

/*
 6. * Заполнить массив из 100 элементов различными простыми числами. Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Для нахождения всех простых чисел не больше заданного числа n, следуя методу Эратосфена, нужно выполнить следующие шаги:
*/
func naturalNumbers(_ max: Int) -> [Int] {
    // a. Выписать подряд все целые числа от двух до n (2, 3, 4, ..., n).
    var data: [Int] = Array(2...max)
    // b. Пусть переменная p изначально равна двум — первому простому числу.
    var testValue = 2
    
    while testValue <= max {
        data.removeAll(where: {(number) -> Bool in
            // удаляем все элементы, если число больше чем testValue и кратно testValue
            return number >= testValue * testValue && number % testValue == 0
        })
        
        let val = data.first(where: {(number) -> Bool in
            return number > testValue
        })
        
        guard val != nil else {return data}
        
        testValue = val!
    }
    
    
    return data
}
