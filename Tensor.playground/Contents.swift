import Foundation

extension Array {
    /// Split an array of d dimensions
    ///
    ///     let arr = Array(1...10)
    ///     arr.chunked(by: shape[5])
    fileprivate func chunked(by size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    /// Expand dimensions on OUTER layer
    ///
    ///     let arr = [[4,3,5],[1,0,0]]
    ///     print(arr.expandDim())
    func expandDim() -> [[Element]] {
        return [self]
    }
}

protocol TensorBase {
    var dim: Int { get }
}


typealias Arr1D = [Int]
typealias Arr2D = [[Int]]
typealias Arr3D = [[[Int]]]
typealias Arr4D = [[[[Int]]]]
typealias Arr5D = [[[[[Int]]]]]


func reshape_1_to_2(_ arr: Arr1D, shape: (Int,Int)) -> Arr2D {
    return arr.chunked(by: shape.1)
}
func reshape_1_to_3(_ arr: Arr1D, shape: (Int,Int,Int)) -> Arr3D {
    return arr.chunked(by: shape.2)
        .chunked(by: shape.1)
}
func reshape_1_to_4(_ arr: Arr1D, shape: (Int,Int,Int,Int)) -> Arr4D {
    return arr.chunked(by: shape.3)
        .chunked(by: shape.2)
        .chunked(by: shape.1)
}
func reshape_1_to_5(_ arr: Arr1D, shape: (Int,Int,Int,Int,Int)) -> Arr5D {
    return arr.chunked(by: shape.4)
        .chunked(by: shape.3)
        .chunked(by: shape.2)
        .chunked(by: shape.1)
}


/// Create and manipulate tensors
///
/// Non-optimised tensor manipulation trying to be like Python's NumPy. In no way should this be used in production. This is to show that Swift can somehow do it too.
///
/// - important: Only supports 1D and 2D operations
///
/// # Ways to initialise
///
///     a = Tensor.ones((1,4,2))
///     b = Tensor.zeros((3,9))
///     c = Tensor([1,2,3,4], shape_this: (3,9))
///     d = Tensor([2,4]) # 1D array
///     Tensor.arange(7)
///     Tensor.arange(3,6)
///     Tensor.rand((8,1,2))
///
/// # Arithmetics
///
/// Element-wise addition
///
///     a + b
///
/// Element-wise multiplication
///
///     a * b
///
/// Broadcasting
///
///     a + 1
///     b * 8
///
/// Matrix multiplication
///
///     Tensor.matmul(a,b)
///
struct Tensor: CustomStringConvertible {
    
    /// 1D INTEGER arrays for now
    ///
    /// - ToDo:
    ///     - Double type
    var arr1D: Arr1D = [0]
    var arr2D: Arr2D = [[0]]
    var arr3D: Arr3D = [[[0]]]
    var arr4D: Arr4D = [[[[0]]]]
    var arr5D: Arr5D = [[[[[0]]]]]
    
    /// Shape of array
    let shape: [Int]
    
    /// No. of dimensions of array
    let dim: Int
    
    /// Initialise a 1D array
    ///
    ///     let a = Tensor([1,2,3])
    ///     let b = Tensor([-1,8,9])
    init(_ arr: Arr1D) {
        self.arr1D = arr
        self.shape = [arr.count]
        self.dim = shape.count
//        self.arr = test
    }
    
    /// Initialise a 2D, 3D, 4D or 5D array with shape
    init<T>(_ preArr: Arr1D, shape_this: T) {
        self.arr1D = preArr
        self.shape = [0]
        self.dim = Mirror(reflecting: shape_this).children.count
        if self.dim == 2 {
            self.arr2D = reshape_1_to_2(preArr, shape: shape_this as! (Int,Int))
        } else if self.dim == 3 {
            self.arr3D = reshape_1_to_3(preArr, shape: shape_this as! (Int,Int,Int))
        } else if self.dim == 4 {
            self.arr4D = reshape_1_to_4(preArr, shape: shape_this as! (Int,Int,Int,Int))
        } else if self.dim == 5 {
            self.arr5D = reshape_1_to_5(preArr, shape: shape_this as! (Int,Int,Int,Int,Int))
        } else {
            print("Not supported")
        }
    }
    
