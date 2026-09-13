module xor_encryption(input [127:0]key,input [127:0]data_og_in, output [127:0] ciphertext);
assign ciphertext = key ^ data_og_in;
endmodule


module xor_decryption(input [127:0] key, input [127:0] ciphertext, output [127:0] data_og_out);
assign data_og_out = key ^ ciphertext;
endmodule