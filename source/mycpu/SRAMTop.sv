`include "common.svh"
`include "sramx.svh"

module SRAMTop(
    input logic clk, resetn,

    output logic        inst_sram_en,
    output logic [3 :0] inst_sram_wen,
    output logic [31:0] inst_sram_addr,
    output logic [31:0] inst_sram_wdata,
    input  logic [31:0] inst_sram_rdata,
    output logic        data_sram_en,
    output logic [3 :0] data_sram_wen,
    output logic [31:0] data_sram_addr,
    output logic [31:0] data_sram_wdata,
    input  logic [31:0] data_sram_rdata,

    input i6 ext_int
);
    ibus_req_t   ireq;
    ibus_resp_t  iresp;
    dbus_req_t   dreq;
    dbus_resp_t  dresp;
    sramx_req_t  isreq,  dsreq;
    sramx_resp_t isresp, dsresp;

    MyCore core(.*);
    IBusToSRAMx icvt(.*);
    DBusToSRAMx dcvt(.*);

    word_t inst_sram_addr_v, inst_sram_addr_p;
    word_t data_sram_addr_v, data_sram_addr_p;
    assign inst_sram_addr_v = isreq.addr;
    assign data_sram_addr_v = dsreq.addr;
    AddrTrans addrtrans_1(.paddr(inst_sram_addr_p), .vaddr(inst_sram_addr_v));
    AddrTrans addrtrans_2(.paddr(data_sram_addr_p), .vaddr(data_sram_addr_v));

    assign inst_sram_en    = isreq.en;
    assign inst_sram_wen   = isreq.wen;
    assign inst_sram_addr  = inst_sram_addr_p;
    assign inst_sram_wdata = isreq.wdata;
    assign isresp.rdata    = inst_sram_rdata;

    assign data_sram_en    = dsreq.en;
    assign data_sram_wen   = dsreq.wen;
    assign data_sram_addr  = data_sram_addr_p;
    assign data_sram_wdata = dsreq.wdata;
    assign dsresp.rdata    = data_sram_rdata;

    // logic _unused_ok = &{ext_int};
endmodule
