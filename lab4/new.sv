import uvm_pkg::*;
`include "uvm_macros.svh"
`timescale 1ns/10ps
/***********************************************
* Interface
***********************************************/
interface dut_if;

    logic clock;
    logic reset;

    // Signals for FIFO 1
    logic put1;
    logic get1;
    logic [15:0] data_in1;
    logic [15:0] data_out1;
    logic full_bar1;
    logic empty_bar1;

    // Signals for FIFO 2
    logic put2;
    logic get2;
    logic [15:0] data_in2;
    logic [15:0] data_out2;
    logic full_bar2;
    logic empty_bar2;

    // Signals for the Adder
 
    logic [15:0] sum ;
endinterface : dut_if
 
/***********************************************
* top
***********************************************/
module top;
     
    dut_if inf();
    
TopModule dut (
    .clk(inf.clock),
    .reset(inf.reset),
    .put1(inf.put1),
    .put2(inf.put2),
    .get1(inf.get1),
    .get2(inf.get2),
    .data_in1(inf.data_in1),
    .data_in2(inf.data_in2),
    .empty_bar1(inf.empty_bar1),
    .empty_bar2(inf.empty_bar2),
    .full_bar1(inf.full_bar1),
    .full_bar2(inf.full_bar2),
    .data_out1(inf.data_out1),
    .data_out2(inf.data_out2),
    .sum(inf.sum)
  ); 
     

  initial 
	begin
		uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_1_h.data_driver_h", "dut_if", inf);
		uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_2_h.rst_driver_h", "dut_if", inf);
		uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_1_h.monitor_1_h", "dut_if", inf);
        uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_3_h.monitor_2_h", "dut_if", inf);
        run_test("test_1");
	end

	always 
		#5 inf.clock = !inf.clock;
		
	initial 
	begin
		inf.clock = 1'b1;
		inf.reset = 1'b1;
		repeat (3) @(posedge inf.clock);
		#5
		inf.reset = 1'b0;
	end
