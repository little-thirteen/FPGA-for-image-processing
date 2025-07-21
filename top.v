`timescale 1ns / 1ps

module top(
    input         sys_clock,
    input         rst_0,
    input  [1:0]  Pixel_sel_0,
    output [3:0]  vgaRed_0,
    output [3:0]  vgaGreen_0,
    output [3:0]  vgaBlue_0,
    output        hsync_0,
    output        vsync_0
);

    wire [16:0] bram_address;
    wire [11:0] pixel_data_from_bram;
    wire [11:0] pixel_data_to_vga;

    // 实例化VGA控制器
    controler vga_controller (
        .clk(sys_clock),
        .rst(rst_0),
        .address(bram_address),
        .data(pixel_data_to_vga), // 从像素处理器接收数据
        .vgaRed(vgaRed_0),
        .vgaBlue(vgaBlue_0),
        .vgaGreen(vgaGreen_0),
        .hsync(hsync_0),
        .vsync(vsync_0)
    );

    // 实例化像素处理器
    pixel_operator image_processor (
        .pixel_in(pixel_data_from_bram), // 从BRAM接收数据
        .Pixel_sel(Pixel_sel_0),
        .clock(sys_clock),
        .Out_pixel(pixel_data_to_vga)
    );

    // 实例化Block RAM
    // FIX: 添加了 .ena(1'b1) 连接，以确保RAM始终被使能
    blk_mem_gen_0 image_ram (
        .clka(sys_clock),
        .ena(1'b1),
        .addra(bram_address),
        .douta(pixel_data_from_bram)
    );

endmodule