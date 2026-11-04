import cocotb
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.clock import Clock

from model import AES_models as model


@cocotb.test()
async def H_init_test(dut):
    """Runs to calculate H**2, H**3,... up to H**8
    Should trigger "valid" each 4 clock cycles, when the output is valid"""

    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())  # 100 MHz

    dut.rst.value = 0
    await Timer(15, units="ns")
    dut.rst.value = 1

    H = 25930200495
    current_power = H
    power = 1

    await FallingEdge(dut.clk)
    dut.start.value = 1
    dut.H.value = H

    await FallingEdge(dut.clk)
    dut.start.value = 0
    dut.H.value = 0

    for i in range(28):
        await RisingEdge(dut.clk)
        if i % 4 == 3:
            assert int(dut.valid.value) == 1, (
                f"ctrl_valid shoud be triggered " f"at cycle {i}"
            )
            power += 1
            current_power = model.multH_128(H, current_power)
            print(
                "expected : ", {current_power}, " | calculated : ", int(dut.H_out.value)
            )
            assert int(dut.H_out.value) == current_power, (
                f"calculated powers of H does not match " f"at power {power}\n"
            )

        else:
            assert int(dut.valid.value) == 0, (
                f"ctrl_valid shoud be down " f"at cycle {i}"
            )
    for name in dut:
        dut._log.info("child: %s", name._name)
