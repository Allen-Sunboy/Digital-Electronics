//分频器
module div(input clk, output reg clk_out);
	//clk与PIN_23绑定，频率是50MHz
	reg [18:0] q;
	always @(posedge clk)
	begin
		if(q == 12500)
		//q为12500时，则clkout频率是2kHz
		begin
			clk_out <= ~clk_out;
			q <= 0;
		end
		else
			q <= q + 1;
	end
endmodule

//按键处理，按下按键是从高电平到低电平
module level_to_pulse(input clk, input L, output reg P);
	reg [1:0] state;
	
	always @(posedge clk)
	begin
		if(state == 0)
		begin
			if(L == 1)
				P <= 1;
			else
			begin
				P <= 0;
				state <= 1;
			end
		end
		
		else if(state == 1)
		begin
			if(L == 1)
			begin
				P <= 1;
				state <= 0;
			end
			else
			begin
				P <= 1;
				state <= 2;
			end
		end
		
		else
		begin
			if(L == 1)
			begin
				P <= 1;
				state <= 0;
			end
			else
				P <= 1;
		end
	
	end

endmodule


//编码器，9的优先级最高，低电平输入为有效，无输入情况下输出10
module coder(input clk, input [9:0] I, output reg [3:0] Y);

	always @(posedge clk)
	begin
		if(I[9] == 0)
			Y = 9;
		else if(I[8] == 0)
			Y = 8;
		else if(I[7] == 0)
			Y = 7;
		else if(I[6] == 0)
			Y = 6;
		else if(I[5] == 0)
			Y = 5;
		else if(I[4] == 0)
			Y = 4;
		else if(I[3] == 0)
			Y = 3;
		else if(I[2] == 0)
			Y = 2;
		else if(I[1] == 0)
			Y = 1;
		else if(I[0] == 0)
			Y = 0;
		else
			Y = 10;
	end

endmodule

//状态机，unlock直接连接LED灯
module fsm(input [3:0] X, input clk, output reg [3:0] LED, output reg unlock);

	reg [1:0] state;
	
	always @(posedge clk)
	begin
		if(state == 0)
		begin
			unlock <= 0;
			if(X == 0)
				state <= 1;
		end
		
		else if(state == 1)
		begin
			if(X == 0)
				unlock <= 0;
			else if(X == 4)
			begin
				state <= 2;
				unlock <= 0;
			end
			else if(X != 10)
			begin
				state <= 0;
				unlock <= 0;
			end
		end
		
		else if(state == 2)
		begin
			unlock <= 0;
			if(X == 0)
				state <= 1;
			else if(X == 2)
				state <= 3;
			else if(X != 10)
				state <= 0;
		end
		
		else //state == 3
		begin
			if(X == 0)
			begin
				state <= 1;
				unlock <= 1;
			end
			else if(X != 10)
			begin
				state <= 0;
				unlock <= 0;
			end
		end
		
	end
	
	//状态用LED灯表示
	always @(*)
	begin
		if(state == 0)
			LED = 4'b0001;
		else if(state == 1)
			LED = 4'b0010;
		else if(state == 2)
			LED = 4'b0100;
		else //state == 3
			LED = 4'b1000;
	
	end
	
endmodule


module lab9(input clk, input k0, k1, k2, k3, k4, k5, k6, k7, k8, k9, output [3:0] LED, output unlock);

	wire clk_out;
	wire [9:0] K_out;
	wire [3:0] X;
	wire k0_out, k1_out, k2_out, k3_out, k4_out, k5_out, k6_out, k7_out, k8_out, k9_out;
	
	div Div(clk, clk_out);
	
	level_to_pulse l0(clk_out, k0, k0_out);
	level_to_pulse l1(clk_out, k1, k1_out);
	level_to_pulse l2(clk_out, k2, k2_out);
	level_to_pulse l3(clk_out, k3, k3_out);
	level_to_pulse l4(clk_out, k4, k4_out);
	level_to_pulse l5(clk_out, k5, k5_out);
	level_to_pulse l6(clk_out, k6, k6_out);
	level_to_pulse l7(clk_out, k7, k7_out);
	level_to_pulse l8(clk_out, k8, k8_out);
	level_to_pulse l9(clk_out, k9, k9_out);
	
	assign K_out = {k9_out, k8_out, k7_out, k6_out, k5_out, k4_out, k3_out, k2_out, k1_out, k0_out};
	
	coder Coder(clk_out, K_out, X);
	
	fsm Fsm(X, clk_out, LED, unlock);

	
endmodule