endmodule : top
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************
* Transaction for FIFO 
***********************************************/
class transaction extends uvm_sequence_item;
    rand logic [15 : 0] data_in1;
    rand logic          put1;
    rand logic          get1;
    rand logic [15 : 0] data_in2;
    rand logic          put2;
    rand logic          get2;
    logic [15:0] sum ;
    function new(string name = "transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(data_in1, UVM_ALL_ON)
        `uvm_field_int(put1, UVM_ALL_ON)
        `uvm_field_int(get1, UVM_ALL_ON)
         `uvm_field_int(data_in2, UVM_ALL_ON)
        `uvm_field_int(put2, UVM_ALL_ON)
        `uvm_field_int(get2, UVM_ALL_ON)
        `uvm_field_int(sum, UVM_ALL_ON)
    `uvm_object_utils_end


endclass
 
/***********************************************
* Transaction for Reset
***********************************************/
class rst_transaction extends uvm_sequence_item;
    logic rst;

    function new(string name = "rst_transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(rst_transaction)
        `uvm_field_int(rst, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

 

/***********************************************
* Sequence for FIFO 1
***********************************************/

//////////////////////////////////////////////////////////////////////////////////////////////


class generator extends uvm_sequence #(transaction);
    `uvm_object_utils(generator)

    transaction tr;

    function new(string name = "generator");
        super.new(name);
    endfunction

    task body();
        for (int i = 0; i < 40; i++) begin
            tr = transaction::type_id::create("tr");
            
            start_item(tr);

            if (i < 20) begin
                if (!tr.randomize() with {tr.put1 == 1'b1; tr.get1 == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
                  if (!tr.randomize() with {tr.put2 == 1'b1; tr.get2 == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
            end
            else begin
                if (!tr.randomize() with {tr.put1 == 1'b0; tr.get1 == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
                  if (!tr.randomize() with {tr.put2 == 1'b1; tr.get2 == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
            end
        `uvm_info("SEQ", $sformatf("data_in1 : %0d  data_in2 : %0d  sum : %0d", tr.data_in1, tr.data_in2, tr.sum), UVM_NONE);
            finish_item(tr);
        end
    endtask
endclass : generator
 ////////////////////////////////////////////////////////////
class FIFO_rst_sequence extends uvm_sequence #(rst_transaction);
    `uvm_object_utils(FIFO_rst_sequence)
    
    rst_transaction tr; 
    
  function new(string name = "rst_seq");
        super.new(name); 
    endfunction

    task body();
        tr = rst_transaction::type_id::create("rst_tx_tr");
        start_item(tr); 
        tr.rst = 1'b1;
        finish_item(tr); 

        tr = rst_transaction::type_id::create("rst_tx_tr");
        start_item(tr); 
        tr.rst = 1'b0;
        finish_item(tr); 
    endtask   
endclass
/***********************************************
* Sequencer for FIFO 1
***********************************************/
class rst_sequencer extends uvm_sequencer #(rst_transaction);
	`uvm_component_utils(rst_sequencer)
  
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
endclass : rst_sequencer

class data_sequencer extends uvm_sequencer #(transaction);
    `uvm_component_utils(data_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass : data_sequencer
 

/***********************************************
* Virtual Sequence
***********************************************/
class top_vseq_base extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(top_vseq_base)
    
    rst_sequencer rst_sqr_h;
    data_sequencer data_sqr_h;
    
    function new(string name = "top_vseq_base");
        super.new(name);
    endfunction 
endclass

class vseq_rst_data extends top_vseq_base;
    `uvm_object_utils(vseq_rst_data)
  
    generator fifo_data_seq_h;
    FIFO_rst_sequence fifo_rst_seq_h;

    function new(string name = "vseq_rst_data");
        super.new(name); 
    endfunction

    task body();
        fifo_data_seq_h = generator::type_id::create("fifo_data_seq_h");   
        fifo_rst_seq_h  = FIFO_rst_sequence::type_id::create("fifo_rst_seq_h");    

      fork
        fifo_rst_seq_h.start(rst_sqr_h);  
        fifo_data_seq_h.start(data_sqr_h); 
      join
    endtask
endclass : vseq_rst_data 

  
/***********************************************
* Driver 
***********************************************/
class data_driver extends uvm_driver #(transaction);
    `uvm_component_utils(data_driver)

   virtual dut_if driver2dut; 
    transaction tr; 
    
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", driver2dut))
            `uvm_info("Data Driver", "uvm_config_db::get failed!", UVM_HIGH)
    endfunction
    
    
      task reset_check();
        forever begin
            @(posedge driver2dut.clock);

            if (driver2dut.reset) begin
                driver2dut.put1 = 1'b0; 
                driver2dut.get1 = 1'b0;
                 driver2dut.put2 = 1'b0; 
                driver2dut.get2 = 1'b0;
            end
        end
    endtask
    
    task send_data();
        forever begin
            @(posedge driver2dut.clock); 
            
            if (!driver2dut.reset) begin 
                seq_item_port.get_next_item(tr); 
                #1
                driver2dut.put1     = tr.put1;
                driver2dut.get1     = tr.get1;
                driver2dut.data_in1 = tr.data_in1;
                 driver2dut.put2     = tr.put2;
                driver2dut.get2     = tr.get2;
                driver2dut.data_in2 = tr.data_in2;
                seq_item_port.item_done();
            end
        end
    endtask
    
    task run_phase(uvm_phase phase);
        fork
            reset_check();
            send_data();
        join 
    endtask 
endclass : data_driver 


class rst_driver extends uvm_driver #(rst_transaction);
    `uvm_component_utils(rst_driver)
    
    rst_transaction tr; 
    virtual dut_if driver2dut;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", driver2dut))
            `uvm_info("RST_DRIVER", "uvm_config_db::get failed!", UVM_HIGH)
    endfunction    
    
    task run_phase(uvm_phase phase);
        seq_item_port.get_next_item(tr); 
        driver2dut.reset = tr.rst; 
        repeat (3) @(negedge driver2dut.clock);
        seq_item_port.item_done();

        seq_item_port.get_next_item(tr); 
        driver2dut.reset = tr.rst; 
        seq_item_port.item_done();
    endtask
endclass : rst_driver

 
/***********************************************
* Monitor for FIFO 1
***********************************************/
class my_monitor_1 extends uvm_monitor;
    `uvm_component_utils(my_monitor_1)
    
    virtual dut_if dut2monitor1;
  	uvm_analysis_port #(transaction) ap;
    transaction tr;

    function new(string name, uvm_component parent);
        super.new(name, parent); 
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("monitor_1_ap", this);
		if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut2monitor1))
            $display("monitor_1 uvm_config_db::get failed");
    endfunction

    task run_phase(uvm_phase phase);
	forever 
		begin
			@(posedge dut2monitor1.clock)	
			tr = transaction::type_id::create("tr");
			if (!dut2monitor1.reset & dut2monitor1.full_bar1 & dut2monitor1.put1)
			begin
                tr.data_in1 = dut2monitor1.data_in1;	
                tr.data_in2 = dut2monitor1.data_in2;	
                ap.write(tr);
			end
		end 
    endtask
endclass : my_monitor_1

class my_monitor_2 extends uvm_monitor;
    `uvm_component_utils(my_monitor_2)
    
    virtual dut_if dut2monitor2;
  	uvm_analysis_port #(transaction) ap;
    transaction tr;

    function new(string name, uvm_component parent);
        super.new(name, parent); 
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("monitor_2_ap", this);
		if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut2monitor2))
            $display("monitor_2 uvm_config_db::get failed");
    endfunction

    task run_phase(uvm_phase phase);
	forever 
		begin
			@(posedge dut2monitor2.clock)	
			tr = transaction::type_id::create("tr");
			if (!dut2monitor2.reset & dut2monitor2.empty_bar1 & dut2monitor2.get1)
			begin
                #1
                tr.data_in1 = dut2monitor2.data_out1;	
                 tr.data_in2 = dut2monitor2.data_out2;	
                ap.write(tr);
			end
		end 
    endtask
