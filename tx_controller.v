module tx_128_controller(input clk,input rst,input load_data,input [127:0] data_in,input tx_done,
output reg tx_start,output reg [7:0] tx_data,
    output reg tx_complete);

reg [127:0] data_reg;//128-bit register
reg [3:0] byte_count;//to count byte
reg busy;

always @(posedge clk or negedge rst)
begin
 if(!rst)
   begin
    data_reg    <= 128'd0;
     byte_count  <= 4'd0;
     tx_data     <= 8'd0;
     tx_start    <= 1'b0;
     tx_complete <= 1'b0;
     busy        <= 1'b0;
  end
 else
    begin
        tx_start    <= 1'b0;
        tx_complete <= 1'b0; 
        if(load_data && !busy)  // Load 128-bit data
         begin
            data_reg   <= data_in;//load data
            busy       <= 1'b1;
            byte_count <= 4'd0;
            tx_data  <= data_in[127:120];
            tx_start <= 1'b1;
         end
        else if(busy && tx_done)  // Send next byte when UART finishes
             begin
                if(byte_count == 4'd15)
            		begin
                	busy        <= 1'b0;
                	tx_complete <= 1'b1;
            		end
                else
            	 begin
                byte_count <= byte_count + 1;
                case(byte_count + 1)
                    4'd1  : tx_data <= data_reg[119:112];
                    4'd2  : tx_data <= data_reg[111:104];
                    4'd3  : tx_data <= data_reg[103:96];
                    4'd4  : tx_data <= data_reg[95:88];
                    4'd5  : tx_data <= data_reg[87:80];
                    4'd6  : tx_data <= data_reg[79:72];
                    4'd7  : tx_data <= data_reg[71:64];
                    4'd8  : tx_data <= data_reg[63:56];
                    4'd9  : tx_data <= data_reg[55:48];
                    4'd10 : tx_data <= data_reg[47:40];
                    4'd11 : tx_data <= data_reg[39:32];
                    4'd12 : tx_data <= data_reg[31:24];
                    4'd13 : tx_data <= data_reg[23:16];
                    4'd14 : tx_data <= data_reg[15:8];
                    4'd15 : tx_data <= data_reg[7:0];
                    default : tx_data <= 8'h00;
                endcase
                tx_start <= 1'b1;
            end
        end
    end
end
endmodule