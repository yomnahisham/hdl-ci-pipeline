# HDL CI/CD Pipeline

A GitHub Actions workflow for Hardware Description Language (HDL) projects that provides automated linting, simulation, and waveform visualization. This project integrates with [ts-verilog-simulator](https://github.com/yomnahisham/ts-verilog-simulator) for online waveform viewing.

## Project Structure

```
hdl-ci-pipeline/
├── .github/
│   └── workflows/
│       └── hdl-ci.yml          # GitHub Actions workflow
├── examples/
│   ├── alu/                   # ALU module example
│   │   ├── alu.v             # ALU implementation
│   │   └── alu_tb.v          # ALU testbench
│   ├── counter/              # Counter module example
│   │   ├── counter.v         # Counter implementation
│   │   └── counter_tb.v      # Counter testbench
│   └── cpu/                  # CPU module example
│       ├── alu.v             # ALU for CPU
│       ├── cpu.v             # CPU implementation
│       └── cpu_tb.v          # CPU testbench
├── scripts/
│   └── run-local.sh          # Local testing script
└── README.md
```

## How to Use This Project

### 1. Setup for Your Repository

Copy the workflow file to your repository:

```bash
# Copy the workflow file
cp .github/workflows/hdl-ci.yml /path/to/your/repo/.github/workflows/
```

### 2. Add Your HDL Files

Place your Verilog/SystemVerilog files in your repository following this structure:

```
your-repo/
├── .github/workflows/hdl-ci.yml
├── modules/
│   ├── your_module.v
│   └── your_module_tb.v
└── other_files/
```

### 3. Configure Your Testbenches

Your testbenches must include these elements for the pipeline to work:

```verilog
module your_module_tb;
    // Your testbench code here
    
    initial begin
        // Enable waveform dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, your_module_tb);
        
        // Your test stimulus
        // ...
        
        // End simulation
        $finish;
    end
endmodule
```

### 4. Push to Trigger CI

The workflow automatically runs on:
- Push to main branch
- Pull requests to main branch

## Local Development

### Prerequisites

Install required tools:

```bash
# macOS
brew install icarus-verilog verilator python@3.9 jq

# Ubuntu/Debian
sudo apt-get install iverilog verilator python3-pip jq
pip3 install requests
```

### Running Tests Locally

Use the provided script to test your modules:

```bash
./scripts/run-local.sh
```

This script will:
1. Install dependencies if missing
2. Run tests for all example modules
3. Upload waveforms to ts-verilog-simulator
4. Display waveform URLs

### Manual Testing

Test individual modules:

```bash
# Navigate to module directory
cd examples/counter

# Compile and run
iverilog -o testbench.vvp counter.v counter_tb.v
vvp testbench.vvp
```

## Workflow Details

### What the CI Does

1. **Installs Dependencies**
   - Icarus Verilog (simulation)
   - Verilator (linting)
   - Verible (style checking)
   - Python packages

2. **Runs Linting**
   - Verible checks all `.v` and `.sv` files
   - Enforces coding standards
   - Reports style violations

3. **Executes Simulation**
   - Compiles testbenches with Icarus Verilog
   - Runs simulations
   - Generates waveform files

4. **Uploads Waveforms**
   - Sends VCD files to ts-verilog-simulator
   - Creates shareable waveform URLs

5. **Reports Results**
   - Posts results to PR comments
   - Includes waveform links

### Supported File Types

- `.v` - Verilog files
- `.sv` - SystemVerilog files

### Linting Rules

The pipeline enforces these style rules:
- Explicit storage types for parameters (`parameter integer`)
- Explicit storage types for localparams (`localparam logic [2:0]`)
- Use `always_comb` instead of `always @(*)`
- No trailing spaces
- Files must end with newline
- Timescale directives required

## Example Modules

### Counter Module

Simple 4-bit counter with reset:

```verilog
module counter(
    input wire clk,
    input wire rst_n,
    output reg [3:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 4'b0000;
        else
            count <= count + 1'b1;
    end
endmodule
```

### ALU Module

Arithmetic Logic Unit with multiple operations:

```verilog
module alu #(
    parameter integer WIDTH = 4
)(
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire [2:0] op,
    output reg [WIDTH-1:0] result,
    output reg zero,
    output reg carry
);
    // Implementation details...
endmodule
```

### CPU Module

Simple CPU with state machine:

```verilog
module cpu #(
    parameter integer WIDTH = 4
)(
    input wire clk,
    input wire rst,
    output wire [WIDTH-1:0] result,
    output wire zero,
    output wire carry
);
    // CPU implementation with ALU integration
endmodule
```

## Troubleshooting

### Common Issues

1. **Linting Failures**
   - Check for trailing spaces: `grep -n " $" *.v`
   - Ensure files end with newline
   - Add explicit storage types to parameters

2. **Simulation Failures**
   - Verify testbench includes `$dumpfile` and `$dumpvars`
   - Check for syntax errors in Verilog files
   - Ensure all module dependencies are present

3. **Waveform Upload Failures**
   - Check network connectivity
   - Verify ts-verilog-simulator service is available
   - Ensure VCD file is generated successfully

### Debug Commands

```bash
# Check for trailing spaces
find . -name "*.v" -exec grep -l " $" {} \;

# Verify file endings
for file in *.v; do tail -c 1 "$file" | wc -l; done

# Test compilation
iverilog -o test test.v test_tb.v

# Run simulation
vvp test
```

## Configuration

### Customizing the Workflow

Modify `.github/workflows/hdl-ci.yml` to:

- Change trigger conditions
- Add custom linting rules
- Modify simulation parameters
- Add additional tools

### Environment Variables

Set these in your repository settings:

- `WAVEFORM_UPLOAD_URL` - Custom waveform upload endpoint
- `LINTING_OPTIONS` - Additional Verible options

## License

This project is open source. See LICENSE file for details.
