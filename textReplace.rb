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
