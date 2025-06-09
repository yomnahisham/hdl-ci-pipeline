#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install dependencies
brew install icarus-verilog verilator python@3.9 jq

# Install Python dependencies
pip3 install requests

# Function to run a test
run_test() {
    local test_dir=$1
    local test_name=$2
    
    echo -e "\n🔍 Running $test_name test..."
    cd $test_dir
    
    # Compile and run
    iverilog -o testbench.vvp *.v
    vvp testbench.vvp
    
    # Upload waveform if successful
    if [ -f "waveform.vcd" ]; then
        echo "📤 Uploading waveform to ts-verilog-simulator..."
        RESPONSE=$(curl -s -F "file=@waveform.vcd" https://ts-verilog-simulator-backend.onrender.com/api/v1/waveform/upload)
        WAVEFORM_ID=$(echo $RESPONSE | jq -r '.waveform_id')
        
        if [ ! -z "$WAVEFORM_ID" ] && [ "$WAVEFORM_ID" != "null" ]; then
            echo "✅ Waveform uploaded successfully!"
            echo "🔗 View at: https://ts-verilog-simulator-frontend.vercel.app/waveform/$WAVEFORM_ID"
        else
            echo "❌ Failed to upload waveform. API Response:"
            echo $RESPONSE
        fi
    fi
    
    cd ../..
}

# Run counter test
run_test "examples/counter" "Counter"

# Run ALU test
run_test "examples/cpu" "CPU"
