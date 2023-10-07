
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
    
TopModule top_dut (
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
     

    // Create a clock generator
    initial begin
        inf.clock = 1'b1;
        repeat (3) @(posedge inf.clock);
        #5
        inf.reset = 1'b0;
    end

    // Create a clock toggle
    always #5 inf.clock = !inf.clock;

    // Run the UVM test with the modified DUTs
    initial begin
        uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_1_h.data_driver_h", "dut_if", inf);
        uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_2_h.rst_driver_h", "dut_if", inf);
        uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_1_h.monitor_1_h", "dut_if", inf);
        uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top.env_h.agent_3_h.monitor_2_h", "dut_if", inf);
        run_test("test_1");
    end
endmodule : top
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************
* Transaction for FIFO 1
***********************************************/
class fifo1_data_transaction extends uvm_sequence_item;
    rand logic [15 : 0] data_in1;
    rand logic          put1;
    rand logic          get1;

    function new(string name = "fifo1_data_transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(fifo1_data_transaction)
        `uvm_field_int(data_in1, UVM_ALL_ON)
        `uvm_field_int(put1, UVM_ALL_ON)
        `uvm_field_int(get1, UVM_ALL_ON)
    `uvm_object_utils_end
endclass

/***********************************************
* Transaction for FIFO 2
***********************************************/
class fifo2_data_transaction extends uvm_sequence_item;
    rand logic [15 : 0] data_in2;
    rand logic          put2;
    rand logic          get2;

    function new(string name = "fifo2_data_transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(fifo2_data_transaction)
        `uvm_field_int(data_in2, UVM_ALL_ON)
        `uvm_field_int(put2, UVM_ALL_ON)
        `uvm_field_int(get2, UVM_ALL_ON)
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

/*************************************************
***Transaction for adder
*******************************************************/
class AdderTransaction extends uvm_sequence_item;
    logic [15:0] sum;

    function new(string name = "AdderTransaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(AdderTransaction)
        `uvm_field_int(sum, UVM_ALL_ON)
    `uvm_object_utils_end
endclass



/***********************************************
* Sequence for FIFO 1
***********************************************/

//////////////////////////////////////////////////////////////////////////////////////////////


class FIFO_test_1_sequence extends uvm_sequence #(fifo1_data_transaction);
    `uvm_object_utils(FIFO_test_1_sequence)

    fifo1_data_transaction tr;

    function new(string name = "fifo_test_1_seq");
        super.new(name);
    endfunction

    task body();
        for (int i = 0; i < 40; i++) begin
            tr = fifo1_data_transaction::type_id::create("tx_data_tr");
            start_item(tr);

            if (i < 20) begin
                if (!tr.randomize() with {tr.put1 == 1'b1; tr.get1 == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
            end
            else begin
                if (!tr.randomize() with {tr.put1 == 1'b0; tr.get1 == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
            end

            finish_item(tr);
        end
    endtask
endclass : FIFO_test_1_sequence

/***********************************************
* Sequence for FIFO 2
***********************************************/
class FIFO_test_2_sequence extends uvm_sequence #(fifo2_data_transaction);
    `uvm_object_utils(FIFO_test_2_sequence)

    fifo2_data_transaction tr;

    function new(string name = "fifo_test_2_seq");
        super.new(name);
    endfunction

    task body();
        for (int i = 0; i < 40; i++) begin
            tr = fifo2_data_transaction::type_id::create("tx_data_tr");
            start_item(tr);

            if (i < 4) begin
                if (!tr.randomize() with {tr.put2 == 1'b1; tr.get2 == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
            end
            else begin
                if (!tr.randomize() with {tr.put2 == 1'b1; tr.get2 == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for transaction")
                end
            end

            finish_item(tr);
        end
    endtask
endclass : FIFO_test_2_sequence

/***********************************************
* Sequence for Adder Test
***********************************************/
 
class Adder_test_sequence extends uvm_sequence#(AdderTransaction);
    `uvm_object_utils(Adder_test_sequence)

    function new(string name = "Adder_test_sequence");
        super.new(name);
    endfunction

    virtual task body();
        AdderTransaction adder_txn;

        // Create and randomize FIFO 1 transaction
        fifo1_data_transaction fifo1_txn;
        fifo1_txn = fifo1_data_transaction::type_id::create("fifo1_txn");
        fifo1_txn.randomize();

        // Create and randomize FIFO 2 transaction
        fifo2_data_transaction fifo2_txn;
        fifo2_txn = fifo2_data_transaction::type_id::create("fifo2_txn");
        fifo2_txn.randomize();

        // Set FIFO outputs as inputs to the Adder transaction
        adder_txn = AdderTransaction::type_id::create("adder_txn");

        // Start the Adder transaction
        start_item(adder_txn);

        // Wait for a few clock cycles to allow the Adder to compute the result
        #20;

        // Finish the Adder transaction
        finish_item(adder_txn);

        // Calculate the expected sum based on FIFO data
        adder_txn.expected_sum = fifo1_txn.data_out1 + fifo2_txn.data_out2;

        // Check if the result matches the expected sum
        if (adder_txn.expected_sum !== adder_txn.sum) begin
            `uvm_error("AdderTestSequence", $sformatf("Adder result mismatch: Expected %h, Actual %h", adder_txn.expected_sum, adder_txn.sum))
        end

        // Cleanup
        fifo1_txn.free();
        fifo2_txn.free();
    endtask
endclass : Adder_test_sequence

/***********************************************
* Sequencer for FIFO 1
***********************************************/
class fifo1_sequencer extends uvm_sequencer #(fifo1_data_transaction);
    `uvm_component_utils(fifo1_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass : fifo1_sequencer

/***********************************************
* Sequencer for FIFO 2
***********************************************/
class fifo2_sequencer extends uvm_sequencer #(fifo2_data_transaction);
    `uvm_component_utils(fifo2_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass : fifo2_sequencer

/***********************************************
* Sequencer for Adder
***********************************************/
class adder_sequencer extends uvm_sequencer #(AdderTransaction);
    `uvm_component_utils(adder_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass : adder_sequencer

/***********************************************
* Virtual Sequence
***********************************************/
class top_vseq_base extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(top_vseq_base)

    rst_sequencer rst_sqr_h;
    fifo1_sequencer fifo1_sqr_h;
    fifo2_sequencer fifo2_sqr_h;
    adder_sequencer adder_sqr_h;

    function new(string name = "top_vseq_base");
        super.new(name);
    endfunction
endclass

/***********************************************
* Virtual Sequence for Test Scenario
***********************************************/
class vseq_test_scenario extends top_vseq_base;
    `uvm_object_utils(vseq_test_scenario)

    FIFO_test_1_sequence fifo1_data_seq_h;
    FIFO_test_2_sequence fifo2_data_seq_h;
    Adder_test_sequence adder_test_seq_h;

    function new(string name = "vseq_test_scenario");
        super.new(name);
    endfunction

    task body();
        fifo1_data_seq_h = FIFO_test_1_sequence::type_id::create("fifo1_data_seq_h");
        fifo2_data_seq_h = FIFO_test_2_sequence::type_id::create("fifo2_data_seq_h");
        adder_test_seq_h = Adder_test_sequence::type_id::create("adder_test_seq_h");

        // Start sequences for FIFO 1, FIFO 2, and Adder
        fork
            fifo1_data_seq_h.start(fifo1_sqr_h);
            fifo2_data_seq_h.start(fifo2_sqr_h);
            adder_test_seq_h.start(adder_sqr_h);
        join
    endtask
endclass : vseq_test_scenario
///////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************
* Driver for FIFO 1
***********************************************/
class fifo1_driver extends uvm_driver #(fifo1_data_transaction);
    `uvm_component_utils(fifo1_driver)

    fifo1_data_transaction tr;
    virtual dut_if driver2dut;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", driver2dut))
            `uvm_info("FIFO1_DRIVER", "uvm_config_db::get failed!", UVM_HIGH)
    endfunction

    task send_data();
        forever begin
            @(posedge driver2dut.clock);

            if (!driver2dut.reset) begin
                seq_item_port.get_next_item(tr);
                #1
                driver2dut.put1     = tr.put1;
                driver2dut.get1     = tr.get1;
                driver2dut.data_in1 = tr.data_in1;
                seq_item_port.item_done();
            end
        end
    endtask

    task run_phase(uvm_phase phase);
        send_data();
    endtask
endclass : fifo1_driver

/***********************************************
* Driver for FIFO 2
***********************************************/
class fifo2_driver extends uvm_driver #(fifo2_data_transaction);
    `uvm_component_utils(fifo2_driver)

    fifo2_data_transaction tr;
    virtual dut_if driver2dut;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", driver2dut))
            `uvm_info("FIFO2_DRIVER", "uvm_config_db::get failed!", UVM_HIGH)
    endfunction

    task send_data();
        forever begin
            @(posedge driver2dut.clock);

            if (!driver2dut.reset) begin
                seq_item_port.get_next_item(tr);
                #1
                driver2dut.put2     = tr.put2;
                driver2dut.get2     = tr.get2;
                driver2dut.data_in2 = tr.data_in2;
                seq_item_port.item_done();
            end
        end
    endtask

    task run_phase(uvm_phase phase);
        send_data();
    endtask
endclass : fifo2_driver

/***********************************************
* Driver for Adder
***********************************************/
class adder_driver extends uvm_driver #(data_transaction);
    `uvm_component_utils(adder_driver)

    data_transaction tr;
    virtual dut_if driver2dut;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", driver2dut))
            `uvm_info("ADDER_DRIVER", "uvm_config_db::get failed!", UVM_HIGH)
    endfunction

    task send_data();
        forever begin
            @(posedge driver2dut.clock);

            if (!driver2dut.reset) begin
                seq_item_port.get_next_item(tr);
                #1
                driver2dut.put1     = tr.put;
                driver2dut.put2     = tr.put;
                driver2dut.get1     = tr.get;
                driver2dut.get2     = tr.get;
                driver2dut.data_in1 = tr.data_in;
                driver2dut.data_in2 = tr.data_in;
                seq_item_port.item_done();
            end
        end
    endtask

    task run_phase(uvm_phase phase);
        send_data();
    endtask
endclass : adder_driver





class adder_driver extends uvm_driver #(AdderTransaction);
    `uvm_component_utils(adder_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            AdderTransaction txn;
            // Wait for a transaction to be available in the sequencer's FIFO
            seq_item_port.get_next_item(txn);

            // Drive the transaction to the DUT (Adder)
            drive_transaction(txn);

            // Send the transaction to the monitor for checking
            seq_item_port.item_done();
        end
    endtask

    task drive_transaction(AdderTransaction txn);
        // Wait for some time for the Adder to compute the result
        #10;

        // Perform any necessary processing or checks on the transaction fields (e.g., boundary checks)

        // Compare the result with the expected sum
        if (txn.sum !== txn.expected_sum) begin
            `uvm_error("AdderDriver", $sformatf("Adder result mismatch: Expected %h, Actual %h", txn.expected_sum, txn.sum))
        end
    endtask
endclass : AdderDriver


/***********************************************
* Monitor for FIFO 1
***********************************************/
class fifo1_monitor extends uvm_monitor;
    `uvm_component_utils(fifo1_monitor)

    virtual dut_if dut2monitor1;
    uvm_analysis_port #(fifo1_data_transaction) ap;
    fifo1_data_transaction tr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("fifo1_monitor_ap", this);
        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut2monitor1))
            `uvm_fatal("FIFO1_MONITOR", "uvm_config_db::get failed");
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge dut2monitor1.clock);
            tr = fifo1_data_transaction::type_id::create("tr");

            if (!dut2monitor1.reset && dut2monitor1.empty_bar && dut2monitor1.get1) begin
                #1;
                tr.data_in1 = dut2monitor1.data_out1;
                ap.write(tr);
            end
        end
    endtask
endclass : fifo1_monitor

/***********************************************
* Monitor for FIFO 2
***********************************************/
class fifo2_monitor extends uvm_monitor;
    `uvm_component_utils(fifo2_monitor)

    virtual dut_if dut2monitor2;
    uvm_analysis_port #(fifo2_data_transaction) ap;
    fifo2_data_transaction tr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("fifo2_monitor_ap", this);
        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut2monitor2))
            `uvm_fatal("FIFO2_MONITOR", "uvm_config_db::get failed");
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge dut2monitor2.clock);
            tr = fifo2_data_transaction::type_id::create("tr");

            if (!dut2monitor2.reset && dut2monitor2.empty_bar && dut2monitor2.get2) begin
                #1;
                tr.data_in2 = dut2monitor2.data_out2;
                ap.write(tr);
            end
        end
    endtask
endclass : fifo2_monitor

/***********************************************
* Monitor for Adder
***********************************************/
class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)

    virtual dut_if dut2monitor3;
    uvm_analysis_port #(data_transaction) ap;
    data_transaction tr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("adder_monitor_ap", this);
        if (!uvm_config_db #(virtual dut_if)::get(this, "", "dut_if", dut2monitor3))
            `uvm_fatal("ADDER_MONITOR", "uvm_config_db::get failed");
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge dut2monitor3.clock);
            tr = data_transaction::type_id::create("tr");

            if (!dut2monitor3.reset && dut2monitor3.full_bar && dut2monitor3.put1 && dut2monitor3.put2) begin
                #1;
                tr.data_in = dut2monitor3.data_out1 + dut2monitor3.data_out2;
                ap.write(tr);
            end
        end
    endtask
endclass : adder_monitor
/***********************************************
* Agent for FIFO 1
***********************************************/
class fifo1_agent extends uvm_agent;
    `uvm_component_utils(fifo1_agent)

    uvm_analysis_port #(fifo1_data_transaction) ap;
    fifo1_driver fifo1_driver_h;
    fifo1_sequencer fifo1_sequencer_h;
    fifo1_monitor fifo1_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        fifo1_driver_h = fifo1_driver::type_id::create("fifo1_driver_h", this);
        fifo1_sequencer_h = fifo1_sequencer::type_id::create("fifo1_sequencer_h", this);
        fifo1_monitor_h = fifo1_monitor::type_id::create("fifo1_monitor_h", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        fifo1_driver_h.seq_item_port.connect(fifo1_sequencer_h.seq_item_export);
        ap = fifo1_monitor_h.ap;
    endfunction
endclass : fifo1_agent

/***********************************************
* Agent for FIFO 2
***********************************************/
class fifo2_agent extends uvm_agent;
    `uvm_component_utils(fifo2_agent)

    uvm_analysis_port #(fifo2_data_transaction) ap;
    fifo2_driver fifo2_driver_h;
    fifo2_sequencer fifo2_sequencer_h;
    fifo2_monitor fifo2_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        fifo2_driver_h = fifo2_driver::type_id::create("fifo2_driver_h", this);
        fifo2_sequencer_h = fifo2_sequencer::type_id::create("fifo2_sequencer_h", this);
        fifo2_monitor_h = fifo2_monitor::type_id::create("fifo2_monitor_h", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        fifo2_driver_h.seq_item_port.connect(fifo2_sequencer_h.seq_item_export);
        ap = fifo2_monitor_h.ap;
    endfunction
endclass : fifo2_agent

/***********************************************
* Agent for Adder
***********************************************/
class adder_agent extends uvm_agent;
    `uvm_component_utils(adder_agent)

    uvm_analysis_port #(data_transaction) ap;
    adder_driver adder_driver_h;
    adder_sequencer adder_sequencer_h;
    adder_monitor adder_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        adder_driver_h = adder_driver::type_id::create("adder_driver_h", this);
        adder_sequencer_h = adder_sequencer::type_id::create("adder_sequencer_h", this);
        adder_monitor_h = adder_monitor::type_id::create("adder_monitor_h", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        adder_driver_h.seq_item_port.connect(adder_sequencer_h.seq_item_export);
        ap = adder_monitor_h.ap;
    endfunction
endclass : adder_agent
/***********************************************
* Scoreboard
***********************************************/
class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_blocking_get_port #(fifo1_data_transaction) fifo1_exp_port;
    uvm_blocking_get_port #(fifo1_data_transaction) fifo1_act_port;
    uvm_blocking_get_port #(fifo2_data_transaction) fifo2_exp_port;
    uvm_blocking_get_port #(fifo2_data_transaction) fifo2_act_port;
    uvm_blocking_get_port #(data_transaction) adder_exp_port;
    uvm_blocking_get_port #(data_transaction) adder_act_port;

    fifo1_data_transaction fifo1_tr_exp, fifo1_tr_act;
    fifo2_data_transaction fifo2_tr_exp, fifo2_tr_act;
    data_transaction adder_tr_exp, adder_tr_act;

    bit fifo1_result, fifo2_result, adder_result;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo1_exp_port = new("fifo1_exp_port", this);
        fifo1_act_port = new("fifo1_act_port", this);
        fifo2_exp_port = new("fifo2_exp_port", this);
        fifo2_act_port = new("fifo2_act_port", this);
        adder_exp_port = new("adder_exp_port", this);
        adder_act_port = new("adder_act_port", this);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            fifo1_exp_port.get(fifo1_tr_exp);
            fifo1_act_port.get(fifo1_tr_act);
            fifo1_result = fifo1_tr_exp.compare(fifo1_tr_act);

            fifo2_exp_port.get(fifo2_tr_exp);
            fifo2_act_port.get(fifo2_tr_act);
            fifo2_result = fifo2_tr_exp.compare(fifo2_tr_act);

            adder_exp_port.get(adder_tr_exp);
            adder_act_port.get(adder_tr_act);
            adder_result = adder_tr_exp.compare(adder_tr_act);

            if (fifo1_result)
                `uvm_info("FIFO1 Compare", "SUCCESSFULLY", UVM_LOW)
            else
                `uvm_warning("FIFO1 Compare", "FAILED")

            if (fifo2_result)
                `uvm_info("FIFO2 Compare", "SUCCESSFULLY", UVM_LOW)
            else
                `uvm_warning("FIFO2 Compare", "FAILED")

            if (adder_result)
                `uvm_info("Adder Compare", "SUCCESSFULLY", UVM_LOW)
            else
                `uvm_warning("Adder Compare", "FAILED")
        end
    endtask
endclass : fifo_scoreboard
/***********************************************
* Environment
***********************************************/
class fifo_environment extends uvm_env;
    `uvm_component_utils(fifo_environment)

    fifo1_agent agent_1_h;
    fifo2_agent agent_2_h;
    adder_agent agent_3_h;
    fifo_scoreboard scoreboard_h;
    uvm_tlm_analysis_fifo #(fifo1_data_transaction) fifo1_scb_fifo;
    uvm_tlm_analysis_fifo #(fifo2_data_transaction) fifo2_scb_fifo;
    uvm_tlm_analysis_fifo #(data_transaction) adder_scb_fifo;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        agent_1_h = fifo1_agent::type_id::create("agent_1_h", this);
        agent_2_h = fifo2_agent::type_id::create("agent_2_h", this);
        agent_3_h = adder_agent::type_id::create("agent_3_h", this);
        scoreboard_h = fifo_scoreboard::type_id::create("scoreboard_h", this);
        fifo1_scb_fifo = new("fifo1_scb_fifo", this);
        fifo2_scb_fifo = new("fifo2_scb_fifo", this);
        adder_scb_fifo = new("adder_scb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agent_1_h.ap.connect(fifo1_scb_fifo.analysis_export);
        agent_2_h.ap.connect(fifo2_scb_fifo.analysis_export);
        agent_3_h.ap.connect(adder_scb_fifo.analysis_export);
        scoreboard_h.fifo1_exp_port.connect(fifo1_scb_fifo.blocking_get_export);
        scoreboard_h.fifo1_act_port.connect(fifo1_scb_fifo.blocking_get_export);
        scoreboard_h.fifo2_exp_port.connect(fifo2_scb_fifo.blocking_get_export);
        scoreboard_h.fifo2_act_port.connect(fifo2_scb_fifo.blocking_get_export);
        scoreboard_h.adder_exp_port.connect(adder_scb_fifo.blocking_get_export);
        scoreboard_h.adder_act_port.connect(adder_scb_fifo.blocking_get_export);
    endfunction
endclass : fifo_environment

/***********************************************
* Test
***********************************************/
class fifo_test_base extends uvm_test;
    `uvm_component_utils(fifo_test_base)

    fifo_environment env_h;
    fifo_agent agent_1_h;
    fifo_agent agent_2_h;
    adder_agent agent_3_h;
    fifo_scoreboard scoreboard_h;
    fifo1_data_transaction fifo1_tr_exp, fifo1_tr_act;
    fifo2_data_transaction fifo2_tr_exp, fifo2_tr_act;
    data_transaction adder_tr_exp, adder_tr_act;

    function new(string name = "fifo_test_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env_h = fifo_environment::type_id::create("env_h", this);
        agent_1_h = fifo1_agent::type_id::create("agent_1_h", this);
        agent_2_h = fifo2_agent::type_id::create("agent_2_h", this);
        agent_3_h = adder_agent::type_id::create("agent_3_h", this);
        scoreboard_h = fifo_scoreboard::type_id::create("scoreboard_h", this);

        // Create expected transactions for FIFO 1, FIFO 2, and Adder
        fifo1_tr_exp = fifo1_data_transaction::type_id::create("fifo1_tr_exp");
        fifo2_tr_exp = fifo2_data_transaction::type_id::create("fifo2_tr_exp");
        adder_tr_exp = data_transaction::type_id::create("adder_tr_exp");

        // Connect the expected transactions to the scoreboard
        scoreboard_h.fifo1_exp_port.connect(fifo1_tr_exp);
        scoreboard_h.fifo2_exp_port.connect(fifo2_tr_exp);
        scoreboard_h.adder_exp_port.connect(adder_tr_exp);

        // Set up the analysis FIFOs for the scoreboard
        env_h.fifo1_scb_fifo = new("fifo1_scb_fifo", this);
        env_h.fifo2_scb_fifo = new("fifo2_scb_fifo", this);
        env_h.adder_scb_fifo = new("adder_scb_fifo", this);

        // Connect the analysis FIFOs to the scoreboard
        agent_1_h.ap.connect(env_h.fifo1_scb_fifo.analysis_export);
        agent_2_h.ap.connect(env_h.fifo2_scb_fifo.analysis_export);
        agent_3_h.ap.connect(env_h.adder_scb_fifo.analysis_export);
        scoreboard_h.fifo1_act_port.connect(env_h.fifo1_scb_fifo.blocking_get_export);
        scoreboard_h.fifo2_act_port.connect(env_h.fifo2_scb_fifo.blocking_get_export);
        scoreboard_h.adder_act_port.connect(env_h.adder_scb_fifo.blocking_get_export);
    endfunction

    task init_vseq(top_vseq_base vseq);
        vseq.data_sqr_h = agent_1_h.data_sequencer_h;
        vseq.rst_sqr_h = agent_2_h.rst_sequencer_h;
    endtask
endclass : fifo_test_base

class fifo_test_1 extends fifo_test_base;
    `uvm_component_utils(fifo_test_1)

    vseq_rst_data vseq_h;

    function new(string name = "fifo_test_1", uvm_component parent);
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
endclass : fifo_test_1

