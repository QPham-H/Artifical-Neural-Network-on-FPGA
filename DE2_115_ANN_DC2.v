module DE2_CCD
	(
		////////////////////	Clock Input	 	////////////////////	 
//		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[17:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,							//	Seven Segment Digit 0
		HEX1,							//	Seven Segment Digit 1
		HEX2,							//	Seven Segment Digit 2
		HEX3,							//	Seven Segment Digit 3
		HEX4,							//	Seven Segment Digit 4
		HEX5,							//	Seven Segment Digit 5
		HEX6,							//	Seven Segment Digit 6
		HEX7,							//	Seven Segment Digit 7
		////////////////////////	LED		////////////////////////
		LEDG,							//	LED Green[8:0]
		LEDR,							//	LED Red[17:0]
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,						//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_DQM,						//	SDRAM Data Mask 
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	VGA		////////////////////////////
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,  						//	VGA Blue[9:0]
		////////////////////	GPIO	////////////////////////////
		GPIO							//	GPIO Connection 1
	);

////////////////////////	Clock Input	 	////////////////////////
//input			CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[17:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
output	[6:0]	HEX4;					//	Seven Segment Digit 4
output	[6:0]	HEX5;					//	Seven Segment Digit 5
output	[6:0]	HEX6;					//	Seven Segment Digit 6
output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
output	[8:0]	LEDG;					//	LED Green[8:0]
output	[17:0]	LEDR;					//	LED Red[17:0]
///////////////////////		SDRAM Interface	////////////////////////
inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
output	[3:0] DRAM_DQM;				//	SDRAM Data Mask 
output			DRAM_WE_N;				//	SDRAM Write Enable
output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
output			DRAM_CS_N;				//	SDRAM Chip Select
output	[1:0]	DRAM_BA;				//	SDRAM Bank Address 0
output			DRAM_CLK;				//	SDRAM Clock
output			DRAM_CKE;				//	SDRAM Clock Enable
////////////////////////	I2C		////////////////////////////////
inout			I2C_SDAT;				//	I2C Data
output			I2C_SCLK;				//	I2C Clock
////////////////////////	VGA			////////////////////////////
output			VGA_CLK;   				//	VGA Clock
output			VGA_HS;					//	VGA H_SYNC
output			VGA_VS;					//	VGA V_SYNC
output			VGA_BLANK_N;				//	VGA BLANK
output			VGA_SYNC_N;				//	VGA SYNC
output	[7:0]	VGA_R;   				//	VGA Red[9:0]
output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
////////////////////////	GPIO	////////////////////////////////
inout	[35:0]	GPIO;					//	GPIO Connection 1

//assign DRAM_ADDR[12] = 1'b0;

assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;
assign	TD_RESET	=	1'b1;

//	All inout port turn to tri-state
assign	FL_DQ		=	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	OTG_DATA	=	16'hzzzz;
assign	LCD_DATA	=	8'hzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	=	1'bz;
assign	ENET_DATA	=	16'hzzzz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	=	1'bz;

//	CCD
wire	[9:0]	CCD_DATA;
wire			CCD_SDAT;
wire			CCD_SCLK;
wire			CCD_FLASH;
wire			CCD_FVAL;
wire			CCD_LVAL;
wire			CCD_PIXCLK;
reg				CCD_MCLK;	//	CCD Master Clock

wire	[15:0]	Read_DATA1;
wire	[15:0]	Read_DATA2;
wire			VGA_CTRL_CLK;
wire			AUD_CTRL_CLK;
wire	[9:0]	mCCD_DATA;
wire			mCCD_DVAL;
wire			mCCD_DVAL_d;
wire	[10:0]	X_Cont;
wire	[10:0]	Y_Cont;
wire	[9:0]	X_ADDR;
wire	[31:0]	Frame_Cont;
wire	[9:0]	mCCD_R;
wire	[9:0]	mCCD_G;
wire	[9:0]	mCCD_B;
wire			DLY_RST_0;
wire			DLY_RST_1;
wire			DLY_RST_2;
wire			Read;
reg		[9:0]	rCCD_DATA;
reg				rCCD_LVAL;
reg				rCCD_FVAL;
wire	[9:0]	sCCD_R;
wire	[9:0]	sCCD_G;
wire	[9:0]	sCCD_B;
wire			sCCD_DVAL;

wire	[9:0]	Red;
wire	[9:0]	Green;
wire	[9:0]	Blue;
wire  [9:0] X_coord;
wire  [9:0] Y_coord;

