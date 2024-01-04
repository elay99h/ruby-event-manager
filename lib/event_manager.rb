require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

csv_content = CSV.open('../event_attendees.csv', headers: true, header_converters: :symbol)
templete_letter = File.read("../form_letter.erb")
erb_template = ERB.new(templete_letter)
registration_hours = []

def find_peak_hours(data)
    registration_hour_count = Hash.new(0)

    data.each do |d|
      registration_hour_count[d] += 1
    end

    max_v = registration_hour_count.values.max
    peak_hours = registration_hour_count.select{ |hour, count| count == max_v}.keys.to_a

    peak_hours
end

def get_hour_f_date(date)
     return Time.strptime(date,"%m/%d/%y %H:%M").hour
end

# --------------------------- #
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end
# --------------------------- #
def clean_homephone(phone)

  if phone.length == 10
    "Valid number"
  elsif phone.length < 10 || phone.length > 11 || phone.length == 11 && phone.chars[0] != "1"
    "Bad Number"

  elsif phone.length == 11 && phone.chars[0] == "1"
    phone.slice(1..-1)
  end

end
# --------------------------- #
def legislators_by_zipcode(zip)

  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials

    return legislators
  rescue => e
    "#{e}"
  end
end
# --------------------------- #
def save_thank_you_letter(id, form_letter)

  Dir.mkdir('output') unless Dir.exist?('output')
  file_name = "output/thanks_to_#{id}.html"

  File.open(file_name, "w") do |file|
    file.puts form_letter
  end
end
# --------------------------- #

# ---------- MAIN ------------- #
csv_content.each do |row|

  att_id = row[0]
  reg_date = row[:regdate]
  name = row[:first_name]
  registration_hours << get_hour_f_date(reg_date)
  home_phone = clean_homephone(row[:homephone])
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)
  save_thank_you_letter(att_id, form_letter)

end
# --------------------------- #

peak_h = find_peak_hours(registration_hours).join(", ")
puts "Peak registration hours: #{peak_h}"
