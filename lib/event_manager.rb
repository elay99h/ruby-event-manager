require 'csv'

csv_content = CSV.open('../event_attendees.csv', headers: true, header_converters: :symbol)

    def clean_zipcode(zipcode)
        if zipcode.nil?
            "00000"
        elsif zipcode.length > 5
           zipcode.slice(0..4)
        elsif zipcode.length < 5
            zipcode.rjust(5, "0")
        else
            zipcode
        end
    end

    csv_content.each do |row|
        name = row[:first_name]
        zip_code = clean_zipcode(row[:zipcode])

    end

    csv_content.close
