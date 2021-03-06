if Rails.env.development?
  # gmail configuration for sending emails
  # ActionMailer::Base.delivery_method = :smtp
  # ActionMailer::Base.smtp_settings = {
  #   address:              'smtp.gmail.com',
  #   port:                 587,
  #   domain:               'league-hero.herokuapp.com',
  #   user_name:            ENV["LH_USERNAME"],
  #   password:             ENV["LH_PASSWORD"],
  #   authentication:       'plain',
  #   enable_starttls_auto: true
  # }
  
elsif Rails.env.production?
  # sendgrid configuration for sending emails
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address:              'smtp.sendgrid.net',
    port:                 587,
    domain:               'herokuapp.com',
    user_name:            ENV["SENDGRID_USERNAME"],
    password:             ENV["SENDGRID_PASSWORD"],
    authentication:       'plain',
    enable_starttls_auto: true
  }

end
