require "csv"
require "sunlight/congress"
require "erb"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_phone(numbers)
	less_than_10 = numbers.length < 10
	greater_than_11 = numbers.length > 11
	first_num_not_1  = numbers[0] != "1"
	first_num_is_1 = numbers[0] == "1"
	equals_11 = numbers.length == 11

	if less_than_10 || greater_than_11 || (equals_11 && first_num_not_1)
		""
	elsif equals_11 && first_num_is_1
		numbers[0] == ""
	end
	return numbers
end

def only_numbers(phone)
	phone.scan(/\d+/).join
end

def clean_zipcode(zipcode)
	zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
	Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
	Dir.mkdir("output") unless Dir.exists? "output"

	filename = "output/thanks#{id}.html"

	File.open(filename, "w") do |file|
		file.puts form_letter
	end
end

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
contents.each do |row|
	id = row[0]
	name = row[:first_name]
	phone = clean_phone(only_numbers(row[:homephone]))
	puts "#{phone}"

	




	#zipcode = clean_zipcode(row[:zipcode])
	#legislators = legislators_by_zipcode(zipcode)

	#form_letter = erb_template.result(binding)

	#save_thank_you_letters(id, form_letter)
end