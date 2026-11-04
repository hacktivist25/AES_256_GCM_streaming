# AES

import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.clock import Clock


def multH_128(H: int, Ci: int) -> int:
    """takes H (AES(0)) and Ci (128bits integers) and performs a multiplication in GF(2)"""
    if not isinstance(H, int) or not isinstance(Ci, int):
        raise TypeError("Operands must be integers")

    if not (0 <= H < 2**128):
        raise ValueError("H must be unsigned 128-bit integer")

    if not (0 <= Ci < 2**128):
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


def GHASH(H: int, C_prev: int, Y_prev: int) -> int:
    """calculate an intermediate authentification tag, using :
    - the previous tag Y_prev (128 bits integer)
    - the current "ciphertext"(ciphered counter CTR XOR plaintext) (128 bits integer)
    - H (AES(0))
    """
    if (
        not isinstance(H, int)
        or not isinstance(C_prev, int)
        or not isinstance(Y_prev, int)
    ):
        raise TypeError("Operands must be integers")

    if not (0 <= H < 2**128):
        raise ValueError("H must be unsigned 128-bit integer")

    if not (0 <= C_prev < 2**128):
        raise ValueError("C_prev must be unsigned 128-bit integer")

    if not (0 <= Y_prev < 2**128):
        raise ValueError("Y_prev must be unsigned 128-bit integer")

    Y_current = multH_128(H, C_prev ^ Y_prev)

    return Y_current