endclass : my_monitor_2

/***********************************************
* Agent for FIFO 1
***********************************************/
class my_agent_1 extends uvm_component;
    `uvm_component_utils(my_agent_1)
    
  	uvm_analysis_port #(transaction) ap; 
    data_driver data_driver_h; 
    data_sequencer data_sequencer_h;
    my_monitor_1 monitor_1_h;    
 
    function new(string name, uvm_component parent);
        super.new(name, parent); 
    endfunction

    function void build_phase(uvm_phase phase);
        data_driver_h     = data_driver::type_id::create("data_driver_h", this); 
        data_sequencer_h  = data_sequencer::type_id::create("data_sequencer_h", this); 
        monitor_1_h       = my_monitor_1::type_id::create("monitor_1_h", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        data_driver_h.seq_item_port.connect(data_sequencer_h.seq_item_export);
        ap = monitor_1_h.ap; 
    endfunction
endclass : my_agent_1 

class my_agent_2 extends uvm_component;
    `uvm_component_utils(my_agent_2)

    rst_driver rst_driver_h; 
    rst_sequencer rst_sequencer_h;
 
    function new(string name, uvm_component parent);
        super.new(name, parent); 
    endfunction

    function void build_phase(uvm_phase phase);
        rst_driver_h    = rst_driver::type_id::create("rst_driver_h", this);
        rst_sequencer_h = rst_sequencer::type_id::create("rst_sequencer_h", this); 
    endfunction

    function void connect_phase(uvm_phase phase);
        rst_driver_h.seq_item_port.connect(rst_sequencer_h.seq_item_export);
    endfunction 
