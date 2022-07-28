module sync_fifo #(
	parameter FIFO_DEPTH = 8		        ,
	parameter DATA_WIDTH = 32               ,
	parameter AW         = $clog2(FIFO_DEPTH) 
)
(
	input                   	i_clk            , // Clock signal
	input                   	i_rst_n          , // Source domain asynchronous reset (active low)
	input                   	i_valid_s        , // Request write data into FIFO
	input  [AW-1:0] 			i_almostfull_lvl , // The number of empty memory locations in the FIFO at which the o_almostfull flag is active
	input  [DATA_WIDTH-1:0] 	i_datain         , // Push data in FIFO
	input                   	i_ready_m        , // Request read data from FIFO
	input  [AW-1:0]				i_almostempty_lvl, // The number of empty memory locations in the FIFO at which the o_almostempty flag is active
	output                  	o_ready_s        , // Status write data into FIFO (if FIFO not full then o_ready_s = 1)					
	output                  	o_almostfull     , // FIFO almostfull flag (determined by i_almostfull_lvl)
	output                  	o_full           , // FIFO full flag
	output                  	o_valid_m        , // Status read data from FIFO (if FIFO not empty then o_valid_m = 1)
	output                  	o_almostempty    , // FIFO almostempty flag (determined by i_almostempty_lvl)
	output                  	o_empty          , // FIFO empty flag
	output  [DATA_WIDTH-1:0] 	o_dataout          // Pop data from FIFO
);
	logic		[AW:0]			wptr ;
	logic		[AW:0]        	rptr ;
	logic		[AW - 1:0]		raddr;
	logic		[AW - 1:0]   	waddr;
	logic						ren	 ;
	logic						wen  ;

	fifo_mem #(
		.FIFO_DEPTH (FIFO_DEPTH), 
		.DATA_WIDTH (DATA_WIDTH), 
		.AW         (AW        )  
	) fifo_mem_ins (
		.i_clk   (i_clk    ),
		.i_rst_n (i_rst_n  ),
		.i_wdata (i_datain ),
		.i_waddr (waddr    ),
		.i_wen   (wen 	   ),
		.i_raddr (raddr    ),
		.o_rdata (o_dataout)
	);

	write_control #(
		.AW (AW)
	) write_control_ins (
		.i_clk            (i_clk           ),
		.i_rst_n          (i_rst_n         ),
		.i_valid_s        (i_valid_s       ),
		.i_almostfull_lvl (i_almostfull_lvl),
		.i_rptr           (rptr        	   ),
		.o_wptr           (wptr        	   ),
		.o_waddr          (waddr       	   ),
		.o_wen            (wen         	   ),
		.o_almostfull     (o_almostfull    ),
		.o_full           (o_full          ),
		.o_ready_s		  (o_ready_s	   )
	);

	read_control #(
		.AW(AW)
	)read_control_ins(
		.i_clk             (i_clk            ),
		.i_rst_n           (i_rst_n          ),
		.i_ready_m         (i_ready_m        ),
		.i_almostempty_lvl (i_almostempty_lvl),
		.i_wptr            (wptr             ),
		.o_rptr            (rptr             ),
		.o_raddr           (raddr            ),
		.o_ren             (ren              ),
		.o_almostempty     (o_almostempty    ),
		.o_empty           (o_empty          ),
		.o_valid_m 		   (o_valid_m        )
	);
endmodule