import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.clock import Clock

from model import AES_models as model

import random

"""
entity GHASH_2x4way is
	port(
		CI_A : IN std_logic_vector(127 DOWNTO 0);
		CI_B : IN std_logic_vector(127 DOWNTO 0);
		H : IN std_logic_vector(127 DOWNTO 0);
		prev_AD : IN std_logic_vector(127 DOWNTO 0);
		clk : IN std_logic;
		rst : IN std_logic;
		start : IN std_logic;
		load_A : IN std_logic;
		load_B : IN std_logic;
		valid_A : IN std_logic;
		valid_B : IN std_logic;
		swap : IN std_logic;
        final_block : IN std_logic;
		counter : IN std_logic_vector(1 DOWNTO 0);
		new_AD : OUT std_logic_vector(127 DOWNTO 0)
	);
end GHASH_2x4way;
"""

def random_pattern(max_lenght : int = 50, n_valid : int = 8) :
    valid_cycle = [0]*max_lenght
    positions = sorted(
        random.sample(range(max_lenght), n_valid)
    )
    for pos in positions:
        valid_cycle[pos] = 1
    
    last_index = positions[-1]
    if last_index > max_lenght-5 :
        for i in range (5 - (max_lenght - last_index)):
            valid_cycle.append(0)
    else :
        for i in range ((max_lenght - last_index)-5):
            valid_cycle.pop()
    return valid_cycle

