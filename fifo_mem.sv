module fifo_mem #(
	parameter FIFO_DEPTH = 8		        ,
	parameter DATA_WIDTH = 32               ,
	parameter AW         = $clog2(FIFO_DEPTH) 
)
(
	input					      i_clk  ,
	input					      i_rst_n,
	input  [DATA_WIDTH-1:0]       i_wdata,
	input  [AW-1:0]			      i_waddr,
	input					      i_wen  ,
	input  [AW-1:0]			      i_raddr,
	output logic [DATA_WIDTH-1:0] o_rdata 
);

	reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

	always @(posedge i_clk) begin
		if(i_wen) begin 
			fifo_mem[i_waddr] <= i_wdata;
		end
	end

	assign o_rdata = fifo_mem[i_raddr];


endmodule