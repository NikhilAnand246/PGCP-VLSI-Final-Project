module uart_tx(input clk,rst,tx_start,input [7:0]data_tx, output reg tx, output reg tx_done);
  reg [2:0] state;
  localparam idle=0, LOAD=1, transmit=2, stop=3;
  reg [9:0] shift_reg;
  reg [15:0] baud_tik;
  parameter baud_count = 50000000/9600;
  reg [3:0] bit_count;
  
  always@(posedge clk or negedge rst)begin
    if(!rst) begin
      tx<=1;
      bit_count<=0;
      shift_reg<=0;
      state<=idle;
      baud_tik<=0;
      tx_done<=0;
    end
  else begin
    case(state)
      idle: begin
        tx<=1;
        baud_tik<=0;
        shift_reg<=0;
        bit_count<=0;
        tx_done<=0;
        if(tx_start)
          state<=LOAD;
        else
          state<=idle;
        end
      LOAD: begin
          shift_reg<={1'b1,data_tx,1'b0};
          state<=transmit;
        end
        
      transmit: begin
        if((baud_tik==baud_count-1)&&(bit_count<=9)) begin
          tx <= shift_reg[0];
          shift_reg<=shift_reg>>1;
          bit_count<=bit_count+1;
          baud_tik<=0;
          if(bit_count==9) begin
            bit_count<=0;
            state<=stop;
          end
        end else
        baud_tik<=baud_tik+1;
      end
      
    stop: begin
        tx<=1;
        state<=idle;
        tx_done<=1'b1;
      end
      
      default: state<=idle;
    endcase
  end
end
endmodule
        