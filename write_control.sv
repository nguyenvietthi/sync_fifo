module write_control #(
	parameter AW = 10
)
(
	input			    							i_clk            , // Clock signal
	input			    							i_rst_n          , // Source domain asynchronous reset (active low)
	input			    							i_valid_s        , // Request write data from FIFO
	input			    [AW - 1:0]		i_almostfull_lvl , // The number of empty memory locations in the FIFO at which the o_almostempty flag is active
	input			    [AW:0]				i_rptr           ,
	output	logic	[AW:0]        o_wptr           ,
	output				[AW - 1:0]		o_waddr          ,
	output 											o_wen            ,
	output 											o_almostfull     , // FIFO almostempty flag (determined by i_almostempty_lvl)
	output 											o_full           ,  // FIFO empty flag
	output                 			o_ready_s        
);
	


	assign o_waddr = o_wptr[AW - 1:0];

	assign o_full  = ({~o_wptr[AW],o_wptr[AW - 1:0]} == i_rptr);

	assign o_ready_s = ~o_full;

	assign o_wen   = ~o_full & i_valid_s;

	assign o_almostfull = (o_wptr - i_rptr) >= i_almostfull_lvl;

	always_ff @(posedge i_clk or negedge i_rst_n) begin
		if(~i_rst_n) begin
			o_wptr <= 0;
		end else begin
			if(o_wen) begin 
				o_wptr <= o_wptr + 1'b1;
			end else begin 
				o_wptr <= o_wptr;
			end
		end
	end
	
endmodule