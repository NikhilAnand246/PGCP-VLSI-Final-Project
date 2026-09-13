module uart_rx1(input clk,rst, output reg[7:0]data_rx,input rx ,output reg rx_done);

reg[1:0]state;
localparam idle=0,recieving=1,stop=3;
reg[9:0]shift_reg;
reg [15:0]baud_tik;
parameter baud_count=50000000/9600;
reg[3:0]bit_count;


always@(posedge clk or negedge rst) 
begin
if (!rst)
begin
bit_count<=0;
shift_reg<=0;
state<=idle;
baud_tik<=0;
rx_done<=0;
end

else 

begin
case(state)
idle: begin
baud_tik<=0;
shift_reg<=0;
bit_count<=0;
rx_done<=0;
if(rx==0)
state<=recieving;
else
state<=idle;
end



recieving: begin
    if (baud_tik < baud_count - 1) begin
        baud_tik <= baud_tik + 1;
        
        // Sample and shift IMMEDIATELY in the middle of the bit!
        if (baud_tik == baud_count / 2) begin
            shift_reg <= {rx, shift_reg[9:1]};
            bit_count <= bit_count + 1;
        end
    end else begin
        baud_tik <= 0; // Reset baud tick at end of bit
        
        if (bit_count == 10) begin
            state <= stop;
        end
    end
end


stop:	begin
	data_rx<=shift_reg[8:1];
	bit_count<=0;
	rx_done<=1'b1;
	state<=idle;
	end 

default:state<=idle;
endcase
end
end
endmodule