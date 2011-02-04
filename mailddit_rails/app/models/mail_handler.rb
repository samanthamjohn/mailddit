class MailHandler

  attr_accessor :email, :text_body, :html_body, :tags, :date
  def initialize
  end
  
  def send_mail(to_address=nil, subject=nil, html_body=nil)
	subject ||= 'HTML Email from a bot'
	to_address ||= 'samantha.m.john@gmail.com'
	html_body ||= "#{::Rails.root.to_s}/html_mail/body.html"
	Pony.mail(:to => to_address
	:via => :smtp, :via_options => {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            =>  MailAuth["user_name"],
    :password             =>  MailAuth["password"],
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "smtp.gmail.com" # the HELO domain provided by the client to the server
  },
    :body => 'Hi, \n this email is from Sam!! \nSincerely, \nSam',
    :html_body => File.read(html_body),
    :subject =>  subject
    )
  end

  def receive_mail
    Mail.defaults do
      retriever_method :pop3, { :address             => "pop.gmail.com",
                                :port                => 995,
                                :user_name           => MailAuth["user_name"], 
                                :password            => MailAuth["password"],
                                :enable_ssl          => true }
    end
	  mail = Mail.first
  end
  
  def parse_mail
    @email.parts.each do |part|
      content_type = part.content_type.split(";").first
      body = part.body.raw_source
      if content_type == "text/plain"
        @text_body = body
      elsif content_type == "text/html"
        @html_body = body
      end
    end
    subject = @email.subject.gsub("Fwd: ", " ").gsub("Re: ", " ")
    @tags = subject.split(",").collect{|subj| subj.strip}
    @date = @email.date
  end
end

