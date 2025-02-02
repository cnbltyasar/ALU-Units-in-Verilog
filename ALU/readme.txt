README for ALU_single_cycle and Testbench
Overview
This project contains a single-cycle Arithmetic Logic Unit (ALU) module (ALU_single_cycle) and a corresponding testbench (tb_ALU_single_cycle) for simulation and verification. The ALU performs arithmetic and logical operations based on control signals provided to it. The testbench reads test vectors from an external file, applies them to the ALU, and checks the output against expected results.

Modules Description
1. ALU_single_cycle
Description:
Implements a single-cycle ALU capable of performing various operations (e.g., arithmetic or logical) on two 32-bit inputs. The operation performed is selected based on the alu_cmd and zero_cmd inputs.

Inputs:

rs1_data_i (32-bit): First data operand.
rs2_data_i (32-bit): Second data operand.
alu_cmd (7-bit): Command signal that specifies the ALU operation.
zero_cmd (3-bit): Additional control input, potentially used for zero checking or special operations.
Outputs:

rd_data_o (32-bit): Result of the ALU operation.
zero_o (1-bit): Zero flag output (indicates if the result is zero or meets a specified condition).
2. tb_ALU_single_cycle (Testbench)
Description:
Provides a simulation environment to test the ALU_single_cycle module. It reads test vectors from a file, applies the input values to the ALU, waits for a specified delay to allow the operation to complete, and then compares the ALU output to the expected result.

Key Features:

File I/O: Reads test cases from an external text file (single_cycle_test.txt). Each line in the file contains a set of test inputs and an expected output.

Test Vector Format:
Each line in the file should follow the format:

php-template
Kopyala
<rs1_data>,<rs2_data>,<alu_cmd>,<zero_cmd>,<expected_result>
rs1_data and rs2_data: Provided in hexadecimal format.
alu_cmd and zero_cmd: Provided in decimal format.
expected_result: Provided in hexadecimal format.
Example line:

r
Kopyala
0000000A,00000005,2,0,0000000F
Simulation Behavior:
For each test case:

Inputs are applied.
A delay of #10 time units is inserted to allow the ALU operation to settle.
The ALU output (rd_data_o) is compared against the expected result.
A message is displayed indicating whether the test passed or failed.
An error counter tracks the number of mismatches.
How to Run the Simulation
Prepare the Environment:

Ensure that both ALU_single_cycle.v and tb_ALU_single_cycle.v are located in your project directory.
Verify that the test vectors file (single_cycle_test.txt) is available at the path specified in the testbench:
arduino
Kopyala
"C:/Users/canbo/Work Items/TEKNOFEST/fpu/fpu.srcs/sim_1/new/single_cycle_test.txt"
Modify the path in the testbench if your file is located elsewhere.
Compile the Project:

Use your preferred Verilog simulator (e.g., ModelSim, Vivado Simulator, or any other compatible tool).
Compile the design files including the ALU module and its testbench.
Run the Simulation:

Start the simulation and let it run until completion.
Monitor the console output:
PASSED Messages: Confirm that the ALU output matches the expected results.
ERROR Messages: Indicate mismatches between the actual and expected outputs. Each error is logged with detailed input and output information.
At the end of the simulation, the total number of errors will be reported.
Debugging:

If errors occur, review the printed messages to identify which test vectors failed.
Check both the test vectors file and the ALU design to ensure they conform to the intended operation.
Customization and Adjustments
Test Vectors File Path:
If you need to change the location of your test vectors file, update the file path in the testbench code:

verilog
Kopyala
file = $fopen("C:/your/new/path/single_cycle_test.txt", "r");
Timing Delay:
The delay (#10) in the testbench is used to wait for the ALU to complete its operation. If your ALU design requires a longer delay, adjust this value accordingly.

Input and Output Formats:
Ensure that the format of the data in your test vectors file matches the expected format in the testbench (%h for hexadecimal and %d for decimal).
