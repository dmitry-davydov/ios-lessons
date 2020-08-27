import UIKit

// Решить квадратное уравнение.
func ex1(_ a:Double, _ b:Double, _ c:Double) -> (Double, Double?)? {
    // вычисление дискриминанта
    // D = b^2 − 4ac.
    
    let discr = pow(b, 2) - (4 * a * c)
    if discr < 0 {
        // нет корней
        return nil
    }
    
    // вычисление корней
    let x1 = ((b * -1) + sqrt(discr)) / 2 * a;
    if discr == 0 {
        // если дискриминант == 0, то всего один корень
        return (x1, nil)
    }
    
    // иначе 2 корня
    
    let x2 = ((b * -1) - sqrt(discr)) / 2 * a;
    
    return (x1, x2)
}


// Даны катеты прямоугольного треугольника. Найти площадь, периметр и гипотенузу треугольника.
func ex2(_ a: Double, _ b:Double) -> (Double, Double, Double) {
    
    // площадь
    let s: Double = a * b / 2
    
    // гипотенуза
    let g: Double = sqrt(pow(a, 2) + pow(b, 2))
    
    // периметр
    let p: Double = a + b + g
    
    return (s, g, p)
}

//* Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет.
func ex3(_ moneyAmount: Double, _ percent: Double) -> Double {
    var result: Double = moneyAmount
    for _ in 1...5 {
        result += result*(percent / 100)
    }
    
    return result
}