async def GHASH_block_transmission(
    dut, Y_0: int, CI: list[int], valid_cycles: list[bool], H_i: list[int]
):
    """
    This functions takes a list of ciphertexts CI, a sequence of valid cycles :
    - each valid cycle ('1') allows 2 ciphertext blocks from CI to be digested to produce an authentification tag
    - the module will give in output an almost final tag when it has digested all ciphertext blocks

    Y_0 is the first authentification tag of a sequence (128 bits integer)
    C_I is the list of ciphertexts (issued from AES) to digest for authentification tag production (128 bits)
    valid_cycles are the cycles on which AES produced an AES valid output
    H_i is the powers of H (8 powers) (128 bits)
    """
    if not isinstance(Y_0, int):
        raise TypeError("Y_0 must be integer")
    for i in range(len(CI)):
        if not isinstance(CI[i], int):
            raise ValueError(f"CI[{i}] must be integer")
    for i in range(len(H_i)):
        if not isinstance(H_i[i], int):
            raise ValueError(f"H_i[{i}] must be integer")

    if not (0 <= Y_0 < 2**128):
        raise ValueError("Y_0 must be unsigned 128-bit integer")
    for i in range(len(CI)):
        if not (0 <= CI[i] < 2**128):
            raise ValueError(f"CI[{i}] must be unsigned 128-bit integer")
    for i in range(len(valid_cycles)):
        if not (0 <= valid_cycles[i] < 2):
            raise ValueError(f"valid_cycles[{i}] must be 0 or 1")
    for i in range(len(H_i)):
        if not (0 <= H_i[i] < 2**128):
            raise ValueError(f"H_i[{i}] must be unsigned 128-bit integer")

    Y_i = [Y_0]  # list of intermediate authentification tags
    Y_current = 0
    Y_prev = Y_0
    C_index = 0  # index of ciphertext-block used to produce authentification tags

    nb_blocks = len(CI)  # lenght of message (in 128-bits blocks)
    nb_rows = (
        nb_blocks // 8
    )  # generally, during streaming burst, blocks are digested in packs of 8
    nb_whole_blocks = 8 * nb_rows
    blocks_remaining = nb_blocks % 8
    nb_blocks_digested = 0

    # features useful only when the number of blocks isn't a multiple of 8
    watch_last_Y = 0  # indicates when second-to-last intermediate tag is supposed to be emitted (0 = False, 1 = True)
    last_Y_catched = 0  # indicates second-to-last intermediate is emitted/valid (0 = False, 1 = True)
    last_Y_exists = (
        0  # indicates second-to-last intermediate is registered (0 = False, 1 = True)
    )
    final = 0  # indicates the final block begins to be digested by GHASH engine  (0 = False, 1 = True)
    final_round_launched = 0  # indicates the final block begins to be digested by GHASH engine (0 = False, 1 = True)

    n_final_Y_expected = (
        (nb_blocks - 1) // 8
    ) + 1  # number of times an intermediate tag has to be emitted given the message (including final tag)
    n_final_Y = (
        0  # number of valid intermediate tags detected in output (including final tag)
    )

    swapper = 0  # used for control signal : enables lane A and B input swapping whn number of blocs is odd
    if blocks_remaining % 2 == 1:
        swapper = 1

    # in initial state
    dut.valid_A.value = 0
    dut.valid_B.value = 0
    dut.final_block.value = 0
    dut.counter.value = 3
    dut.prev_AD.value = Y_i[0]
    dut.CI_A.value = 0
    dut.CI_B.value = 0
    dut.swap.value = 0

    for k in range(len(valid_cycles)):
        await FallingEdge(dut.clk)

        if (
            last_Y_catched == 1
        ):  # if previous cycle was emmmiting second-to-last intermediate tag
            last_Y_exists = 1  # second-to-last intermediate tag is now registered (ready to be used for last tag calculation)
            last_Y_catched = 0

        # verification if valid output emitted
        if int(dut.valid_AD.value) == 1:
            n = 8  # standard size
            if final_round_launched:
                n = blocks_remaining
            for j in range(
                n
            ):  # GHASH module uses 8 last blocks to caluclate next intermediate authentification tag
                Y_current = GHASH(H_i[0], CI[C_index], Y_prev)
                C_index += 1
                Y_prev = Y_current

                if (watch_last_Y == 1) & (last_Y_exists == 0):
                    watch_last_Y = 0
                    last_Y_catched = 1

            assert int(dut.new_AD.value) == Y_current, (
                f"wrong hash value "
                f"at cycle {k}\n"
                f"expected : {hex(Y_current)} | actual : {hex(int(dut.new_AD.value))}"
            )
            n_final_Y += 1
            Y_i.append(int(dut.new_AD.value))

        if (k >= 1) & (
            valid_cycles[k - 1] == 1
        ):  # if at previous clock edge, input was valid
            if nb_blocks_digested < nb_whole_blocks:
                nb_blocks_digested += 2
                dut.counter.value = 3 - ((nb_blocks_digested % 8) // 2)
            elif (
                nb_blocks_digested < nb_blocks
            ):  # case usefull only when nb_blocks isn't a multiple of 8
                if (nb_blocks_digested == nb_whole_blocks) & (swapper == 1):
                    nb_blocks_digested += 1
                else:
                    nb_blocks_digested += 2

                select = nb_blocks - nb_blocks_digested
                match select:
                    case 0:
                        dut.counter.value = (blocks_remaining - 1) // 2
                    case 1 | 2:
                        if (blocks_remaining == 1) | (blocks_remaining == 2):
                            dut.counter.value = 3
                        else:
                            dut.counter.value = 0
                    case 3 | 4:
                        if (blocks_remaining == 3) | (blocks_remaining == 4):
                            dut.counter.value = 3
                        else:
                            dut.counter.value = 1
                    case 5 | 6:
                        if (blocks_remaining == 5) | (blocks_remaining == 6):
                            dut.counter.value = 3
                        else:
                            dut.counter.value = 2
                    case 7:
                        if blocks_remaining == 7:
                            dut.counter.value = 3
                        else:
                            dut.counter.value = 3
                    case _:
                        raise ValueError("strange impossible case")
            else:
                dut.counter.value = 3

        if nb_blocks_digested % 8 == 0:
            dut.prev_AD.value = Y_i[-1]  # lest intermediate tag registered

        if (nb_blocks_digested >= nb_whole_blocks) & (
            nb_blocks_digested < nb_blocks
        ):  # case usefull only when nb_blocks isn't a multiple of 8
            if last_Y_catched == 0:
                watch_last_Y = 1
            if (watch_last_Y == 1) & (
                nb_whole_blocks == 0
            ):  # exception : if there is no "full row", last_Y is Y_0 and already exist
                last_Y_exists = 1
                watch_last_Y = 0
            if swapper == 1:
                dut.swap.value = 1

        if valid_cycles[k] == 1:
            dut.valid_A.value = 1
            dut.valid_B.value = 1
            if nb_blocks_digested < nb_whole_blocks:
                dut.CI_A.value = CI[nb_blocks_digested]
                dut.CI_B.value = CI[nb_blocks_digested + 1]
            elif (
                nb_blocks_digested < nb_blocks
            ):  # case usefull only when nb_blocks isn't a multiple of 8
                if swapper == 1:
                    if nb_blocks_digested == nb_whole_blocks:
                        dut.CI_A.value = 0
                        dut.CI_B.value = CI[nb_blocks_digested]
                    else:
                        dut.CI_A.value = CI[nb_blocks_digested]
                        dut.CI_B.value = CI[nb_blocks_digested + 1]
                else:
                    dut.CI_A.value = CI[nb_blocks_digested]
                    dut.CI_B.value = CI[nb_blocks_digested + 1]
            else:  # non existent case
                dut.CI_A.value = 0
                dut.CI_B.value = 0

        else:
            dut.valid_A.value = 0
            dut.valid_B.value = 0
            dut.CI_A.value = 0
            dut.CI_B.value = 0

            if final == 1:  # case usefull only when nb_blocks isn't a multiple of 8
                final = 0
                dut.final_block.value = 0

            elif (
                (last_Y_exists == 1)
                & (nb_blocks_digested == nb_blocks)
                & (final_round_launched == 0)
            ):  # case usefull only when nb_blocks isn't a multiple of 8
                final = 1
                dut.final_block.value = 1
                dut.prev_AD.value = Y_i[-1]
                final_round_launched = 1

    assert n_final_Y == n_final_Y_expected, (
        f"Not finished verification\n"
        f"n_final_Y = {n_final_Y} | n_final_Y_expected = {n_final_Y_expected}\n"
    )
    return Y_current
