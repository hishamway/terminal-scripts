# input_file = "faxFail.txt"
# output_file = "faxResult.txt"

# matching_lines = []
# search_string = ["Answer" , "but no fax extension in"]

# with open(input_file, 'r', encoding="utf-8") as file:
#     for line in file:
#         if any(search in line for search in search_string):
#             matching_lines.append(line.strip())



# with open(output_file , 'w' , encoding="utf-8") as file:
#     for line in matching_lines:
#         file.write(line +"\n")

import re 
from datetime import datetime


# input_file = "fax_test.txt"
input_file = "faxResult.txt"
output_file = "result.txt"


call_times = {}
results = []


with open(input_file , "r" , encoding="utf-8") as file:
    for line in file:
        # print(line)
        parts = line.split("] ")
        timestamp_str = parts[0].strip("[]")
        call_id = parts[1].split("][")[1]

        print(timestamp_str , call_id)

        timestamp = datetime.strptime(timestamp_str ,  "%Y-%m-%d %H:%M:%S.%f")
        print(timestamp)
        if(call_id in call_times):
            time_diff = timestamp - call_times[call_id]
            results.append(f"CallTime -> {timestamp} :  {call_id} -> Time Difference: {time_diff}")
        call_times[call_id] = timestamp

with open(output_file , "w" , encoding="utf-8") as file:
    for result in results:
        file.write(result + "\n")