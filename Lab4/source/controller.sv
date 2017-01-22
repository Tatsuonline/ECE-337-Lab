module controller (

input wire clk,
input wire n_reset,
input wire dr,
input wire overflow,

output reg cnt_up,
output reg modwait, 
output reg [1:0] op, 
output reg [3:0] src1, 
output reg [3:0] src2, 
output reg [3:0] dest, 
output reg err

);
  
  typedef enum bit [3:0] {idle, eidle, store, sort1, sort2, sort3, sort4, add1, add2, add3} state_type;
   state_type state;
   state_type nextstate;
  
   reg errorRegister = 1'b0;
   reg modwaitRegister= 1'b0;
   
   always @ (posedge clk, negedge n_reset) begin : Reset_Logic
      
     if(n_reset == 1'b0) begin
       state <= idle;
       modwait <= 1'b0;
       err <= 1'b0;
     end else begin
       state <= nextstate;
       modwait <= modwaitRegister;
       err <= errorRegister;
     end
      
  //assign modwait = modwaitRegister;
  //assign err = errorRegister;

  end

  always_comb begin : State_Logic
    nextstate = state;
     
    case(state)
      
      idle: begin
         if (dr == 1'b0) begin
            nextstate = idle;
         end else begin
            nextstate = store;
         end
	   end
      
      store: begin
	 if (dr == 1'b0) begin
	    nextstate = eidle;
	 end else begin
	    nextstate = sort1;
	 end
	 end
	       
      sort1: begin
	 nextstate = sort2;
      end
      
      sort2: begin
        nextstate = sort3;
      end
        
      sort3: begin
        nextstate = sort4;
      end
        
      sort4: begin
        nextstate = add1;
      end
        
      add1: begin
	 if (overflow == 1'b1) begin
            nextstate = eidle;
         end else begin
            nextstate = add2;
         end
      end
    
      add2: begin
        if (overflow == 1'b1) begin
          nextstate = eidle;
        end else begin
          nextstate = add3;
        end
      end
      
      add3: begin
        if (overflow == 1'b1) begin
          nextstate = eidle;
        end else begin
          nextstate = idle;
        end
      end
        
      eidle: begin
        if (dr == 1'b0) begin
          nextstate = eidle;
        end else begin
          nextstate = store;
        end
      end
      
    endcase
  end
  
   always @ (state) begin : Register_Logic
    
      case(state)
       
	idle: begin // src1 = 4'hf; src2 = 4'hf; dest = 4'hf;
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h0; src1 = 4'h0; src2 = 4'h0; dest = 4'h0;
           modwaitRegister = 1'b0;
	end
      
	store: begin //changed op from 2'h0; 
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h2; src1 = 4'hf; src2 = 4'hf; dest = 4'h5;
           modwaitRegister = 1'b1;
	end
	
	sort1: begin //changed op from 2'h2; src1 = 4'hf; src2 = 4'hf; dest = 4'h7;
           cnt_up = 1'b1; errorRegister = 1'b0;
           op = 2'h1; src1 = 4'h2; src2 = 4'hf; dest = 4'h1;
           modwaitRegister = 1'b1;
	end
        
	sort2: begin //op = 2'h1; src1 = 4'h4; src2 = 4'hf; dest = 4'h3;
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h1; src1 = 4'h3; src2 = 4'hf; dest = 4'h2;
	   modwaitRegister = 1'b1;
	end
        
	sort3: begin //op = 2'h1; src1 = 4'h5; src2 = 4'hf; dest = 4'h4;
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h1; src1 = 4'h4; src2 = 4'hf; dest = 4'h3;
	   modwaitRegister = 1'b1;
	end
        
	sort4: begin//op = 2'h1; src1 = 4'h6; src2 = 4'hf; dest = 4'h5;
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h1; src1 = 4'h5; src2 = 4'hf; dest = 4'h4;
	   modwaitRegister = 1'b1;
	end
        
	add1: begin //op = 2'h3; src1 = 4'h7; src2 = 4'hf; dest = 4'h6;
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h3; src1 = 4'h4; src2 = 4'h3; dest = 4'h6;
	   modwaitRegister = 1'b1;
	end
        
	add2: begin //op = 2'h3; src1 = 4'h3; src2 = 4'h4; dest = 4'h2;
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h3; src1 = 4'h1; src2 = 4'h2; dest = 4'h7;
	   modwaitRegister = 1'b1;
	end
        
	add3: begin //op = 2'h3; src1 = 4'h2; src2 = 4'h5; dest = 4'h1;
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h3; src1 = 4'h6; src2 = 4'h7; dest = 4'h0;
	   modwaitRegister = 1'b1;
	end
        
	eidle: begin //changed op from 2'h3
           cnt_up = 1'b0; errorRegister = 1'b1;
           op = 2'h0; src1 = 4'h1; src2 = 4'h6; dest = 4'h0;
	   modwaitRegister = 1'b1;
	end

	default: begin
           cnt_up = 1'b0; errorRegister = 1'b0;
           op = 2'h0; src1 = 4'hf; src2 = 4'hf; dest = 4'hf;
           modwaitRegister = 1'b0;
	end

      endcase
   end
   
endmodule
