module lab4ROM (
  input [3:0] romAddr, 
  output reg [4:0] romOutput);
  reg [4:0] rm[15:0];
  
  always @(romAddr)begin
    
    rm[0]=5'b00000;
    rm[1]=5'b00001;
    rm[2]=5'b00110;
    rm[3]=5'b00111;
    rm[4]=5'b01011;
    rm[5]=5'b01100;
    rm[6]=5'b01101;
    rm[7]=5'b01110;
    rm[8]=5'b11101;
    rm[9]=5'b11110;
    rm[10]=5'b11111;
    rm[11]=5'b10000;
    rm[12]=5'b10111;
    rm[13]=5'b11000;
    rm[14]=5'b11001;
    rm[15]=5'b11010;
    romOutput=rm[romAddr];
  end
  
endmodule
																							
module lab4RAM (
	input ramMode, //0:read, 1:write
	input [3:0] ramAddr, 
	input [4:0] ramInput,
	input  ramOp, //0:polynomial, 1:derivative
	input [1:0] ramArg,  //00:+1, 01:+2, 10:-1, 11:-2
	input CLK, 
	output reg [8:0] ramOutput);
  	
  reg [8:0] regg [15:0];
  integer memm;
  integer i;
  initial begin
    
    for(i = 0; i <= 15; i = i + 1)begin
      regg[i] = 9'b000000000;
      
    end
    
  end
  always @(ramMode,ramAddr,ramInput,ramOp,ramArg)begin
    if(ramMode==0)begin
      memm=ramAddr;
      ramOutput=regg[memm];     
      	
    end
  end
  integer x4,x3,x2,x1,x0,total,x;
    
  always @(posedge CLK)begin
    
    if(ramMode==1)begin
      memm=ramAddr;
      x4=0;
      x3=0;
      x2=0;
      x1=0;
      x0=0;
      total=0;
      if(ramArg == 2'b00)begin
      	x=1;
      end
      else if(ramArg == 2'b01)begin
      	x=2;
      end
      else if(ramArg == 2'b10)begin
      	x=-1;
      end
      else begin
      	x=-2;
      end
      if(ramOp==0)begin //pol
      	x4=x*x*x*x;
        x3=x*x*x;
        x2=x*x;
        x1=x;
        x0=1;
        if(ramInput[4]==1)begin
          x4=-x4;
        end
        if(ramInput[3]==1)begin
          x3=-x3;
        end
        if(ramInput[2]==1)begin
          x2=-x2;
        end
        if(ramInput[1]==1)begin
          x1=-x1;
        end
        
        if(ramInput[0]==1)begin
          x0=-x0;
        end
        total=x4+x3+x2+x1+x0;
        if(total<0)begin
          total=-total;
          regg[memm][8]=1;
        end
        else begin 
          regg[memm][8]=0;
        end
          for(i = 0; i <= 7; i = i + 1)begin
            regg[memm][i]=total%2;
            total=total/2;
          end
          
        
      end
      else if(ramOp==1)begin//der
        x4=4*(x*x*x);
        x3=3*(x*x);
        x2=2*x;
        x1=1;
        if(ramInput[4]==1)begin
          x4=-x4;
        end
        if(ramInput[3]==1)begin
          x3=-x3;
        end
        if(ramInput[2]==1)begin
          x2=-x2;
        end
        if(ramInput[1]==1)begin
          x1=-x1;
        end
        
        
        total=x4+x3+x2+x1;
        if(total<0)begin
          total=-total;
          regg[memm][8]=1;
        end
        else begin 
          regg[memm][8]=0;
        end
          for(i = 0; i <= 7; i = i + 1)begin
            regg[memm][i]=total%2;
            total=total/2;
          end
          
        
      end
    	
    end
    
  end	

endmodule


module polMEM(input mode, input [3:0] memAddr, input op, input [1:0] arg, input CLK, output wire [8:0] memOutput);

	/*Don't edit this module*/
	wire [4:0]  romOutput;

	lab4ROM RO(memAddr, romOutput);
	lab4RAM RA(mode, memAddr, romOutput, op, arg, CLK, memOutput);



endmodule