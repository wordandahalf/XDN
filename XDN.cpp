#include <stdlib.h>
#include "VXDN.h"

#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char *argv[])
{
    fprintf(stderr, "Starting XDN simulation!\n");
    uint64_t tickcount = 0;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    VXDN *vxdn = new VXDN;

    vxdn->trace(tfp, 99);
    tfp->open("trace.vcd");
    for(; tickcount < 16384 ; )
    {
        tickcount++;

        vxdn->i_SYS_CLOCK = 0;
        vxdn->i_BTN_0 = 0;
        vxdn->i_BTN_1 = 0;
        vxdn->i_BTN_2 = 0;
        vxdn->i_BTN_3 = 0;
        vxdn->i_BTN_4 = 0;
        vxdn->eval();

        tfp->dump(10 * tickcount - 2);

        vxdn->i_SYS_CLOCK = 1;
        vxdn->eval();
        tfp->dump(10 * tickcount);
        
        vxdn->i_SYS_CLOCK = 0;
        vxdn->eval();
        tfp->dump(10 * tickcount + 5);
        tfp->flush();

    }
    tfp->close();

    return EXIT_SUCCESS;
}