require 'net/smtp'
require 'nkf'

module ToolboxSearch
  class Mail
    def self.sendmail(to, from, subject, body)
      # nkf options
      # -W :UTF-8N
      # -m0:no MIME encoded-word
      Net::SMTP.start( 'localhost', 25 ) do |smtp|
        smtp.ready(from, to) do |f|
          f.puts "From: #{from}"
          f.puts "To: #{to.to_a.join(",\n ")}"
          f.puts "Subject: #{NKF.nkf('-Wm0', subject)}"
          f.puts "Date: #{Time::now.strftime('%a, %d %b %Y %X %z')}"
          f.puts "Mime-Version: 1.0"
          f.puts "Content-Type: text/plain; charset=ISO-2022-JP"
          f.puts "Content-Transfer-Encoding: 7bit"
          f.puts "#{NKF.nkf("-Wjm0", body)}"
        end
      end
    end
  end
end