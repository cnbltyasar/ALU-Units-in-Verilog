#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <math.h>

#define NUM_TEST_CASES 30  // Number of random test cases

// Function to convert int32_t to uint32_t representation of float
uint32_t int32_to_float_bits(int32_t i) {
    float f = (float)i;
    uint32_t result;
    memcpy(&result, &f, sizeof(result));
    return result;
}

// Function to convert uint32_t to uint32_t representation of float
uint32_t uint32_to_float_bits(uint32_t u) {
    float f = (float)u;
    uint32_t result;
    memcpy(&result, &f, sizeof(result));
    return result;
}

// Function to convert uint32_t bits to float
float uint32_bits_to_float(uint32_t u) {
    float f;
    memcpy(&f, &u, sizeof(f));
    return f;
}


// Function to classify the floating-point number
uint16_t fclass(float f) {
    uint32_t bits;
    uint16_t result = 0;
    memcpy(&bits, &f, sizeof(bits));

    uint8_t sign = (bits >> 31) & 0x1;
    uint8_t exp = (bits >> 23) & 0xFF;
    uint32_t frac = bits & 0x7FFFFF;

    if (exp == 0xFF) {
        if (frac == 0) {
            result = sign ? 0b0000000001 : 0b0010000000;  // Infinity
        } else if (frac & 0x00400000) {
            result = 0b1000000000;  // Quiet NaN
        } else {
            result = 0b0100000000;  // Signaling NaN
        }
    } else if (exp == 0x00) {
        if (frac == 0) {
            result = sign ? 0b0000001000 : 0b0000010000;  // Zero
        } else {
            result = sign ? 0b0000000100 : 0b0000100000;  // Subnormal
        }
    } else {
        result = sign ? 0b0000000010 : 0b0001000000;  // Normal
    }

    return result;
}


// Function to perform operations based on op_code and return the expected result
uint32_t perform_operation(uint32_t op1, uint32_t op2, uint8_t op_code) {
    float f1 = *((float*)&op1);
    float f2 = *((float*)&op2);

    switch (op_code) {
        case 1:  // Addition
            return op1 + op2;
        case 2:  // Signed comparison
            return (int32_t)op1 > (int32_t)op2 ? 1 : 0;
        case 3:  // Unsigned comparison
            return (op1 > op2) ? 1 : 0;
        case 4:  // XOR
            return op1 ^ op2;
        case 5:  // OR
            return op1 | op2;
        case 6:  // AND
            return op1 & op2;
        case 27:  // FCVT.W.S
            return (int32_t)f1;
        case 28:  // FCVT.WU.S
            return (uint32_t)f1;
        case 29:  // FCLASS.S
            return fclass(f1);  // This might need a specific implementation
        case 30:  // FCVT.S.W
            return  int32_to_float_bits((int32_t)op1);
        case 31:  // FCVT.S.WU
            return  uint32_to_float_bits(op1);
        case 32:  // FMAX
            return (f1 < f2) ? op2 : op1;
        case 33:  // FMIN
            return (f1 < f2) ? op1 : op2;
        case 34:  // FEQ.S
            return (f1 == f2) ? 1 : 0;
        case 35:  // FLT.S
            return (f1 < f2) ? 1 : 0;
        case 36:  // FLE.S
            return (f1 <= f2) ? 1 : 0;
        default:
            return 0x00000000;  // Default result for invalid op_code
            break;
    }
}

// Function to generate test cases file
void generate_test_cases(const char *filename) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }

    // Seed the random number generator
    srand((unsigned int)time(NULL));
    fprintf(file, "rs1_data_i,rs2_data_i,alu_cmd,zero_cmd,expected_result\n");

    // Generate test cases for each command
    for (int op_code = 1; op_code <= 6; op_code++) {
        for (int i = 0; i < NUM_TEST_CASES; i++) {
            uint32_t op1 = rand();
            uint32_t op2 = rand();
            uint32_t result = perform_operation(op1, op2, op_code);

            fprintf(file, "%08X,%08X,%d,%02X,%08X\n", op1, op2, op_code, 0x00, result);
        }
    }

    // Generate test cases for each command for float operations
    for (int op_code = 27; op_code <= 36; op_code++) {
        for (int i = 0; i < NUM_TEST_CASES; i++) {
            float op1 = ((float)rand() / RAND_MAX) * 200.0f - 100.0f;  // Random float in range [-100, 100]
            float op2 = ((float)rand() / RAND_MAX) * 200.0f - 100.0f;  // Random float in range [-100, 100]
            uint32_t result = perform_operation(*((uint32_t*)&op1), *((uint32_t*)&op2), op_code);

            // Print op1, op2, op_code, and result
            fprintf(file, "%08X,%08X,%d,%02X,%08X\n",
                    *((uint32_t*)&op1), *((uint32_t*)&op2), op_code, 0x00, result);
        }
    }

    fclose(file);
    printf("Test cases file '%s' has been generated.\n", filename);
}

int main() {
    // Call the function to generate the test cases file
    generate_test_cases("test_cases.txt");
    return 0;
}
