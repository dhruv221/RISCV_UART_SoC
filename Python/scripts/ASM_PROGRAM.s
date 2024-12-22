.section .text
.org 0x00000000               # Base address of the .text section

_start:
    # Initialize Matrix A
    li x1, 34       # A[1][1]
    sw x1, 0(x0)
    li x1, 64        # A[1][2]
    sw x1, 1(x0)
    li x1, 64        # A[1][3]
    sw x1, 2(x0)
    li x1, 37        # A[1][3]
    sw x1, 3(x0)

    li x1, 78        # A[2][1]
    sw x1, 4(x0)
    li x1, 152        # A[2][2]
    sw x1, 5(x0)
    li x1, 152        # A[2][3]
    sw x1, 6(x0)
    li x1, 97        # A[1][3]
    sw x1, 7(x0)

    li x1, 32        # A[3][1]
    sw x1, 8(x0)
    li x1, 60        # A[3][2]
    sw x1, 9(x0)
    li x1, 60        # A[3][3]
    sw x1, 10(x0)
    li x1, 31        # A[1][3]
    sw x1, 11(x0)

    li x1, 67        # A[3][1]
    sw x1, 12(x0)
    li x1, 130        # A[3][2]
    sw x1, 13(x0)
    li x1, 130        # A[3][3]
    sw x1, 14(x0)
    li x1, 82        # A[1][3]
    sw x1, 15(x0)
    
end:
    j end