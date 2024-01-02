require 'csv'

csv_content = CSV.open('../event_attendees.csv', headers: true, header_converters: :symbol)

    def clean_zipcode(zipcode)
       zipcode.to_s.rjust(5, "0")[0..4]
    end



    csv_content.each do |row|
        name = row[:first_name]
        zip_code = clean_zipcode(row[:zipcode])

        puts zip_code
    end

    csv_content.close
