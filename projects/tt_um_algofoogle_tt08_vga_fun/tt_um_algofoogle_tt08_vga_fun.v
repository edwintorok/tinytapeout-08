/*
 * Copyright (c) 2024 Anton Maurovic
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_algofoogle_tt08_vga_fun (
    input  wire       VGND,
    input  wire       VDPWR,    // 1.8v power supply
    input  wire       VAPWR,    // 3.3v power supply
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    inout  wire [7:0] ua,       // Analog pins, only ua[5:0] can be used
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // WARNING: Netget doesn't seem to like a pattern of:
    //      wire [7:0] r, rn;
    // as it incorrectly interprets only `r` as a bus, and `rn` as a single wire.
    wire [7:0] r;
    wire [7:0] g;
    wire [7:0] b;
    wire [7:0] rn;
    wire [7:0] gn;
    wire [7:0] bn;

    controller controller_0 (
        .VPWR       (VDPWR),
        .VGND       (VGND),
        .clk        (clk),
        .rst_n      (rst_n),
        .ui_in      (ui_in),
        .vblank     (uio_out[0]),
        .hblank     (uio_out[1]),
        .r          (r),
        .g          (g),
        .b          (b),
        .rn         (rn),
        .gn         (gn),
        .bn         (bn),
        .r7         (uo_out[0]),
        .g7         (uo_out[1]),
        .b7         (uo_out[2]),
        .vsync      (uo_out[3]),
        .r6         (uo_out[4]),
        .g6         (uo_out[5]),
        .b6         (uo_out[6]),
        .hsync      (uo_out[7])
    );

    csdac_nom R_dac (
        .vcc        (VDPWR),
        .vss        (VGND),
        .p0         (r[0]),
        .n0         (rn[0]),
        .p1         (r[1]),
        .n1         (rn[1]),
        .p2         (r[2]),
        .n2         (rn[2]),
        .p3         (r[3]),
        .n3         (rn[3]),
        .p4         (r[4]),
        .n4         (rn[4]),
        .p5         (r[5]),
        .n5         (rn[5]),
        .p6         (r[6]),
        .n6         (rn[6]),
        .p7         (r[7]),
        .n7         (rn[7]),
        .Vbias      (ua[0]),
        .Vneg       (ua[1])
        // .Vpos       (ua[2])
    );

    csdac_nom G_dac (
        .vcc        (VDPWR),
        .vss        (VGND),
        .p0         (g[0]),
        .n0         (gn[0]),
        .p1         (g[1]),
        .n1         (gn[1]),
        .p2         (g[2]),
        .n2         (gn[2]),
        .p3         (g[3]),
        .n3         (gn[3]),
        .p4         (g[4]),
        .n4         (gn[4]),
        .p5         (g[5]),
        .n5         (gn[5]),
        .p6         (g[6]),
        .n6         (gn[6]),
        .p7         (g[7]),
        .n7         (gn[7]),
        .Vneg       (ua[2])
        // .Vbias      (ua[1]),
        // .Vpos       (ua[2])
    );

    csdac_nom B_dac (
        .vcc        (VDPWR),
        .vss        (VGND),
        .p0         (b[0]),
        .n0         (bn[0]),
        .p1         (b[1]),
        .n1         (bn[1]),
        .p2         (b[2]),
        .n2         (bn[2]),
        .p3         (b[3]),
        .n3         (bn[3]),
        .p4         (b[4]),
        .n4         (bn[4]),
        .p5         (b[5]),
        .n5         (bn[5]),
        .p6         (b[6]),
        .n6         (bn[6]),
        .p7         (b[7]),
        .n7         (bn[7]),
        .Vneg       (ua[3])
        // .Vbias      (ua[1]),
        // .Vpos       (ua[2])
    );

    // Configure uio directions...
    //NOTE: Using power ports instead of constants,
    // because the design is not synthesized,
    // but rather laid out by hand:
    assign uio_oe[0] = VDPWR;   // Output: vblank
    assign uio_oe[1] = VDPWR;   // Output: hblank
    assign uio_oe[2] = VGND;    // Input: UNUSED
    assign uio_oe[3] = VGND;    // Input: UNUSED
    assign uio_oe[4] = VGND;    // Input: UNUSED
    assign uio_oe[5] = VGND;    // Input: UNUSED
    assign uio_oe[6] = VGND;    // Input: UNUSED
    assign uio_oe[7] = VGND;    // Input: UNUSED

    // Tie unused digital outputs, so they don't float:
    // assign uio_out[0] = hblank;
    // assign uio_out[1] = vblank;
    assign uio_out[2] = VGND;
    assign uio_out[3] = VGND;
    assign uio_out[4] = VGND;
    assign uio_out[5] = VGND;
    assign uio_out[6] = VGND;
    assign uio_out[7] = VGND;

endmodule
