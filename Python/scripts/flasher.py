import serial

# Function to read and process the file
def read_and_process_file(file_path):
    byte_list = []
    try:
        with open(file_path, 'r') as file:
            for line in file:
                line = line.strip()  # Remove any extra whitespace or newline characters
                if line:  # Ensure the line is not empty
                    # Convert the 32-bit hex string to an integer
                    value = int(line, 16)
                    # Extract and reverse the bytes (least significant byte first)
                    bytes_reversed = [
                        (value & 0xFF),          # Least significant byte
                        (value >> 8) & 0xFF,
                        (value >> 16) & 0xFF,
                        (value >> 24) & 0xFF     # Most significant byte
                    ]
                    byte_list.extend(bytes_reversed)  # Add to the byte list
        print(f"Processed {len(byte_list)//4} lines into {len(byte_list)} bytes.")
    except Exception as e:
        print(f"Error reading or processing file: {e}")
        exit()
    return byte_list

# Function to send bytes over serial communication
def send_bytes(serial_port, baud_rate, byte_values):
    try:
        ser = serial.Serial(serial_port, baud_rate, timeout=1)
        print(f"Opened serial port {serial_port} at {baud_rate} baud.")
        
        for byte in byte_values:
            ser.write(bytes([byte]))
            print(f"Sent byte: {byte:#04x}")  # Print in hex format for clarity
        
        ser.close()
        print("Program uploaded successfully.")
        print("Serial port closed.")
    except Exception as e:
        print(f"Error during serial communication: {e}")

# Configuration
file_path = 'sample_imem_hex.txt'  # Replace with your file path
serial_port = 'COM12'          # Replace with your serial port
baud_rate = 2000000              # Adjust as needed

# Execution
byte_values = read_and_process_file(file_path)  # Read and process the file
send_bytes(serial_port, baud_rate, byte_values)  # Send the bytes through serial
