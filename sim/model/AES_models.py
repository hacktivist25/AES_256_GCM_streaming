# AES 

def multH_128 (H: int, Ci: int) -> int :
    #takes H and Ci (128bits integers) and performs a multiplication in GF(2)
    if not isinstance(H, int) or not isinstance(Ci, int):
        raise TypeError("Operands must be integers")

    if not (0 <= H < 2 ** 128):
        raise ValueError("H must be unsigned 128-bit integer")

    if not (0 <= Ci < 2 ** 128):
        raise ValueError("Ci must be unsigned 128-bit integer")

    MASK = (1 << 128) - 1
    R = 0x87

    z = 0
    v = Ci

    for i in range(128):
        if (H >> i) & 1:
            z ^= v

        if (v >> 127) & 1:
            v = ((v << 1) & MASK) ^ R
        else:
            v = (v << 1) & MASK

    return z
    
    
def GHASH (H: int, C_prev: int, Y_prev: int) -> int :
    #calculate something
    
    if not isinstance(H, int) or not isinstance(C_prev, int) or not isinstance(Y_prev, int):
        raise TypeError("Operands must be integers")

    if not (0 <= H < 2 ** 128):
        raise ValueError("H must be unsigned 128-bit integer")

    if not (0 <= C_prev < 2 ** 128):
        raise ValueError("C_prev must be unsigned 128-bit integer")
    
    if not (0 <= Y_prev < 2 ** 128):
        raise ValueError("Y_prev must be unsigned 128-bit integer")

    Y_current = multH_128(H, C_prev^Y_prev)
    
    return Y_current