module lab8(clk, clkout);
	input clk;
	//clk与PIN_23绑定，频率是50MHz
	output reg clkout;
	reg [18:0] q;
	always @(posedge clk)
	begin
		if(q == 12500)
		//q为12500是2kHz，q为250000是100Hz
		begin
			clkout <= ~clkout;
			q <= 0;
		end
		else
			q <= q + 1;
	end
endmodule