    /// Initialise a 2D array
    init(_ arr: Arr2D) {
        self.arr2D = arr
        self.shape = [2,2]
        self.dim = 2
    }
    
    /// Initialise a 3D array
    init(_ arr: Arr3D) {
        self.arr3D = arr
        self.shape = [2,2]
        self.dim = 3
    }
    
    /// Initialise a 4D array
    init(_ arr: Arr4D) {
        self.arr4D = arr
        self.shape = [2,2]
        self.dim = 4
    }
    
    /// Initialise a 5D array
    init(_ arr: Arr5D) {
        self.arr5D = arr
        self.shape = [2,2]
        self.dim = 5
    }

    
    func indexIsValid(index: Int) -> Bool {
        return index >= 0 && index < arr1D.count
    }
    
//    subscript(_ index: Int) -> Int {
//        get {
////            assert(indexIsValid(index: index), "Index out of range")
//            return arr1[index]
//        }
//        set {
////            assert(indexIsValid(index: index), "Index out of range")
//            arr1[index] = newValue
//        }
//    }
    
    subscript(_ index1: Int, _ index2: Int) -> Int {
        get {
            assert(self.dim == 2, "wrong")
            return arr2D[index1][index2]
        }
        set {
            assert(self.dim == 2, "wrong")
            arr2D[index1][index2] = newValue
        }
    }
    subscript(_ index1: Int, _ index2: Int, _ index3: Int) -> Int {
        get {
            assert(self.dim == 3, "wrong")
            return arr3D[index1][index2][index3]
        }
        set {
            assert(self.dim == 3, "wrong")
            arr3D[index1][index2][index3] = newValue
        }
    }
    subscript(_ index1: Int, _ index2: Int, _ index3: Int, _ index4: Int) -> Int {
        get {
            assert(self.dim == 4, "wrong")
            return arr4D[index1][index2][index3][index4]
        }
        set {
            assert(self.dim == 4, "wrong")
            arr4D[index1][index2][index3][index4] = newValue
        }
    }
    subscript(_ index1: Int, _ index2: Int, _ index3: Int, _ index4: Int, _ index5: Int) -> Int {
        get {
            assert(self.dim == 5, "wrong")
            return arr5D[index1][index2][index3][index4][index5]
        }
        set {
            assert(self.dim == 5, "wrong")
            arr5D[index1][index2][index3][index4][index5] = newValue
        }
    }
    
    let space = "       "
    /// Print function for 1D array from `CustomStringConvertible` protocol
    var description: String {
        var str: String = "array("
        
        switch (self.dim) {
        case 1:
            str.append(contentsOf: "\(arr1D)")
        case 2:
            str.append("[")
            for i in 0..<arr2D.count {
                if i > 0 {
                    str.append(space)
                }
                str.append(contentsOf: "\(arr2D[i])")
                if i != arr2D.count-1 {
                    str.append(",\n")
                }
            }
            str.append("]")
        default:
            str.append("[")
            for i in 0..<arr3D.count {
                if i == 0 {
                    str.append("[")
                } else if i > 0 {
                    str.append(space + "[")
                }
                for j in 0..<arr3D[i].count {
                    if j > 0 {
                        str.append(space + " ")
                    }
                    str.append(contentsOf: "\(arr3D[i][j])")
                    if j != arr3D[i].count-1 {
                        str.append(",\n")
                    }
                }
                if i != arr3D.count-1 {
                    str.append(",\n\n")
                }
            }
            str.append("]")
            str.append("]")
        }
        
        str.append(contentsOf: ")")
        
        return str
    }
    
    /// Initialise an array of ones with a given shape
    ///
    /// - ToDo:
    ///     - remove placeholder
    /// - Parameters:
    ///     - shape: eh sup
//    static func ones(_ shape: [Int]) -> Tensor {
//        let numElements = shape.reduce(1,*)
//        let arr = Array(repeating: 1, count: numElements)
//        return Tensor(arr, shape: shape)
//    }
    
    /// Initialise an array of zeros with a given shape
    ///
    /// - Parameters:
    ///     - shape: eh sup
//    static func zeros(_ shape: [Int]) -> Tensor {
//        let numElements = shape.reduce(1,*)
//        let arr = Array(repeating: 0, count: numElements)
//        return Tensor(arr, shape: shape)
//    }
    
