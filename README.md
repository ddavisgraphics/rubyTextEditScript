# Text Edit Script (Ruby)

This script was created to modify a file that had over 64000 data entiries that had some unexpected data items while moving into a new system.  This script was initially given as a txt file, during the creation of the text file some data got misplaced so the file was given back to me as a CSV.  This CSV was then taken into ruby, parsed into an array, and modified from that point.  

The unexpected data needed to remove excess spaces, hard returns, new lines, and tabs from the various strings.  I handled the requests knowing that the counts of each item should be 38.  I could have scripted this in, by counting the first line, but there really wasn't a need.   The first check determines if the row has more than 38 items.  If so there is a problem and we need to make it known by displaying something to the console.  Otherwise we are looping through the data and making the changes, unless the items are nil.  If they are nil we aren't doing anything but adding the changed data back into the temp array.  

Then we are creating a new file, loop through the new data, and write it to the new file.  Then save the file and close everything out. 
```ruby 
# Completed Solution uses CSV 
# ==========================================
require 'csv'
input_string = File.read('./data/test.csv').force_encoding('MacRoman').encode('UTF-8')
data = CSV.parse(input_string, :col_sep => ',')

# create variable for new data to go into
cleaned_data = []
output       = ""

data.each do |item|
    # checks to make sure everything parsed correctly
    if item.count > 38 || item.count < 38
        puts "item count is off #{item.count}"
    end

    #loop through the data rows and preform subs
    changed_data = []
    item.each do |row|
        if row != nil
            row = row.gsub(/\t/ , '')
            row = row.gsub(/\r/ , '')
            row = row.gsub(/\n/ , '')
            row = row.gsub(/\s+/, ' ')
        end
        changed_data << row
    end
    cleaned_data << changed_data
end


# create a new file and put the content in there
output_file = File.new("fixedFile.txt", "w")

# loop through the array again to break it into strings for a new line
cleaned_data.each do |line|
    output = line.join('|')
    output += "\n"
    output_file.puts(output)
end

#close the file and finish up
output_file.close
puts "complete"
```
