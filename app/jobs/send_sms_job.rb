class SendSmsJob < ApplicationJob
  queue_as :default

  rescue_from Net::ReadTimeout, SocketError do |e|
    e.ignore_please = true
    sleep 1
    # re-raise so job is retried
    raise e
  end

  def perform(args)
    # if Rails.env.development?
    #   return unless Rails.env.test?
    # end
    send_using_custom_sms args
  end

  #custom sms
  def send_using_custom_sms(args)
    #Send Sms TO Client
    message = "Dear Customer, Your Complain no #{args.ticketid} has assigned to #{args.assigned_to.name}(#{args.assigned_to.mobile}). %0a Regards, Arbuda Computer."
    calling_url = "http://mobi1.blogdns.com/httpmsgid/SMSSenders.aspx?UserID=Arbudacomputer&UserPass=Arb@123$&Message=#{message}&MobileNo=#{args.customer.mobile}&GSMID=samudr"
    uri = URI(calling_url)
    res = Net::HTTP.get(uri)
    # user send sms
    user_message = "You have assigned to new Complain is #{args.ticketid} from #{args.customer.name} and mobile #{args.customer.mobile}.%0a Regards, Arbuda Computer. "
    uesr_calling_url = "http://mobi1.blogdns.com/httpmsgid/SMSSenders.aspx?UserID=Arbudacomputer&UserPass=Arb@123$&Message=#{user_message}&MobileNo=#{args.assigned_to.mobile}&GSMID=samudr"
    uri = URI(uesr_calling_url)
    res = Net::HTTP.get(uri)
  end
end
