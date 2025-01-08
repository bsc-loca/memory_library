/* -----------------------------------------------
* File           : dp_ram_asic.v
* Organization   : Barcelona Supercomputing Center
* Author(s)      : Junaid Ahmed; Xabier Abancens
* Email(s)       : {author}@bsc.es
* References     : Openpiton 
* https://github.com/PrincetonUniversity/openpiton 
* -----------------------------------------------
* Revision History
*  Revision   | Author          |  Description
*  0.1        | Junaid Ahmed;   | 
*             | Xabier Abancens | 
* -----------------------------------------------
*/

// Dual port RAM module that instantiates physical memories
// It supports the memories that have been generated for ongoing projects. 
// If a new memory is generated, please add its macro 

module dp_ram_asic #(
    parameter ADDR_WIDTH=1, 
    parameter DATA_WIDTH=1
) (
   input wire rst_n,
   input wire [ADDR_WIDTH-1  : 0]  AA,AB,
   input wire [DATA_WIDTH-1  : 0]  DB,
   input wire [DATA_WIDTH-1  : 0]  BWB,  // Bit enable, 1: write bit enable
   input wire CLKA,CEA,  // 1: read
   input wire CLKB,CEB,  // 1: write
   output wire [DATA_WIDTH-1  : 0]  QA
);   

// ----------------------------------------------------------------------------
// write_bypass on read/write collisions to the same address
// ----------------------------------------------------------------------------
wire                  read_write_collision;
reg                   read_write_collision_r;
reg  [DATA_WIDTH-1:0] mux_data_in_r;
reg  [DATA_WIDTH-1:0] mux_data_mask_in_r;
wire [DATA_WIDTH-1:0] tmp_QA;

// write_bypass on read/write collisions to the same address
//NOTE: keep bypassed data constant until a new read operation arrives!
always @(posedge CLKA) begin
    if(!rst_n) begin
        read_write_collision_r <= 1'b0;
    end else begin
        if (read_write_collision) begin
            read_write_collision_r <= 1'b1;
            mux_data_in_r          <= DB;
            mux_data_mask_in_r     <= BWB;
        end else if (CEA) begin
            read_write_collision_r <= 1'b0;
        end
    end
end

// Assertions
logic rw_collision_d;
always @(posedge CLKA)
    rw_collision_d <= CEA && CEB && (AA == AB);

property check_signal_no_unknown;
  @(posedge CLKA) disable iff (rw_collision_d != 1)
  ($isunknown(QA));
endproperty

assert property (check_signal_no_unknown) else $info("NO WORRIES SVA ERROR below is expected: output data: 0x%X time: %0t", QA, $time);


// detect a read/write collision
// assign read_write_collision = (mux_rd_en && mux_wr_en && (mux_rd_addr == mux_wr_addr));
assign read_write_collision = (CEA && CEB && (AA == AB));

// generate the correct output in case of collision
//NOTE: assumes that tmp_QA (read data) is correct for the bits that are not being written
// assign data_out = read_write_collision_r ? ((QA & ~mux_data_mask_in_r) | (mux_data_in_r & mux_data_mask_in_r)) : QA;
assign QA = read_write_collision_r ? ((tmp_QA & ~mux_data_mask_in_r) | (mux_data_in_r & mux_data_mask_in_r)) : tmp_QA;
// ----------------------------------------------------------------------------

endmodule
