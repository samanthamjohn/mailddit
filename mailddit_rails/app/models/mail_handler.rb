class MailHandler
  attr_accessor :email, :text_body, :html_body, :tags, :date
  def initialize
  end
  
  def send_mail
    Pony.mail(:to => 'samantha.m.john@gmail.com', :from => 'smj2118@gmail.com', :subject => 'hi', :body => 'Hello there.')
  end

  def receive_mail
    
    Mail.defaults do
      retriever_method :pop3, { :address             => "pop.gmail.com",
                                :port                => 995,
                                :user_name           => 'mailddit',
                                :password            => 'samiscool',
                                :enable_ssl          => true }
    end
    @email = Mail.last if Mail  #=> Returns the first unread email
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

