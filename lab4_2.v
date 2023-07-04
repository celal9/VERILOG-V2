`timescale 1ns / 1ps

module lab4_2(// INPUTS
              input wire      mode,
              input wire[2:0] opCode,
              input wire[3:0] value,
              input clk,
              input reset,
              // OUTPUTS
              output reg[9:0] result,
              output reg cacheFull,
              output reg invalidOp,
              output reg overflow);
				  reg [9:0] resprepre;
				  reg [9:0] respre;
				  reg [7:0] ins [31:0];//x xxx xxxx
				  reg [4:0] locate;
				  integer i,j;
					reg[4:0] v;//for SETR
					reg [3:0] valu;
    //================//
    // INITIAL BLOCK  //
    //================//
    //Modify the lines below to implement your design
    initial begin
			locate=0;
       
			for(i=0;i<32;i=i+1) ins[i]=0;
			v=0;
			valu=0;
			resprepre=0;
			respre=0;
			locate=0;
			invalidOp=0;
			cacheFull=0;
			overflow=0;
    end

    //================//
    //      LOGIC     //
    //================//
    //Modify the lines below to implement your design
    always @(posedge clk or posedge reset)
    begin
      if(reset)begin
        result=10'bxxxxxxxxxx;
        for(i=0;i<32;i=i+1) ins[i]=0;
        v=0;
        valu=0;
        resprepre=0;
        respre=0;
        invalidOp=0;
        cacheFull=0;
        overflow=0;
      end
      else begin
        if(~mode)begin
          if(opCode==3'b000 || opCode==3'b001 || opCode==3'b010 || opCode==3'b100 || opCode==3'b101 || opCode==3'b110)begin 
            invalidOp=0;
            for(i=0;i<32;i=i+1)begin
              if(ins[31][7]==1 && i==31)begin
            	cacheFull=1;
              end
              if(ins[i][7]==0)begin
                for(j=0;j<3;j=j+1)begin
                  ins[i][j+4]=opCode[j];
                end
                if(value==0||value==1||value==2||value==3||value==4||value==5||value==6||value==7)begin
                  for(j=0;j<4;j=j+1)begin
                    ins[i][j]=value[j];
                  end
                end
                else begin
                  for(j=0;j<4;j=j+1)begin
                    ins[i][j]=0;
                  end
                end
                ins[i][7]=1;
                i=32;
              end
            end
          end
          else begin
            invalidOp=1;
          end
          result=10'bxxxxxxxxxx;  
        end
        if(mode)begin
          
          valu[0]= ins[locate][0];
          valu[1]= ins[locate][1];
          valu[2]= ins[locate][2];
          valu[3]= ins[locate][3];
          if(ins[locate][6] ==0 && ins[locate][5]== 0 && ins[locate][4] == 0 )begin
            invalidOp=0;
			if(respre+valu>1023)begin
              overflow=1;
            end
            else begin
              overflow=0;
            end
            result=respre+valu;
            resprepre=respre;
			respre=result;
          end
          else if(ins[locate][6] ==0 && ins[locate][5]== 0 && ins[locate][4] == 1)begin
            invalidOp=0;
            if(resprepre+respre+valu>1023)begin
              overflow=1;
            end
            else begin
              overflow=0;
            end
			result=resprepre+respre+valu;
			resprepre=respre;
			respre=result;
          end
          else if(ins[locate][6] ==0 && ins[locate][5]== 1 && ins[locate][4] == 0)begin
            invalidOp=0;
            if((resprepre*respre)+valu>1023)begin
              overflow=1;
            end
            else begin
              overflow=0;
            end
            result=(resprepre*respre)+valu;
			resprepre=respre;
			respre=result;
          end
          else if(ins[locate][6] ==1 && ins[locate][5]== 0 && ins[locate][4] == 0)begin
            invalidOp=0;
			result=0;
            overflow=0;
			for(j=0;j<10;j=j+1)begin
              result=result+respre[j];
			end
			resprepre=respre;
			respre=result;
          end
          else if(ins[locate][6] ==1 && ins[locate][5]== 0 && ins[locate][4] == 1)begin
            invalidOp=0;
            overflow=0;
            for(j=0;j<10;j=j+1)begin
              result[9-j]=respre[j];
			end
			resprepre=respre;
			respre=result;
          end
          else if(ins[locate][6] ==1 && ins[locate][5]== 1 && ins[locate][4] == 0)begin
            invalidOp=0;
            overflow=0;
            v=valu;
            result=respre;
          end
          else begin
            overflow=0;
            invalidOp=1;
          end
          if(ins[locate+1][7]==1)begin 
          	locate=locate+1;
          end
          else begin
            locate=v;
          end
        end
      end
    end
endmodule
