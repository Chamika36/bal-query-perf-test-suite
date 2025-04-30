import json

# Create an array from 1 to 1,000,000
big_array = list(range(1, 1000))

# Write to file
with open("big-array.txt", "w") as f:
    json.dump(big_array, f)

print("✅ big-array.txt with 1 million numbers created!")
