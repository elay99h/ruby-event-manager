require 'csv'

csv_content = CSV.open('../event_attendees.csv', headers: true, header_converters: :symbol)


    csv_content.each do |row|
        name = row[:first_name]
        zip_code = row[:zipcode]

        puts "#{name} #{zip_code}"
    end
