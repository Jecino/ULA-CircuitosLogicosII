module ULA (
	input logic [6:0] A,				//Operando A
	input logic [6:0] B,				//Operando B
	input logic [4:0] S,				//Seletores
	input logic R,						//Reset
	output logic [6:0] O,			//Output
	output logic CarryOver,			//CarryOver/overflow
	output logic zero					//Zero
);

//função soma(A, B, i)
function logic [6:0] soma;
	input logic [6:0] x, y;			//Operando x e y
	input logic i;						//Inverter segundo operando
	begin
		if (i)
			soma = x + ~y;
		else
			soma = x + y;
	end
endfunction

//função subtracao(A, B, i)
function logic [6:0] subtracao;
	input logic [6:0] x, y;			//Operando x e y
	input logic i;						//Inverter segundo operando
	begin
		if (i)
			subtracao = x - ~y;
		else
			subtracao = x - y;
	end
endfunction

//função incremento(x)
function logic [6:0] incremento;
	input logic [6:0] x;
	begin
		incremento = x++;
	end
endfunction

//função decremento(x)
function logic [6:0] decremento;
	input logic [6:0] x;
	begin
		decremento = x--;
	end
endfunction

always_comb begin
	//Operações lógicas
	if (S[3]) begin
		O = 6'b000000;
	end
	
	//Operações aritmétricas
	else begin
		case ({S[2], S[1], S[0]})
			3'b000: O = soma(A, B, 0);
			3'b001: O = subtracao(A, B, 0);
			3'b010: O = soma(A, B, 1);
			3'b011: O = subtracao(A, B, 1);
			3'b100: O = incremento(A);
			3'b101: O = decremento(A);
			3'b110: O = incremento(B);
			3'b111: O = decremento(B);
			default: O = 0;
		endcase
	end
		
end

endmodule