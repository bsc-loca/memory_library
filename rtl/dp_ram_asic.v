/* -----------------------------------------------
* File           : dp_ram_asic.sv
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
   input wire [ADDR_WIDTH-1  : 0]  AA,AB,
   input wire [DATA_WIDTH-1  : 0]  DB,
   input wire [DATA_WIDTH-1  : 0]  BWB,  // Bit enable, 1: write bit enable
   input wire CLKA,CEA,  // 1: read
   input wire CLKB,CEB,  // 1: write
   output wire [DATA_WIDTH-1  : 0]  QA
);   

endmodule
