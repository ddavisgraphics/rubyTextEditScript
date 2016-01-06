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


## Initial File when working with TXT File
# ===================================================

# File.open('./data/original.txt') do |file|

#     #declare needed vars
#     output = ""
#     groups = []
#     line   = 0

#     # temp array
#     temp_array = [];

#     # get number of records from the first line
#     number_of_records = file.first.split('|').count

#     file.each_line do |record|
#         count_line = record.split('|').count
#         if count_line < number_of_records
#             # do nothing
#         elsif count_line > number_of_records
#             puts "LineNumber - #{line} : numRecords = #{count_line} "
#         else
#            # do nothing
#         end

#         line += 1
#     end

# end

    # remove any spacing tabs or new lines from the entire document
    # file.each_line do |record|

    #     # count this line
    #     count_line = record.split('|').count

    #     # remove tabs spacings and returns
    #     record = record.gsub(/\s+/, ' ')
    #     record = record.gsub(/\t/ , '')
    #     record = record.gsub(/\r/ , '')
    #     record = record.gsub(/\n/ , '')

    #     if count_line < number_of_records
    #         if temp_array.count < number_of_records
    #             temp_array << record.split('|')
    #         elsif temp_array.count > number_of_records
    #             temp_record = record.split('|')
    #             groups << temp_record.slice!(0, number_of_records)
    #             temp_array << temp_record
    #         else
    #             groups << record.split('|')
    #         end
    #     elsif count_line > number_of_records
    #         puts count_line
    #     else
    #         groups << record.split('|')
    #     end
    # end

    #puts groups.inspect

   # parts = temp_string.split('|')
   # puts parts.inspect

    # # loop through the array and iterate it into smaller groups
    # while(parts.any?)
    #     groups << parts.slice!(0,38)
    # end

    # loop through the array again to break it into strings for a new line
    # groups.each do |group|
    #     output += group.join('|')
    #     output += "\n"
    # end

    # # create a new file and put the content in there
    # output_file = File.new("fixedFile.txt", "w")
    # output_file.puts(output)
    # output_file.close
# end