@cocotb.test()
async def GHASH_quick_test(dut):
    """testing 2 packs of 8 ciphers inputs on the GHASH module : 
    - initialisation of the GHASH module (28 clock cycles)
    - 2 ciphers enters each clock cycles
    """
    
    CI = [
    0x00112233445566778899AABBCCDDEEFF, 0x0022446688AACCEE1133557799BBDDFF, 
    0xFFEEDDCCBBAA99887766554433221100, 0xFFDDBB9977553311EECCAA8866442200, 
    0x0000AAAA7777EEEE5555222200001111, 0xBBBB9999111100000000000066663333,
    0x777788889999444455550000AAAAFFFF, 0xEEEEFFFFFFFF1111AAAA999911118888,
    0x0123456789ABCDEF0123456789ABCDEF, 0x02468ACE13579BDF02468ACE13579BDF, 
    0xFEDCBA9876543210FEDCBA9876543210, 0xFDB97531ECA86420FDB97531ECA86420,
    0x63929B9DEF98FA0B93D9C0139FF87402, 0x28F89CDE8910BC457289DB08C89A2304,
    0x79F46230974389023798567380432326, 0x236879FBCADBFCA43287364BCDDEFBBB
    ]
    
    Y_0 = 0xA0B1C2F30415263748596A7B8C9DAEBF
    
    H = 25930200495
    current_power = H
    H_powers = [H]
    counter = 0
    
    cocotb.start_soon(
    Clock(dut.clk, 10, units="ns").start() # 100 MHz
    )
    
    dut.rst.value = 0
    await Timer(15, units="ns")
    dut.rst.value = 1

    # launch initialisation of H_init, to prepare H powers (up to 8)
    await FallingEdge(dut.clk)
    dut.start.value = 1
    dut.load_A.value = 1 
    dut.load_B.value = 1
    dut.valid_A.value = 0
    dut.valid_B.value = 0
    dut.final_block.value = 0
    dut.H.value = H
    dut.counter.value = 0
    dut.prev_AD.value = 0
    dut.CI_A.value = 0
    dut.CI_B.value = 0
    dut.swap.value = 0
    
    await FallingEdge(dut.clk)
    dut.start.value = 0
    dut.load_B.value = 0
    dut.H.value = 0
    for i in range(28):
        await FallingEdge(dut.clk)
        if i%4 == 2 :
            assert int(dut.valid_s.value) == 1, (
            f"ctrl_valid shoud be triggered "
            f"at cycle {i}"
            )
            current_power = model.multH_128(H, current_power)
            print("expected : ", {current_power}," | calculated : ",int(dut.H_out_s.value))
            assert int(dut.H_out_s.value) == current_power, (
            f"calculated powers of H does not match "
            )
            
            H_powers.append(current_power)
            
            if (i//4)%2 == 0 : 
                dut.load_A.value = 1
            else :
                counter += 1
                dut.counter.value = counter
                dut.load_B.value = 1
            
        else : 
            assert int(dut.valid_s.value) == 0, (
            f"ctrl_valid shoud be down "
            f"at cycle {i}"
            )
            
            dut.load_A.value = 0
            dut.load_B.value = 0
            
    # H_init finished initialisation of GHASH module
    dut.load_A.value = 0
    dut.load_B.value = 0
    await FallingEdge(dut.clk)
    
    Y_current = 0
    Y_prev = Y_0
    Y_i = [Y_0]
    
    for i in range (13):
        await FallingEdge(dut.clk)        
        # verification
        if i == 7 :
            for j in range(8):
                Y_current = model.GHASH(H, CI[j], Y_prev)
                Y_prev = Y_current
            assert int(dut.new_AD.value) == Y_current, (
            f"wrong hash value "
            f"at cycle {i}\n"
            f"expected : {hex(Y_current)} | actual : {hex(int(dut.new_AD.value))}"
            )
            
            assert int(dut.valid_AD.value) == 1, (
            f"valid_AD should be triggered "
            f"at cycle {i}\n"
            )
            
            Y_i.append(int(dut.new_AD.value))
        elif i == 11 :
            for j in range(8, 16):
                Y_current = model.GHASH(H, CI[j], Y_prev)
                Y_prev = Y_current
            assert int(dut.new_AD.value) == Y_current, (
            f"wrong hash value "
            f"at cycle {i}"
            )
            
            assert int(dut.valid_AD.value) == 1, (
            f"valid_AD should be triggered "
            f"at cycle {i}\n"
            )
        
        dut.counter.value = 3-(i%4)
        
        if (i > 7) :
            dut.CI_A.value = 0
            dut.CI_B.value = 0
            dut.valid_A.value = 0
            dut.valid_B.value = 0
        else :
            dut.CI_A.value = CI[2*i]
            dut.CI_B.value = CI[2*i + 1]
            dut.valid_A.value = 1
            dut.valid_B.value = 1
            
        if i == 4 :
            dut.prev_AD.value = Y_i[0]
        elif i == 8 : 
            dut.prev_AD.value = Y_i[1]
            
        
    for name in dut:
        dut._log.info("child: %s", name._name)



@cocotb.test()
async def GHASH_test_irregular_throughput(dut):
    """testing 2 packs of 8 ciphers inputs on the GHASH module : 
    - initialisation of the GHASH module (28 clock cycles)
    - 2 ciphers enters at some clock cycles, other times, it's a zero (signifying that AES engine didn't ciphered two blocks at some point)
    """
    
    
    
    CI = [
    0x00112233445566778899AABBCCDDEEFF, 0x0022446688AACCEE1133557799BBDDFF, 
    0xFFEEDDCCBBAA99887766554433221100, 0xFFDDBB9977553311EECCAA8866442200, 
    0x0000AAAA7777EEEE5555222200001111, 0xBBBB9999111100000000000066663333,
    0x777788889999444455550000AAAAFFFF, 0xEEEEFFFFFFFF1111AAAA999911118888,
    0x0123456789ABCDEF0123456789ABCDEF, 0x02468ACE13579BDF02468ACE13579BDF, 
    0xFEDCBA9876543210FEDCBA9876543210, 0xFDB97531ECA86420FDB97531ECA86420,
    0x63929B9DEF98FA0B93D9C0139FF87402, 0x28F89CDE8910BC457289DB08C89A2304,
    0x79F46230974389023798567380432326, 0x236879FBCADBFCA43287364BCDDEFBBB
    ]
    
    Y_0 = 0xA0B1C2F30415263748596A7B8C9DAEBF
    
    H = 25930200495
    current_power = H
    H_powers = [H]
    counter = 0
    
    cocotb.start_soon(
    Clock(dut.clk, 10, units="ns").start() # 100 MHz
    )
    
    dut.rst.value = 0
    await Timer(15, units="ns")
    dut.rst.value = 1

    # launch initialisation of H_init, to prepare H powers (up to 8)
    await FallingEdge(dut.clk)
    dut.start.value = 1
    dut.load_A.value = 1
    dut.load_B.value = 1
    dut.valid_A.value = 0
    dut.valid_B.value = 0
    dut.final_block.value = 0
    dut.H.value = H
    dut.counter.value = 0
    dut.prev_AD.value = 0
    dut.CI_A.value = 0
    dut.CI_B.value = 0
    dut.swap.value = 0
    
    await FallingEdge(dut.clk)
    dut.start.value = 0
    dut.load_B.value = 0
    dut.H.value = 0
    for i in range(28):
        await FallingEdge(dut.clk)
        if i%4 == 2 :
            assert int(dut.valid_s.value) == 1, (
            f"ctrl_valid shoud be triggered "
            f"at cycle {i}"
            )
            current_power = model.multH_128(H, current_power)
            print("expected : ", {current_power}," | calculated : ",int(dut.H_out_s.value))
            assert int(dut.H_out_s.value) == current_power, (
            f"calculated powers of H does not match "
            )
            
            H_powers.append(current_power)
            
            if (i//4)%2 == 0 : 
                dut.load_A.value = 1
            else :
                counter += 1
                dut.counter.value = counter
                dut.load_B.value = 1
            
        else : 
            assert int(dut.valid_s.value) == 0, (
            f"ctrl_valid shoud be down "
            f"at cycle {i}"
            )
            
            dut.load_A.value = 0
            dut.load_B.value = 0
            
    # H_init finished initialisation of GHASH module
    dut.load_A.value = 0
    dut.load_B.value = 0
    await FallingEdge(dut.clk)
    
    for regression_number in range(1, 30):
        dut._log.info(f"regression number : {regression_number}/30")
        
        valid_cycle = random_pattern(50, 8)
        Y_current = 0
        Y_prev = Y_0
        Y_i = [Y_0]
        C_index = 0
        
        i=0
        
        for k in range (len(valid_cycle)):
            await FallingEdge(dut.clk)
            
            if (k>=1) & (valid_cycle[k-1]) :
                i+=1
            
            # verification
            if int(dut.valid_AD.value) == 1 :
                for j in range(8):
                    Y_current = model.GHASH(H, CI[C_index], Y_prev)
                    C_index += 1
                    Y_prev = Y_current  

                assert int(dut.new_AD.value) == Y_current, (
                f"wrong hash value "
                f"at cycle {i}\n"
                f"expected : {hex(Y_current)} | actual : {hex(int(dut.new_AD.value))}\n"
                f"at regression number {regression_number}"
                )
                
                Y_i.append(int(dut.new_AD.value))

            dut.counter.value = 3-(i%4)

            if (i > 7) :
                dut.CI_A.value = 0
                dut.CI_B.value = 0
                dut.valid_A.value = 0
                dut.valid_B.value = 0
            else :
                if valid_cycle[k] :
                    dut.CI_A.value = CI[2*i]
                    dut.CI_B.value = CI[2*i + 1]
                    dut.valid_A.value = 1
                    dut.valid_B.value = 1
                else :
                    dut.CI_A.value = 0
                    dut.CI_B.value = 0
                    dut.valid_A.value = 0
                    dut.valid_B.value = 0
                
                
            if i == 4 :
                dut.prev_AD.value = Y_i[0]
            elif i == 8 : 
                dut.prev_AD.value = Y_i[1]
                
            
    for name in dut:
        dut._log.info("child: %s", name._name)



@cocotb.test()
async def GHASH_test_irregular_throughput_uncomplete_tail_even_2(dut):
    """testing 2 packs of 8 ciphers inputs on the GHASH module + a pack of 2 -> reset + same test, with a final pack of 4 -> same with pack of 6
    - initialisation of the GHASH module (28 clock cycles)
    - 2 ciphers enters at some clock cycles, other times it's a zero (signifying that AES engine didn't ciphered two blocks at some point)
    """
    
    """valid_cycle = [
    [1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,1,1,0,0,1,1,0,0,0,0],
    [1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,1,1,0,0,1,1,0,0,1,0,1,0,0,0,0,0,0],
    [1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,1,1,0,0,1,1,0,0,1,0,1,1,0,0,1,0,0,0,0]
    ]"""
    
    CI = [
    0x00112233445566778899AABBCCDDEEFF, 0x0022446688AACCEE1133557799BBDDFF, 
    0xFFEEDDCCBBAA99887766554433221100, 0xFFDDBB9977553311EECCAA8866442200, 
    0x0000AAAA7777EEEE5555222200001111, 0xBBBB9999111100000000000066663333,
    0x777788889999444455550000AAAAFFFF, 0xEEEEFFFFFFFF1111AAAA999911118888,
    0x0123456789ABCDEF0123456789ABCDEF, 0x02468ACE13579BDF02468ACE13579BDF, 
    0xFEDCBA9876543210FEDCBA9876543210, 0xFDB97531ECA86420FDB97531ECA86420,
    0x63929B9DEF98FA0B93D9C0139FF87402, 0x28F89CDE8910BC457289DB08C89A2304,
    0x79F46230974389023798567380432326, 0x236879FBCADBFCA43287364BCDDEFBBB,
    
    0x7384BD7AA0782738BFF737877AC9023A, 0x6C27A5468793269782456938D32BAA25,
    0x278A632A86B40987309CD63228EF5639, 0x7AA4389323440239328410114B2CC803,
    0xD83A6378926439B0643029684F32BB04, 0x98A3246809C3463890640983EB239FFF
    ]
    
    Y_0 = 0xA0B1C2F30415263748596A7B8C9DAEBF
    
    H = 25930200495
    current_power = H
    H_powers = [H]
    counter = 0
    
    cocotb.start_soon(
    Clock(dut.clk, 10, units="ns").start() # 100 MHz
    )
    
    dut.rst.value = 0
    await Timer(15, units="ns")
    dut.rst.value = 1

    # launch initialisation of H_init, to prepare H powers (up to 8)
    await FallingEdge(dut.clk)
    dut.start.value = 1
    dut.load_A.value = 1
    dut.load_B.value = 1
    dut.valid_A.value = 0
    dut.valid_B.value = 0
    dut.final_block.value = 0
    dut.H.value = H
    dut.counter.value = 0
    dut.prev_AD.value = 0
    dut.CI_A.value = 0
    dut.CI_B.value = 0
    dut.swap.value = 0
    
    await FallingEdge(dut.clk)
    dut.start.value = 0
    dut.load_B.value = 0
    dut.H.value = 0
    for i in range(28):
        await FallingEdge(dut.clk)
        if i%4 == 2 :
            assert int(dut.valid_s.value) == 1, (
            f"ctrl_valid shoud be triggered "
            f"at cycle {i}"
            )
            current_power = model.multH_128(H, current_power)
            print("expected : ", {current_power}," | calculated : ",int(dut.H_out_s.value))
            assert int(dut.H_out_s.value) == current_power, (
            f"calculated powers of H does not match "
            )
            
            H_powers.append(current_power)
            
            if (i//4)%2 == 0 : 
                dut.load_A.value = 1
            else :
                counter += 1
                dut.counter.value = counter
                dut.load_B.value = 1
            
        else : 
            assert int(dut.valid_s.value) == 0, (
            f"ctrl_valid shoud be down "
            f"at cycle {i}"
            )
            
            dut.load_A.value = 0
            dut.load_B.value = 0
            
    # H_init finished initialisation of GHASH module
    dut.load_A.value = 0
    dut.load_B.value = 0
    await FallingEdge(dut.clk)
    
    Y_current = 0
    Y_prev = Y_0
    Y_i = [Y_0]
    C_index = 0
    n_blocks = 0
    final = 0
    
    valid_cycle =  [1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,1,1,0,0,1,0,0,1,0,0,0,0,1,0,0,0,0,0]
    
    i=0
    for k in range (len(valid_cycle)):
        await FallingEdge(dut.clk)
        
        if (k >= 1) & (valid_cycle[k-1] == 1) :
            i+=1
        
        # verification
        if int(dut.valid_AD.value) == 1 :
            n = 8
            if final : 
                n = 2
            for j in range(n):
                Y_current = model.GHASH(H, CI[C_index], Y_prev)
                C_index += 1
                Y_prev = Y_current  

            assert int(dut.new_AD.value) == Y_current, (
            f"wrong hash value "
            f"at cycle {i}\n"
            f"expected : {hex(Y_current)} | actual : {hex(int(dut.new_AD.value))}"
            )
            
            Y_i.append(int(dut.new_AD.value))

        if (i > 7) :
            dut.final_block.value = 0
            if i == 8 : 
                dut.counter.value = 3
            elif i == 9: 
                dut.counter.value = 0
                if valid_cycle[k] :
                    dut.final_block.value = 1
                    final = 1
            else : 
                dut.counter.value = 0
                
            if valid_cycle[k] :
                if i < 9 :
                    dut.CI_A.value = CI[2*i]
                    dut.CI_B.value = CI[2*i + 1]
                else : 
                    dut.CI_A.value = 0
                    dut.CI_B.value = 0
                dut.valid_A.value = 1
                dut.valid_B.value = 1    
            else :
                dut.CI_A.value = 0
                dut.CI_B.value = 0
                dut.valid_A.value = 0
                dut.valid_B.value = 0
        else :
            dut.counter.value = 3-(i%4)
            if valid_cycle[k] :
                dut.CI_A.value = CI[2*i]
                dut.CI_B.value = CI[2*i + 1]
                dut.valid_A.value = 1
                dut.valid_B.value = 1
            else :
                dut.CI_A.value = 0
                dut.CI_B.value = 0
                dut.valid_A.value = 0
                dut.valid_B.value = 0
            
            
        if i == 4 :
            dut.prev_AD.value = Y_i[0]
        elif i == 8 : 
            dut.prev_AD.value = Y_i[1]
        elif final : 
            dut.prev_AD.value = Y_i[2]
            
        
    for name in dut:
        dut._log.info("child: %s", name._name)