endclass : my_agent_2
   
class my_agent_3 extends uvm_component;
    `uvm_component_utils(my_agent_3)
    
  	uvm_analysis_port #(transaction) ap; 
    my_monitor_2 monitor_2_h;    
    
    function new(string name, uvm_component parent);
        super.new(name, parent); 
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor_2_h = my_monitor_2::type_id::create("monitor_2_h", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        ap = monitor_2_h.ap; 
    endfunction
endclass : my_agent_3 

/***********************************************
* Scoreboard
***********************************************/
class my_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(my_scoreboard);

  uvm_blocking_get_port #(transaction) exp_port;
  uvm_blocking_get_port #(transaction) act_port;	
	transaction tr_act, tr_exp;
	bit result;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		exp_port = new("exp_port", this);
		act_port = new("act_port", this);		
	endfunction
	
	task run_phase(uvm_phase phase);
		forever
		begin
			exp_port.get(tr_exp);
			act_port.get(tr_act);
			result = tr_exp.compare(tr_act);
			if (result)
				$display("Compare SUCCESSFULLY");
			else
            	`uvm_warning("WARNING", "Compare FAILED")
			$display("The expected data is");
			tr_exp.print();
			$display("The actual data is");
			tr_act.print();	
		end
	endtask		
endclass : my_scoreboard
/***********************************************
* Environment
***********************************************/
class my_environment extends uvm_env;
    `uvm_component_utils(my_environment);
    
    my_agent_1 agent_1_h; 
    my_agent_2 agent_2_h; 
    my_agent_3 agent_3_h; 
    my_scoreboard scoreboard_h; 
  uvm_tlm_analysis_fifo #(transaction) agt_1_scb_fifo;
  uvm_tlm_analysis_fifo #(transaction) agt_2_scb_fifo;
     
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
     	agent_1_h    = my_agent_1::type_id::create("agent_1_h", this);
		agent_2_h    = my_agent_2::type_id::create("agent_2_h", this);
		agent_3_h    = my_agent_3::type_id::create("agent_3_h", this);
		scoreboard_h = my_scoreboard::type_id::create("scoreboard_h", this);
		agt_1_scb_fifo = new("agt_1_scb_fifo", this);
		agt_2_scb_fifo = new("agt_2_scb_fifo", this);    
    endfunction

    function void connect_phase(uvm_phase phase);
		agent_1_h.ap.connect(agt_1_scb_fifo.analysis_export);
		agent_3_h.ap.connect(agt_2_scb_fifo.analysis_export);
		scoreboard_h.exp_port.connect(agt_1_scb_fifo.blocking_get_export);
		scoreboard_h.act_port.connect(agt_2_scb_fifo.blocking_get_export);
	endfunction
endclass : my_environment
/***********************************************
* Test
***********************************************/
class top_test_base extends uvm_test;
    `uvm_component_utils(top_test_base)
    
    my_environment env_h;

    function new(string name = "top_test_base", uvm_component parent);   
        super.new(name, parent); 
    endfunction

    function void build_phase(uvm_phase phase);
        env_h = my_environment::type_id::create("env_h", this); 
    endfunction

    task init_vseq(top_vseq_base vseq);
        vseq.data_sqr_h = env_h.agent_1_h.data_sequencer_h;  
        vseq.rst_sqr_h  = env_h.agent_2_h.rst_sequencer_h; 
    endtask
endclass : top_test_base

class test_1 extends top_test_base;
    `uvm_component_utils(test_1)

	vseq_rst_data vseq_h;
  
  function new(string name = "test_1", uvm_component parent);   
        super.new(name, parent); 
    endfunction
    
    function void build_phase(uvm_phase phase);
      	super.build_phase(phase);
        vseq_h = vseq_rst_data::type_id::create("vseq_h"); 
    endfunction 

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        init_vseq(vseq_h);
        vseq_h.start(null);
        phase.drop_objection(this);
    endtask    
endclass : test_1  

