from PIL import Image
## Python code borrowed from Piazza post @269 by Daniyal Nizami and then modified quite a bit for how my code works
# Open image
img = Image.open("stage3.jpg") #change to whatever image name in the same folder

# Get pixel values
pixels = img.load()

# Create an empty list to hold the words
words = []

# Iterate over 4x4 blocks of pixels
for j in range(0, img.size[1], 1):
    for i in range(0, img.size[0], 1):

        # Create empty lists for each color channel
        r_vals = 0
        g_vals = 0
        b_vals = 0

        # Iterate over pixels in 4x4 block
        for y in range(j, j+1):
            for x in range(i, i+1):
                # Get the RGB color value of the pixel
                r, g, b = pixels[x, y]

                # Append color values to respective lists
                r_vals = r
                g_vals = g
                b_vals = b

        # Calculate the average color values for the block
        

        # Convert to hexadecimal format
        hex_value = f"{r_vals:02x}{g_vals:02x}{b_vals:02x}"
        
        # Convert to word format for MIPS assembly
        word = f"0x{hex_value}"
        if(word[2] == "a"):
            word = "0xad9b91"
        elif(word[4] == "f" and word[2] == "0"):
            word = "0x00ff00"
        elif(word[2] == "9"):
            word = "0xad9b91"
        elif(word[2] == "b"):
            word = "0xad9b91"    
        elif(word[2] == "d"):
            word = "0xd7d6dc"
        elif(word[2] == "e"):
            word = "0xd7d6dc"
        elif(word[2] == "0" and word[6] != "f"):
            word = "0x000000"
        elif(word[2] == "3"):
            word = "0x3583ff"
        

        # Append the word to the list
        words.append(word)

# Helps set up the array in MIPS later:
print(f"Number of values in the array: {len(words)}")

# Convert the list of words into a string with comma-separated values and curly braces
data_str = ", ".join(words) 

# Save the data string to a text file
with open("image_data.txt", "w") as f:
    f.write(data_str)