    /// Initialise an array of zeros with a given shape
    ///
    /// - Parameters:
    ///     - shape: eh sup
    static func zeros<T>(_ shape: T) -> Tensor {
        let numElements = Mirror(reflecting: shape).children.map {$1 as! Int}.reduce(1,*)
        let arr = Array(repeating: 0, count: numElements)
        return Tensor(arr, shape_this: shape)
    }
    
    static func ones<T>(_ shape: T) -> Tensor {
        let numElements = Mirror(reflecting: shape).children.map {$1 as! Int}.reduce(1,*)
        let arr = Array(repeating: 1, count: numElements)
        return Tensor(arr, shape_this: shape)
    }
    
    static func arange(_ end: Int) -> Tensor {
        return Tensor(Array(0...end))
    }
    
    static func arange(_ start: Int, _ end: Int) -> Tensor {
        return Tensor(Array(start...end))
    }
    
    static func rand<T>(_ shape: T) -> Tensor {
        let numElements = Mirror(reflecting: shape).children.map {$1 as! Int}.reduce(1,*)
        let arr = Array(repeating: 9, count: numElements)
        return Tensor(arr, shape_this: shape)
    }
    
    static func matmul(_ lhs: Tensor, _ rhs: Tensor) -> Tensor {
        return lhs * rhs
    }
}


/// Overloading element-wise addition
func + (lhs: Tensor, rhs: Tensor) -> Tensor {
    switch (lhs.dim) {
    case 1:
        return Tensor(
            zip(lhs.arr1D, rhs.arr1D).map(+))
    case 2:
        return Tensor(
            zip(lhs.arr2D, rhs.arr2D).map {
                zip($0, $1).map(+)})
    default:
        return Tensor(
            zip(lhs.arr3D, rhs.arr3D).map {
                zip($0, $1).map {
                    zip($0, $1).map(+)}})
    }
}

/// Overloading element-wise subtraction
func - (lhs: Tensor, rhs: Tensor) -> Tensor {
    return lhs + rhs * -1
}

/// Overloading add operation for 1D broadcasting
func + (lhs: Tensor, rhs: Int) -> Tensor {
    switch (lhs.dim) {
    case 1:
        return Tensor(lhs.arr1D.map {$0 + rhs})
    case 2:
        return Tensor(lhs.arr2D.map {$0.map {$0 + rhs}})
    default:
        return Tensor(lhs.arr3D.map {$0.map {$0.map {$0 + rhs}}})
    }
}

/// Overloading multiply operation
func * (lhs: Tensor, rhs: Tensor) -> Tensor {
    switch (lhs.dim) {
    case 1:
        return Tensor(
            zip(lhs.arr1D, rhs.arr1D).map (*))
    case 2:
        return Tensor(
            zip(lhs.arr2D, rhs.arr2D).map {zip($0, $1).map(*)})
    default:
        return Tensor(
            zip(lhs.arr3D, rhs.arr3D).map {zip($0, $1).map {zip($0, $1).map(*)}})
    }
}

/// Overloading multiply operation with broadcasting
func * (lhs: Tensor, rhs: Int) -> Tensor {
    switch (lhs.dim) {
    case 1:
        return Tensor(lhs.arr1D.map {$0 * rhs})
    case 2:
        return Tensor(lhs.arr2D.map {$0.map {$0 * rhs}})
    case 3:
        return Tensor(lhs.arr3D.map {$0.map {$0.map {$0 * rhs}}})
    case 4:
        return Tensor(lhs.arr4D.map {$0.map {$0.map {$0.map {$0 * rhs}}}})
    default:
        return Tensor(lhs.arr5D.map {$0.map {$0.map {$0.map {$0.map {$0 * rhs}}}}})
    }
}

let f = Tensor.zeros((2,3))
let g = Tensor([1,2,3,4,5,6,7,8,9,10,11,12], shape_this: (2,3,2))
let h = Tensor.zeros((2,7,8))
let i = Tensor.ones((2,5,3))
//print(f[0,2])
print(h)
//print(Tensor.matmul(h, i) + 1)
print(Tensor.arange(5))

let a = Tensor([1,2,3])
let b = Tensor([-1,8,9])

