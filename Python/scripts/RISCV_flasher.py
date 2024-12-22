import serial

# Function to read byte values from a text file
def read_byte_file(file_path):
    byte_values = []
    try:
        with open(file_path, 'r') as file:
            for line in file:
                line = line.strip()  # Remove any extra whitespace or newline characters
                if line:  # Ensure the line is not empty
                    byte_values.append(int(line, 16))  # Convert the hex string to an integer
        print(f"Read {len(byte_values)} bytes from {file_path}.")
    except Exception as e:
        print(f"Error reading file: {e}")
        exit()
    return byte_values

# Function to send byte values over serial communication
def send_bytes(serial_port, baud_rate, byte_values):
    try:
        ser = serial.Serial(serial_port, baud_rate, timeout=1)
        print(f"Opened serial port {serial_port} at {baud_rate} baud.")
        
        for byte in byte_values:
            ser.write(bytes([byte]))
            print(f"Sent byte: {byte:#04x}")  # Print in hex format for clarity
        
        ser.close()
        print("Serial port closed.")
    except Exception as e:
        print(f"Error during serial communication: {e}")

# Configuration
file_path = 'D:\Projects\RISCV and Accelerator\scripts\Fibonacci.txt'  # Replace with your file path
serial_port = 'COM12'          # Replace with your serial port
baud_rate = 2000000              # Adjust as needed

# Execution
byte_values = read_byte_file(file_path)  # Read byte values from the file
send_bytes(serial_port, baud_rate, byte_values)  # Send them through serial
