module rx_128_controller(input clk,input rst,input rx_done,input [7:0]rx_data,
output reg [127:0] data_out,
output reg rx_complete
);

reg [3:0] byte_count;

always @(posedge clk or negedge rst)
begin

    if(!rst)
    begin
        data_out     <= 128'd0;
        byte_count   <= 4'd0;
        rx_complete  <= 1'b0;
    end

    else
    begin
  //take as initial
	rx_complete <= 1'b0;

// Store directly received byte whenever UART finishes receiving one byte
  if(rx_done)
   begin
   case(byte_count)

                4'd0  : data_out[127:120] <= rx_data;
                4'd1  : data_out[119:112] <= rx_data;
                4'd2  : data_out[111:104] <= rx_data;
                4'd3  : data_out[103:96]  <= rx_data;
                4'd4  : data_out[95:88]   <= rx_data;
                4'd5  : data_out[87:80]   <= rx_data;
                4'd6  : data_out[79:72]   <= rx_data;
                4'd7  : data_out[71:64]   <= rx_data;
                4'd8  : data_out[63:56]   <= rx_data;
                4'd9  : data_out[55:48]   <= rx_data;
                4'd10 : data_out[47:40]   <= rx_data;
                4'd11 : data_out[39:32]   <= rx_data;
                4'd12 : data_out[31:24]   <= rx_data;
                4'd13 : data_out[23:16]   <= rx_data;
                4'd14 : data_out[15:8]    <= rx_data;
                4'd15 : data_out[7:0]     <= rx_data;

                default : data_out <= data_out;

      endcase

            // to check all 16 bytes are received
   if(byte_count == 4'd15)
    begin
       rx_complete <= 1'b1;
     byte_count  <= 4'd0;
    end
   else
    begin
         byte_count <= byte_count + 1'b1;
    end 
   end
  end
 end
endmodule