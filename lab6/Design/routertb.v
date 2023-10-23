

`include "router.v"
`timescale 1us/1us

module routertb;


reg [31:0]	local_in,north_in,south_in,west_in,east_in;
wire [31:0]	north_out,south_out,west_out,east_out,local_out;
wire [2:0]	count_out_north,count_out_south,count_out_east,count_out_west,count_out_local;
reg  [2:0]	count_in_north,count_in_south,count_in_east,count_in_west,count_in_local;
reg		clk,reset,enable,push_north,push_south,push_east,push_west,push_local;
reg [1:0] 	routeridx,routeridy;
wire pop_north,pop_south,pop_east,pop_west,pop_local;


router u6(
		.routeridx(routeridx),
		.routeridy(routeridy),
		.local_in(local_in),
		.north_in(north_in),
		.south_in(south_in),
		.west_in(west_in),
		.east_in(east_in),
		.local_out(local_out),
		.north_out(north_out),
		.south_out(south_out),
		.west_out(west_out),
		.east_out(east_out),
		.count_out_north(count_out_north),
		.count_out_south(count_out_south),
		.count_out_east(count_out_east),
		.count_out_west(count_out_west),
		.count_out_local(count_out_local),
		.count_in_north(count_in_north),
		.count_in_south(count_in_south),
		.count_in_east(count_in_east),
		.count_in_west(count_in_west),
		.count_in_local(count_in_local),
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.push_north(push_north),
		.push_south(push_south),
		.push_east(push_east),
		.push_west(push_west),
		.push_local(push_local),
		.pop_north(pop_north),
		.pop_south(pop_south),
		.pop_east(pop_east),
		.pop_west(pop_west),
		.pop_local(pop_local)


);




initial begin

	$dumpfile("router.vcd");
	$dumpvars(0,routertb);
	routeridx <= 2'b00;
	routeridy <= 2'b00;
	north_in <= 32'b0;
	south_in <= 32'b0;
	east_in <= 32'b0;
	west_in <= 32'b0;
	local_in <= 32'b0;
	clk <= 0;
	reset <= 1;
	enable <= 1;
	count_in_north <= 3'b000;
	count_in_south <= 3'b000;
	count_in_east <= 3'b000;
	count_in_west <= 3'b000;
	count_in_local <= 3'b000;
	
	#1000 $finish;
	

end

always begin

#10 clk = ~clk ;

end

always begin

#15 reset <= 0;
#0 enable <= 1;
//north input---------------

//#20 north_in <= 32'b1;
//#20 north_in <= 32'b0;
//#20 north_in <= 32'b1;
//#20 north_in <= 32'b0;

//south input-----------------

//header

//#0 south_in <= 32'b0100_00--xsource 00--ysource_00--xdes 11--ydes_0000_0000_0000_0000_1001;
#0 push_north <=1;
#0 push_south <=1;
#0 push_east <=1;
#0 push_west <=1;
#0 push_local <=1;
#0 south_in <= 32'b0100_0000_0000_0000_0000_0000_0000_1001;
#0 north_in <= 32'b0100_0000_1100_0000_0000_0000_0000_0001;
#0 east_in <= 32'b0100_1100_0000_0000_0000_0000_0001_0001;
#0 west_in <= 32'b0100_0000_0011_0000_0000_0000_0001_1001;
#0 local_in <= 32'b0100_0011_0000_0000_0000_0000_0010_0001;

//body
#20 south_in <= 32'b1000_1000_1000_1000_1000_1000_0000_1010;
#0 north_in <= 32'b1000_1000_1000_1000_1000_1000_0000_0010;
#0 east_in <= 32'b1000_1000_1000_1000_1000_1000_0001_0010;
#0 west_in <= 32'b1000_1000_1000_1000_1000_1000_0001_1010;
#0 local_in <= 32'b1000_1000_1000_1000_1000_1000_0010_0010;

#20 south_in <= 32'b1000_1000_1000_1000_1000_1000_0000_1011;
#0 north_in <= 32'b1000_1000_1000_1000_1000_1000_0000_0011;
#0 east_in <= 32'b1000_1000_1000_1000_1000_1000_0001_0011;
#0 west_in <= 32'b1000_1000_1000_1000_1000_1000_0001_1011;
#0 local_in <= 32'b1000_1000_1000_1000_1000_1000_0010_0011;

//tatil
#20 south_in <= 32'b1100_0000_0000_0000_0000_0000_0000_1100;
#0 north_in <= 32'b1100_0000_0011_0000_0000_0000_0000_0100;
#0 east_in <= 32'b1100_0000_0011_0000_0000_0000_0001_0100;
#0 west_in <= 32'b1100_0000_0011_0000_0000_0000_0001_1100;
#0 local_in <= 32'b1100_0000_0011_0000_0000_0000_0010_0100;

#20 push_north <=0;
#0 push_south <=0;
#0 push_east <=0;
#0 push_west <=0;
#0 push_local <=0;

//header

#200 south_in <= 32'b0100_0000_0000_0000_0000_0000_0000_1101;
#0 push_north <=1;
#0 push_south <=1;
#0 push_east <=1;
#0 push_west <=1;
#0 push_local <=1;
#0 north_in <= 32'b0100_0000_1100_0000_0000_0000_0000_0101;
#0 east_in <= 32'b0100_1100_0000_0000_0000_0000_0001_0101;
#0 west_in <= 32'b0100_0000_0011_0000_0000_0000_0001_1101;
#0 local_in <= 32'b0100_0011_0000_0000_0000_0000_0010_0101;
//body
#20 south_in <= 32'b1000_1000_1000_1000_1000_1000_0000_1110;
#0 north_in <= 32'b1000_1000_1000_1000_1000_1000_0000_0110;
#0 east_in <= 32'b1000_1000_1000_1000_1000_1000_0001_0110;
#0 west_in <= 32'b1000_1000_1000_1000_1000_1000_0001_1110;
#0 local_in <= 32'b1000_1000_1000_1000_1000_1000_0010_0110;

#20 south_in <= 32'b1000_1000_1000_1000_1000_1000_0000_1111;
#0 north_in <= 32'b1000_1000_1000_1000_1000_1000_0000_0111;
#0 east_in <= 32'b1000_1000_1000_1000_1000_1000_0001_0111;
#0 west_in <= 32'b1000_1000_1000_1000_1000_1000_0001_1111;
#0 local_in <= 32'b1000_1000_1000_1000_1000_1000_0010_0111;
//tail
#20 south_in <= 32'b1100_0000_0011_0000_0000_0000_0001_0000;
#0 north_in <= 32'b1100_0000_0011_0000_0000_0000_0001_1000;
#0 east_in <= 32'b1100_0000_0011_0000_0000_0000_0001_1000;
#0 west_in <= 32'b1100_0000_0011_0000_0000_0000_0010_0000;
#0 local_in <= 32'b1100_0000_0011_0000_0000_0000_0010_1000;


#20 south_in <= 32'b1000_0000_0011_0000_0000_0000_0001_1000;
#0 push_north <=0;
#0 push_south <=1;
#0 push_east <=0;
#0 push_west <=0;
#0 push_local <=0;
#20 south_in <= 32'b1000_0000_0011_0000_0000_0000_0001_1111;
#20 south_in <= 32'b1000_0000_0011_0000_0000_0000_1111_1111;
//east input-----------------

#20 east_in <= 32'b0;

//west input------------------

#20 west_in <= 32'b0;

#20 local_in <= 32'b0;

#1000 local_in <= 32'b0;
end



endmodule






