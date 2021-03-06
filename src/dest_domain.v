module dest_domain#(
	parameter DATAWIDTH = 8 
)
(
	input 								CLK				,
	input 								RSTn			,
	input 		[ DATAWIDTH - 1 : 0 ] 	src2dest_data	,
	input  								src2dest_load	,
	output reg					 		dest_data_valid	,
	output reg	[ DATAWIDTH - 1 : 0 ] 	dest_data_out
);
wire dest_valid;
wire ldtoggle_sy;
reg  ldtoggle_sy_dl;

always @(posedge CLK or negedge RSTn) 
begin
	if (!RSTn) 
		begin
			dest_data_valid <= 0;
			dest_data_out <= 0;
			ldtoggle_sy_dl <= 0;
		end
	else 
		begin
			ldtoggle_sy_dl <= ldtoggle_sy;
			dest_data_valid <= dest_valid;
		end
end

assign dest_valid = ldtoggle_sy ^ ldtoggle_sy_dl;

always @(posedge CLK or negedge RSTn) 
begin
if (dest_valid)
	 	begin
			dest_data_out <= src2dest_data;
		end
end
sync2FF sync2FF_inst(	.CLK	(CLK			)		,
						.RSTn	(RSTn			)		,
						.D 		(src2dest_load	)		,	
						.Q		(ldtoggle_sy 	))		;

endmodule