//	For Sensor 1
assign	CCD_DATA[0]	=	GPIO[0];
assign	CCD_DATA[1]	=	GPIO[1];
assign	CCD_DATA[2]	=	GPIO[5];
assign	CCD_DATA[3]	=	GPIO[3];
assign	CCD_DATA[4]	=	GPIO[2];
assign	CCD_DATA[5]	=	GPIO[4];
assign	CCD_DATA[6]	=	GPIO[6];
assign	CCD_DATA[7]	=	GPIO[7];
assign	CCD_DATA[8]	=	GPIO[8];
assign	CCD_DATA[9]	=	GPIO[9];
assign	GPIO[11]	=	CCD_MCLK;
assign	CCD_FVAL	=	GPIO[13];
assign	CCD_LVAL	=	GPIO[12];
assign	CCD_PIXCLK	=	GPIO[10];

assign	LEDR		=	SW;
assign	LEDG		=	Y_Cont;
assign	VGA_CTRL_CLK=	CCD_MCLK;
assign	VGA_CLK		=	~CCD_MCLK;

always@(posedge CLOCK_50)	CCD_MCLK	<=	~CCD_MCLK;

always@(posedge CCD_PIXCLK)
begin
	rCCD_DATA	<=	CCD_DATA;
	rCCD_LVAL	<=	CCD_LVAL;
	rCCD_FVAL	<=	CCD_FVAL;
end

VGA_Controller		u1	(	//	Host Side
							.oRequest(Read),
							.iRed(Read_DATA2[9:0]),
							.iGreen({Read_DATA1[14:10],Read_DATA2[14:10]}),
							.iBlue(Read_DATA1[9:0]),
							//	VGA Side
							.oVGA_R(Red),
							.oVGA_G(Green),
							.oVGA_B(Blue),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							.Draw_X(X_coord),
							.Draw_Y(Y_coord),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST_2)	);

Reset_Delay			u2	(	.iCLK(CLOCK_50),
							.iRST(KEY[0]),
							.oRST_0(DLY_RST_0),
							.oRST_1(DLY_RST_1),
							.oRST_2(DLY_RST_2)	);

