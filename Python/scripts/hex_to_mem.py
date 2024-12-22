# Open the input and output files
with open('sample_imem_hex.txt', 'r') as infile, open('output_mem.txt', 'w') as outfile:
    # Read each line from the input file
    for line in infile:
        # Strip any whitespace or newline characters
        hex_string = line.strip()
        # Split the string into 2-character chunks (bytes) and reverse the order
        bytes_list = [hex_string[i:i+2] for i in range(0, len(hex_string), 2)][::-1]
        # Write each byte to the output file on a new line
        for byte in bytes_list:
            outfile.write(byte + '\n')

print("File processed successfully. Check output.txt for results.")
