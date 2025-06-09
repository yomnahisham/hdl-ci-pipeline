# HDL CI/CD Pipeline

A GitHub Actions workflow template for Hardware Description Language (HDL) projects that integrates with [ts-verilog-simulator](https://github.com/yomnahisham/ts-verilog-simulator) for waveform visualization.

## Features

- **Linting**: Verible linting for Verilog/SystemVerilog code
- **Simulation**: Run testbenches using Icarus Verilog
- **Waveform Visualization**: Automatic upload and visualization of waveforms using ts-verilog-simulator
- **PR Integration**: Post simulation results and waveform links to PRs

## Quick Start

1. Copy the `.github/workflows/hdl-ci.yml` file to your repository
2. Configure the workflow in your repository settings
3. Add your HDL files and testbenches
4. Push changes to trigger the pipeline

## Example Usage

```yaml
# .github/workflows/hdl-ci.yml
name: HDL CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y iverilog verilator python3-pip jq
          pip3 install requests
      - name: Run linting
        run: |
          # Install Verible
          wget https://github.com/chipsalliance/verible/releases/download/v0.0-3425-g7e064c97/verible-v0.0-3425-g7e064c97-Ubuntu-20.04.tar.gz
          tar xzf verible-v0.0-3425-g7e064c97-Ubuntu-20.04.tar.gz
          sudo cp verible-v0.0-3425-g7e064c97/bin/* /usr/local/bin/
          
          # Run Verible lint
          find . -name "*.v" -o -name "*.sv" | xargs verible-verilog-lint
```

## Directory Structure

```
.
├── .github/
│   └── workflows/
│       └── hdl-ci.yml          # Main workflow file
├── examples/
│   ├── alu/                   # ALU module example
│   ├── counter/              # Counter module example
│   └── cpu/                  # CPU module example
├── scripts/
│   └── run-local.sh         # Script for running tests locally
└── README.md
```

## Configuration

The workflow automatically:
1. Installs required dependencies (Icarus Verilog, Verilator, Python packages)
2. Runs Verible linting on all Verilog/SystemVerilog files
3. Compiles and runs testbenches using Icarus Verilog
4. Uploads generated waveforms to ts-verilog-simulator
5. Posts results to PR comments

## Local Development

You can run the tests locally using the provided script:
```bash
./scripts/run-local.sh
```

## Waveform Visualization

Waveforms are automatically uploaded to ts-verilog-simulator and can be viewed:
1. Through the PR comment with the waveform link
2. Directly at `https://ts-verilog-simulator-frontend.vercel.app/waveform/{waveform_id}`

## Testbench Requirements

To ensure proper waveform generation and testing:
1. Include `$dumpfile("waveform.vcd")` in your testbench
2. Use `$dumpvars(0, testbench_module_name)` to specify signals to capture
3. Implement proper test assertions and `$finish` statements

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
