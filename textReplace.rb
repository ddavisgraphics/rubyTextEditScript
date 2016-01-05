File.open('./data/original.txt') do |file|

    #declare needed vars
    output      = ""
    temp_string = ""
    groups      = []
    parts       = []

    # remove any spacing tabs or new lines from the entire document
    file.each_line do |record|
        record      = record.gsub(/\s+/, ' ')
        record      = record.gsub("|", ' | ')
        record      = record.gsub(/\r/ , '')
        record      = record.gsub(/\n/ , '')
        temp_string += record;
    end

   parts = temp_string.split('|')
   puts parts.inspect

    # # loop through the array and iterate it into smaller groups
    # while(parts.any?)
    #     groups << parts.slice!(0,38)
    # end

    # # loop through the array again to break it into strings for a new line
    # groups.each do |group|
    #     output += group.join('|')
    #     output += "\r\n"
    # end

    # # create a new file and put the content in there
    # output_file = File.new("fixedFile.txt", "w")
    # output_file.puts(output)
    # output_file.close
end

# File.open('./data/original.txt') do |file|
#     file.each_line do |record|
#         record = record.split('|')
#         puts record.inspect
#         puts record.count
#     end
# end

