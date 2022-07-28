module read_control #(
	parameter AW = 10
)
(
	input							i_clk            , // Clock signal
	input							i_rst_n          , // Source domain asynchronous reset (active low)
	input							i_ready_m        , // Request read data from FIFO
	input			[AW - 1:0]		i_almostempty_lvl, // The number of empty memory locations in the FIFO at which the o_almostempty flag is active
	input			[AW:0]	    	i_wptr           ,
	output	logic	[AW:0]       	o_rptr           ,
	output			[AW - 1:0]		o_raddr          ,
	output							o_ren            ,
	output							o_almostempty    , // FIFO almostempty flag (determined by i_almostempty_lvl)
	output							o_empty          ,  // FIFO empty flag
	output               		    o_valid_m        
);

	assign o_raddr = o_rptr[AW - 1:0];

	assign o_empty = (o_rptr == i_wptr);

	assign o_valid_m = ~o_empty;

	assign o_ren   = ~o_empty & i_ready_m;

	assign o_almostempty = (i_wptr - o_rptr) <= i_almostempty_lvl;

	always_ff @(posedge i_clk or negedge i_rst_n) begin
		if(~i_rst_n) begin
			o_rptr <= 0;
		end else begin
			if(o_ren) begin 
				o_rptr <= o_rptr + 1'b1;
			end else begin 
				o_rptr <= o_rptr;
			end
		end
	end
	
endmodule