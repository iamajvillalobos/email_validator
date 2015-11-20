require 'HTTParty'
require 'pry'
require 'csv'

emails_to_be_clean = Array.new
clean_emails = []

CSV.foreach('emails.csv') do |row|
  emails_to_be_clean << row[0]
end

emails_to_be_clean.each do |email|
  access_key = "dc7dff78981742d67313704efc8eb1fc"
  url = "http://apilayer.net/api/check?access_key=#{access_key}&email=#{email}&smtp=1&format=1"

  response = HTTParty.get(url)
  if response['score'] >= 0.80
    clean_emails << response['email']
    puts "Added #{response['email']}"
  end
  puts "#{response['email']} is invalid"
end

CSV.open('clean_emails.csv', 'w') do |csv|
  clean_emails.each do |email|
    csv << [email]
  end
end
