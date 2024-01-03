require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"
csv_content = CSV.open('../event_attendees.csv', headers: true, header_converters: :symbol)
templete_letter = File.read("../form_letter.erb")
erb_template = ERB.new(templete_letter)

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def clean_homephone(phone)
  if phone.length == 10
    "Valid number"

  elsif phone.length < 10 || phone.length > 11 || phone.length == 11 && phone.chars[0] != "1"
  "Bad Number"

  elsif  phone.length == 11 && phone.chars[0] == "1"
  phone.slice(1..-1)
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"
  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials

    return legislators

  rescue => e
    "#{e}"
  end
end

def save_thank_you_letter(id, form_letter)
      Dir.mkdir('output') unless Dir.exsist?('output')

      file_name = "output/thanks_to_#{id}.html"

      File.open(file_name, "w") do |file|
        file.puts form_letter
      end

end

csv_content.each do |row|
  id = row[0]
  name = row[:first_name]
  home_phone = clean_homephone(row[:homephone])
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)
  save_thank_you_letter(id, form_letter)

end