CCD_Capture			u3	(	.oDATA(mCCD_DATA),
							.oDVAL(mCCD_DVAL),
							.oX_Cont(X_Cont),
							.oY_Cont(Y_Cont),
							.oFrame_Cont(Frame_Cont),
							.iDATA(rCCD_DATA),
							.iFVAL(rCCD_FVAL),
							.iLVAL(rCCD_LVAL),
							.iSTART(!KEY[3]),
							.iEND(1'b0/*!KEY[2]*/),
							.iCLK(CCD_PIXCLK),
							.iRST(DLY_RST_1)	);

RAW2RGB				u4	(	.oRed(mCCD_R),
							.oGreen(mCCD_G),
							.oBlue(mCCD_B),
							.oDVAL(mCCD_DVAL_d),
							.iX_Cont(X_Cont),
							.iY_Cont(Y_Cont),
							.iDATA(mCCD_DATA),
							.iDVAL(mCCD_DVAL),
							.iCLK(CCD_PIXCLK),
							.iRST(DLY_RST_1)	);

SEG7_LUT_8 			u5	(	.oSEG0(/*HEX0*/),.oSEG1(/*HEX1*/),
							.oSEG2(/*HEX2*/),.oSEG3(/*HEX3*/),
							.oSEG4(/*HEX4*/),.oSEG5(/*HEX5*/),
							.oSEG6(/*HEX6*/),.oSEG7(/*HEX7*/),
							.iDIG(Frame_Cont) );

Sdram_Control_4Port	u6	(	//	HOST Side
						    .REF_CLK(CLOCK_50),
						    .RESET_N(1'b1),
							//	FIFO Write Side 1
						    .WR1_DATA(	{sCCD_G[9:5],
										 sCCD_B[9:0]}),
							.WR1(sCCD_DVAL),
							.WR1_ADDR(0),
							.WR1_MAX_ADDR(640*512),
							.WR1_LENGTH(9'h100),
							.WR1_LOAD(!DLY_RST_0),
							.WR1_CLK(CCD_PIXCLK),
							//	FIFO Write Side 2
						    .WR2_DATA(	{sCCD_G[4:0],
										 sCCD_R[9:0]}),
							.WR2(sCCD_DVAL),
							.WR2_ADDR(22'h100000),
							.WR2_MAX_ADDR(22'h100000+640*512),
							.WR2_LENGTH(9'h100),
							.WR2_LOAD(!DLY_RST_0),
							.WR2_CLK(CCD_PIXCLK),
							//	FIFO Read Side 1
						    .RD1_DATA(Read_DATA1),
				        	.RD1(Read),
				        	.RD1_ADDR(640*16),
							.RD1_MAX_ADDR(640*496),
							.RD1_LENGTH(9'h100),
				        	.RD1_LOAD(!DLY_RST_0),
							.RD1_CLK(VGA_CTRL_CLK),
							//	FIFO Read Side 2
						    .RD2_DATA(Read_DATA2),
				        	.RD2(Read),
				        	.RD2_ADDR(22'h100000+640*16),
							.RD2_MAX_ADDR(22'h100000+640*496),
							.RD2_LENGTH(9'h100),
				        	.RD2_LOAD(!DLY_RST_0),
							.RD2_CLK(VGA_CTRL_CLK),
							//	SDRAM Side
						    .SA(DRAM_ADDR[11:0]),
						    .BA(DRAM_BA),
						    .CS_N(DRAM_CS_N),
						    .CKE(DRAM_CKE),
						    .RAS_N(DRAM_RAS_N),
				            .CAS_N(DRAM_CAS_N),
				            .WE_N(DRAM_WE_N),
						    .DQ(DRAM_DQ),
				            .DQM(DRAM_DQM[1:0]),
							.SDR_CLK(DRAM_CLK)	);

I2C_CCD_Config 		u7	(	//	Host Side
							.iCLK(CLOCK_50),
							.iRST_N(KEY[1]),
							.iExposure(SW[15:0]),
							//	I2C Side
							.I2C_SCLK(GPIO[14]),
							.I2C_SDAT(GPIO[15])	);

Mirror_Col			u8	(	//	Input Side
							.iCCD_R(mCCD_R),
							.iCCD_G(mCCD_G),
							.iCCD_B(mCCD_B),
							.iCCD_DVAL(mCCD_DVAL_d),
							.iCCD_PIXCLK(CCD_PIXCLK),
							.iRST_N(DLY_RST_1),
							//	Output Side
							.oCCD_R(sCCD_R),
							.oCCD_G(sCCD_G),
							.oCCD_B(sCCD_B),
							.oCCD_DVAL(sCCD_DVAL));

wire [7:0] weights, del_w;
wire [31:0] Hw_out;
wire input_Hw, calc_Hw, xfull, resetH, Hw_p, upRule, classify, x_values, x_avail;//storex, 
wire [15:0] to_hex;

Color_Mapper		map (.oVGA_R(Red),
							  .oVGA_B(Blue),
							  .oVGA_G(Green),
							  .Draw_X(X_coord),
							  .Draw_Y(Y_coord),
							  .VGA_Red(VGA_R),
							  .VGA_Blue(VGA_B),
							  .VGA_Green(VGA_G),
							  .x_values(x_values),
							  .Clk(VGA_CTRL_CLK),
							  .RST(!KEY[0]),
							 .Get_done(xfull),
							 .RstH(resetH),
							 .Get(x_avail)
							 );

Hw						 hw(.x(x_values),
							 .w(weights),
							 .RST(!KEY[0]),
							 .Clk(VGA_CTRL_CLK),
							 .Get(x_avail),
							 .ComputeH(calc_Hw),
							 .RstSum(resetH),
							 .Z(Hw_out)
							 );

Delta_W			  delw(.in(x_values),
							 .label(SW[17]),
							 .Hw(Hw_p),
							 .Clk(VGA_CTRL_CLK),
							 .Record_X(calc_Hw),
							 .RST(!KEY[0]),
							 .Get(x_avail),
							 .Up_W(upRule),
							 .delta_w(del_w));							 

Weights				  w(.delta_w(del_w),
							 .Clk(VGA_CTRL_CLK),
							 .ComputeH(calc_Hw),
							 .RST(!KEY[0]),
							 .Get(x_avail),
							 .Update(upRule),
							 .w_out(weights));

Classifier	   class0(.Z(Hw_out),
							 .RST(!KEY[0]),
							 .Clk(VGA_CTRL_CLK),
							 .classify(classify),
							 .Hw(Hw_p),
							 .To_Hex(to_hex)
							 );

HexDriver	  	 face3(.In0(to_hex[15:12]),
							 .Out0(HEX7));		
HexDriver	  	 face2(.In0(to_hex[11:8]),
							 .Out0(HEX6));	
HexDriver	  	 face1(.In0(to_hex[7:4]),
							 .Out0(HEX5));	
HexDriver	  	 face0(.In0(to_hex[3:0]),
							 .Out0(HEX4));	

NeuralNetwork		 NN(.Clk(VGA_CTRL_CLK),
							 .RST(!KEY[0]),
							 .Train(!KEY[2]),
							 .XFull(xfull),
							 .ComputeH(calc_Hw),
							 .New_frame(resetH),
							 //.RstH(resetH),
							 //.StoreX(storex),
							 .classify(classify),
							 .upRule(upRule));							 
	
													
endmodule
						
