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

## Update Scope of the Project Changed 

The only majors differences happened because the third party client wouldn't accept fields that had more than 255 characters.  So the file had to be changed to look at the largest column of information and change that column to represent a much smaller set of data.  While some of the fields were nil, others had specific data.  The admin also wanted the size of that column put into a column that no other files were currently using.  This was acheieved by moddifying the script to be a has instead of an array of values.  

```ruby
require 'csv'

# Get File
# ==========================================
input_string = File.read('./data/test.csv').force_encoding('MacRoman').encode('UTF-8')

# create a better array for picking out data
csv_file = CSV.new(input_string, :headers => true, :header_converters => :symbol)
data = csv_file.to_a.map{ |row| row.to_hash }

# create variable for new data to go into
cleaned_data    = []
sm_patron_notes = []
lg_patron_notes = []
output          = ""

data.each do |row|
    # checks to make sure everything parsed correctly
    if row.count > 38 || row.count < 38
        puts "item count is off #{row.count}"
    end

    #loop through the data rows and preform subs
    #put the data in a new hash so that we can pull into 2 types of array later
    changed_data = Hash.new
    row.each do |key, value|
        if value != nil
            value = value.gsub(/\t/ , '')
            value = value.gsub(/\r/ , '')
            value = value.gsub(/\n/ , '')
            value = value.gsub(/\s+/, ' ')
        end
        changed_data[key] = value
    end
    # send it to cleaned data
    cleaned_data << changed_data
end

#seperate the data into two seperate arrays based on a certain value
cleaned_data.each do |row|
    if row[:patronnotes] != nil
        if row[:patronnotes].length < 255
            row[:prefix] = row[:patronnotes].length
            sm_patron_notes << row
        else
            row[:prefix] = row[:patronnotes].length;
            lg_patron_notes << row
        end
    else
        row[:prefix] = 0;
        sm_patron_notes << row
    end
end

# Create pipe Delimited File for array with less than 255 chars
# =============================================================

# create a new file and put the content in there
output_file = File.new("fileLess255.txt", "w")

#create the first line of headers
first_line  = sm_patron_notes.first.keys
first_line  = first_line.join('|')
output_file.puts(first_line)

# loop through the array again to break it into strings for a new line
sm_patron_notes.each do |line|
    # get just the values not the keys
    simple_array = line.values

    # join the values in pipe delimited
    output = simple_array.join('|')
    output += "\n"

    # write it to the file
    output_file.puts(output)
end

#close the file and finish up
output_file.close

# Create pipe Delimted File for array with more than 255 chars
# =============================================================

# create a new file and put the content in there
second_file = File.new("fileMore255.txt", "w")

# create headers
second_file.puts(first_line)

# loop through the array again to break it into strings for a new line
lg_patron_notes.each do |line|
    # get just the values not the keys
    simple_array = line.values

    # join the values in pipe delimited
    output = simple_array.join('|')
    output += "\n"

    # write it to the file
    second_file.puts(output)
end

#close the file and finish up
second_file.close

puts "complete"
```
