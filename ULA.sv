module ULA (
	input logic [5:0] A,				//Operando A
	input logic [5:0] B,				//Operando B
	input logic [3:0] S,				//Seletores
	input logic R,						//Reset
	output logic [5:0] O,			//Output
	output logic CarryOver,			//CarryOver/overflow
	output logic zero					//Zero
);

//função soma(A, B, i, S, C)
task automatic soma(
	input logic [5:0] x, y,			//Operando x e y
	input logic i,						//Inverter segundo operando
	output logic [5:0] S,			//Output Soma
	output logic c_out				//CarryOut
);									
	logic [6:0] resultado;
	if (i)
		resultado = x + ~y;
	else
		resultado = x + y;
		
	S = resultado[5:0];				//Pega apenas a parte baixa da soma
	c_out = resultado[6];			//ultimo bit é o carry

endtask

//função subtracao(A, B, i, S, c_out)
task automatic subtracao(
	input logic [5:0] x, y,			//Operando x e y
	input logic i,						//Inverter segundo operando
	output logic [5:0] S,			//Output Subtracao
	output logic c_out				//carryOut
);
	logic [6:0] resultado;
	
		if (i)
			// x - ~y = x + (y + 1)
			resultado = x + y + 1;
		else
			// x - y = x + (~y + 1)
			resultado = x + (~y + 1);
	
	S = resultado[5:0];			
	c_out = resultado[6];			// 1 = sem borrow, 0 = borrow
endtask

//função incremento(x, O, c_out)
task automatic incremento(
	input logic [5:0] x,				//Operando x
	output logic [5:0] O,			//Output
	output logic c_out				//carryOut
);
	logic [6:0] resultado;
	resultado = x + 1'b000001;
	
	O = resultado[5:0];
	c_out = resultado[6];

endtask

//função decremento(x, O, c_out)
task automatic decremento(
	input logic [5:0] x,				//Operando x
	output logic [5:0] O,			//Output
	output logic c_out				//CarryOut
);
	logic [6:0] resultado;
	// x - 1 = x + ~1 + 1
	resultado = x + ~(1'b000001) + 1;
	
	O = resultado[5:0];
	c_out = resultado[6];			// 1 = sem borrow, 0 = borrow
endtask

//função and(A, B, 

always_comb begin
	//Valores padrão
	O = 6'bXXXXXX;
	CarryOver = 1'b0;
	zero = 1'b0;
	
	//Caso reset esteja ativado
	if (R) begin
		O = 6'b000000;
		CarryOver = 1'b0;
		zero = 1'b0;
   end
	
	//Operações lógicas
	else if (S[3]) begin
		case ({S[2], S[1], S[0]})
			3'b000: O = A & B; 	//porta AND
			3'b001: O = ~A; 		//porta NOTA
			3'b010: O = ~B;		//porta NOTB
			3'b011: O = A | B; 	//porta OR
			3'b100: O = A ^ B; 	//porta XOR
			3'b101: O = ~(A & B);//porta NAND
			3'b110: O = A;			//Sai A
			3'b111: O = B;			//Sai B
			default:	O = 6'b000000;
		endcase
		
		if (O == 0) begin
			zero = 1'b1;
		end
	end
	
	//Operações aritmétricas
	else begin
		case ({S[2], S[1], S[0]})
			3'b000: soma(A, B, 0, O, CarryOver);
			3'b001: subtracao(A, B, 0, O, CarryOver);
			3'b010: soma(A, B, 1, O, CarryOver);
			3'b011: subtracao(A, B, 1, O, CarryOver);
			3'b100: incremento(A, O, CarryOver);
			3'b101: decremento(A, O, CarryOver);
			3'b110: incremento(B, O, CarryOver);
			3'b111: decremento(B, O, CarryOver);
			default: O = 0;
		endcase
		
		if (O == 0) begin
			zero = 1'b1;
		end
	end
		
end

endmodule