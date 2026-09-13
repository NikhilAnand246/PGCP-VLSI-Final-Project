`timescale 1ns/1ps
module top_uart_128(
    input clk, rst, load_data,
    input [127:0] data_in,
    input [127:0] key,
    output [127:0] data_out,
    output tx_complete,
    output rx_complete,
    output [127:0] ciphertext_enc,
    output [127:0] ciphertext_dec
);

wire tx_rx_wire;
wire tx_start;
wire tx_done;
wire [7:0]tx_data;
wire rx_done;
wire [7:0] rx_data;


xor_encryption enc(.key(key),.data_og_in(data_in),.ciphertext(ciphertext_enc));

tx_128_controller TX_CTRL(
.clk(clk),
.rst(rst),
.load_data(load_data),
.data_in(ciphertext_enc),
.tx_done(tx_done),
.tx_start(tx_start),
.tx_data(tx_data),
.tx_complete(tx_complete));

uart_tx trans(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .data_tx(tx_data),
    .tx(tx_rx_wire),
	.tx_done(tx_done)
);

uart_rx1 rec(
    .clk(clk),
    .rst(rst),
    .data_rx(rx_data),
    .rx(tx_rx_wire),
    .rx_done(rx_done)
);

rx_128_controller RX_CTRL(
.clk(clk),
.rst(rst),
.rx_done(rx_done),
.rx_data(rx_data),
.data_out(ciphertext_dec),
 .rx_complete(rx_complete)
);
xor_decryption dec(.key(key), .ciphertext(ciphertext_dec), .data_og_out(data_out));


endmodule