`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module font_test_gen(
   input wire clk,
   input wire video_on,
   input wire [9:0] pixel_x, pixel_y,
	output reg [2:0] rgb_text,
	output wire font_bit

    );

   // signal declaration 1
	wire [10:0] rom_addr;
   reg [6:0] char_addr;
   wire [3:0] row_addr;
   wire [2:0] bit_addr;
   wire [7:0] font_word;
	reg text_bit_on;
	reg [2:0] texto;

   // body
   // instantiate font ROM
   font_rom font_unit
      (.clk(clk), .addr(rom_addr), .data(font_word));

   // font ROM interface letras 1
   assign row_addr = pixel_y[4:1];				//escalado
   assign rom_addr = {char_addr, row_addr};	
   assign bit_addr = pixel_x[3:1];				//escalado
   assign font_bit = font_word[~bit_addr];

	
	//asignando variable para diferentes coordenadas en y
	
	always @*
	  // region delimitada para el texto
	case (pixel_y[9:5])
	
	00:
		begin
			text_bit_on = 1;
				texto=3'b110;
				case(pixel_x[9:4]) //ya tiene dimenciones correctas
					6'h2: char_addr = 7'h46; // F
					6'h3: char_addr = 7'h45; // E					
					6'h4: char_addr = 7'h43; // C
					6'h5: char_addr = 7'h48; // H					
					6'h6: char_addr = 7'h41; // A	
					default: char_addr = 7'h00; //espacio en blanco
				endcase
		end
		
	05:
		begin
			text_bit_on = 1;
				texto=3'b011;
				case(pixel_x[9:4]) //ya tiene dimenciones correctas
					6'h2: char_addr = 7'h48; // H
					6'h3: char_addr = 7'h4f; // O
					6'h4: char_addr = 7'h52; // R
					6'h5: char_addr = 7'h41; // A			
					default: char_addr = 7'h00; //espacio en blanco
				endcase
		end
		
	09:
		begin
			text_bit_on = 1;
				texto=3'b110;
				case(pixel_x[9:4]) //ya tiene dimenciones correctas
					6'h2: char_addr = 7'h54; // T
					6'h3: char_addr = 7'h49; // I					
					6'h4: char_addr = 7'h45; // E
					6'h5: char_addr = 7'h4d; // M					
					6'h6: char_addr = 7'h50; // P
					6'h7: char_addr = 7'h4f; // O
					
					6'h20: char_addr = 7'h01; // Marca
					default: char_addr = 7'h00; //espacio en blanco
				endcase
		end

	default:
		begin
		text_bit_on =0;
		end
	endcase



   // rgb multiplexing circuit
   always @*
      if (~video_on) //se cambia a rojo
         rgb_text = 3'b000; // zona prohibida
      else
			begin
			if (~text_bit_on)
				begin
				rgb_text=3'b101;
				end
			else
				if (font_bit) //hay que pintar pixel letra
					begin
					rgb_text = texto;
					end
				else
					begin
					rgb_text=3'b101; //mismo color del fondo de pantalla
					end
			end

endmodule
