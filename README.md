# NumSwift

**Work in progress**

Create and manipulate tensors

Non-optimised tensor manipulation trying to be like Python's NumPy. In no way should this be used in production. Just can't believe Swift hasn't got its own yet.

**Important**: Only supports 1D and 2D operations.

## Ways to initialise

    Tensor.ones((1,4,2))
    Tensor.zeros((3,9))
    Tensor([1,2,3,4], shape_this: (3,9))
    Tensor([2,4]) # 1D array
    Tensor.arange(7)
    Tensor.arange(3,6)
    Tensor.rand((8,1,2))

## Arithmetics

Element-wise addition

    a + b

Element-wise multiplication

    a * b

Broadcasting

    a + 1
    b * 8

Matrix multiplication

    Tensor.matmul(a,b)
