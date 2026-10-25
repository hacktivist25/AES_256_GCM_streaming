import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.clock import Clock

from model import AES_models as model

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
		counter : IN std_logic_vector(1 DOWNTO 0);
		new_AD : OUT std_logic_vector(127 DOWNTO 0)
	);
end GHASH_2x4way;
"""

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
        dut._log.info("FALLING EDGE")
        
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
    
    valid_cycle = [1,0,0,1,0,1,0,1,0,1,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0]
    
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
    
    i=0
    for k in range (len(valid_cycle)):
        await FallingEdge(dut.clk)
        dut._log.info("FALLING EDGE")
        
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
            f"expected : {hex(Y_current)} | actual : {hex(int(dut.new_AD.value))}"
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
