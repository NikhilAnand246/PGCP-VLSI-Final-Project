`timescale 1ns/1ps

module tb_top_uart_128;

reg clk;//input as register
reg rst;
reg load_data;
reg [127:0] key;
reg [127:0] data_in;

wire [127:0] data_out;//wire as output
wire tx_complete;
wire rx_complete;
wire [127:0] ciphertext_enc;
wire [127:0] ciphertext_dec;



top_uart_128 DUT//instantiate top module
(
    .clk(clk),
    .rst(rst),
    .load_data(load_data),
    .data_in(data_in),
     .key(key),
    .data_out(data_out),
    .tx_complete(tx_complete),
    .rx_complete(rx_complete),
    .ciphertext_enc(ciphertext_enc),
    .ciphertext_dec(ciphertext_dec)
);


initial begin
    clk = 1'b0;
    key = 128'h11111111111111111111111111111111;
  end
  

always #10 clk = ~clk;


initial
begin

    rst       = 1'b0;
    load_data = 1'b0;
    data_in   = 128'd0;

    #100;

    rst = 1'b1;

    repeat(5) @(posedge clk);


    data_in = 128'h0123456789ABCDEF1122334455667788;//input signal of 128bit

    @(posedge clk);
    load_data = 1'b1;

    @(posedge clk);
    load_data = 1'b0;

end


initial
begin

 
    $display("Secure 128-bit UART COmmunication ");


    wait(tx_complete);//waitingg untill tx_complete become 1
	$timeformat(-9, 3, " ns", 10);
    $display("[%0t] TX Completed",$time);
    $display("ORIGINAL SEND DATA : %032h",data_in );
    $display("ENCRYPTED SEND DATA : %032h",ciphertext_enc );
    
    
    
    wait(rx_complete);
    
    
  $display("----------------------------------------------------");
	$timeformat(-9, 3, " ns", 10);
    $display("[%0t] RX Completed",$time);

    $display("ENCRYPTED RECEIVED DATA : %032h",ciphertext_dec );
    
        if(ciphertext_enc == ciphertext_dec)
        $display("********** ENCRYPTED DATA TRANSFER: SUCCESS **********");
    else
        $display("********** ENCRYPTED DATA TRANSFER: FAIL **********");
    
    
    #2;
       //$display("TX 128 DATA : %032h",data_in);
    $display("ORIGINAL RECEIVED 128 DATA : %032h",data_out);
    

    
    if(data_out == data_in)
        $display("********** DATA TRANSFER: SUCCESS **********");
    else
        $display("********** DATA TRANSFER: FAIL **********");

    #200;

    $finish;

end

endmodule