//加法
module add(A, B, CO);
	input [2:0] A, B;
	output [7:0] CO;
	assign CO = A + B;
endmodule

//减法
module sub(A, B, CO);
	input [2:0] A, B;
	output reg [7:0] CO;
	
	always @(*)
	begin
		if(A >= B)
			CO = A - B;
		else
			CO = B - A;
	end
endmodule

//乘法
module mul(A, B, CO);
	input [2:0] A, B;
	output [7:0] CO;
	assign CO = A * B;
endmodule

//除法
module div(A, B, CO);
	input [2:0] A, B;
	output [7:0] CO;
	assign CO = A / B;
endmodule

//四选一，根据K的值选择结果
module mux(i1, i2, i3, i4, K, out);
	input [7:0] i1, i2, i3, i4;
	input [1:0] K;
	output reg [7:0] out;
	
	always @(*)
	begin
		case(K)
			2'b00: out = i1;
			2'b01: out = i2;
			2'b10: out = i3;
			2'b11: out = i4;
		endcase
	end
endmodule

//显示译码器，显示符号位和高位低位输出
module display(A, B, K, out, RH, RL, sign);
	input [2:0] A, B;
	input [1:0] K;
	input [7:0] out;
	
	output reg sign;
	output reg [3:0] RH;
	output reg [6:0] RL;
	
	//根据K的符号设置和A与B的大小关系，设置符号位输出
	always @(*)
	begin
		if(K == 2'b01 && A < B)
			sign = 1;
		else
			sign = 0;
	end
	
	//根据out的大小范围，设置高位输出
	always @(*)
	begin
		//如果是除法且B为0，则高位显示0，低位显示为E，表示报错error，低位处理见下
		if(K == 2'b11 && B == 0)
			RH = 0;
		else if(out >= 0 && out <= 9)
			RH = 0;
		else if(out >= 10 && out <= 19)
			RH = 1;
		else if(out >= 20 && out <= 29)
			RH = 2;
		else if(out >= 30 && out <= 39)
			RH = 3;
		else 
			RH = 4;
	end
	
	//根据out的个位，设置低位输出
	always @(*)
	begin
	//如果是除法且B为0，则高位显示0，低位显示为E，表示报错error，高位处理见上
		if(K == 2'b11 && B == 0)
			RL = 7'b1001111;
		else if(out % 10 == 0)
			RL = 7'b1111110;
		else if(out % 10 == 1)
			RL = 7'b0110000;
		else if(out % 10 == 2)
			RL = 7'b1101101;
		else if(out % 10 == 3)
			RL = 7'b1111001;
		else if(out % 10 == 4)
			RL = 7'b0110011;
		else if(out % 10 == 5)
			RL = 7'b1011011;
		else if(out % 10 == 6)
			RL = 7'b1011111;
		else if(out % 10 == 7)
			RL = 7'b1110000;
		else if(out % 10 == 8)
			RL = 7'b1111111;
		else 
			RL = 7'b1111011;
	end

endmodule

//主体模块
module lab7(A, B, K, RH, RL, sign);
	input [2:0] A, B;
	input [1:0] K;
	
	output sign;
	
	output [3:0] RH; //高位接ABCD
	output [6:0] RL; //低位接abcdefg
	
	wire [7:0] add_out, sub_out, mul_out, div_out;
	wire [7:0] out;
	
	add add1(A, B, add_out);
	sub sub1(A, B, sub_out);
	mul mul1(A, B, mul_out);
	div div1(A, B, div_out);
	mux mux1(add_out, sub_out, mul_out, div_out, K, out);
	
	display display1(A, B, K, out, RH, RL, sign);
	
endmodule
