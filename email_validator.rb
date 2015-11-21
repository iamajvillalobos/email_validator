require 'HTTParty'
require 'pry'
require 'csv'

class EmailValidator

  def initialize(access_key)
    @access_key = access_key
  end

  def open_csv(csv_file)
    emails_to_be_clean = []
    CSV.foreach("#{csv_file}") do |row|
      emails_to_be_clean << row[0]
    end
    emails_to_be_clean
  end

  def clean_emails(emails)
    clean_email_lists = []

    emails.each do |email|
      puts "checking #{email}"
      clean_email_lists << check_email(email) if check_email(email)
    end

    clean_email_lists
  end

  def check_email(email)
    url = "http://apilayer.net/api/check?access_key=#{@access_key}&email=#{email}&smtp=0&format=1"
    response = HTTParty.get(url)
    if response['score'] >= 0.80
      puts "#{response['email']} has a score of #{response['score']}"
      return response['email']
    end
    puts "#{response['email']} has a score of #{response['score']}"
  end

  def save_to_csv(clean_emails)
    CSV.open('clean_emails.csv', 'w') do |csv|
      clean_emails.each do |email|
        csv << [email]
      end
    end
    puts "Saved successfully"
  end

end

validator = EmailValidator.new("dc7dff78981742d67313704efc8eb1fc")
emails_to_be_clean = validator.open_csv('emails.csv')
filtered_emails = validator.clean_emails(emails_to_be_clean)
validator.save_to_csv(filtered_emails)
