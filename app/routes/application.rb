get '/' do
  @meta_refresh = true
  haml :index
end

get '/go_thunder' do
  haml :go_thunder
end

post '/release_thunder' do
  StatusTable.instance[params[:host].to_sym][:post_stage] = -1
  redirect "/"
end

post '/thunder_post_stage' do
  puts "THUNDER #{params[:host]} stage #{params[:post_stage]}"
  StatusTable.instance[params[:host].to_sym][:post_stage] = params[:post_stage]
  StatusTable.instance.save
end

get '/dump_status_table' do
  output = ""
  StatusTable.instance.hash.each do |k,v|
    output << "#{k}: #{v.inspect}<br/>"
  end
  output
end

post '/go_thunder' do
  user = params[:email]
  if user.nil? or user.chomp.strip.empty?
    user = "Anonymous Coward"
  end
  logger.info "#{user} is provisioning"
  host = params[:host]
  arch = params[:arch]
  aim_version = params[:aim_version]
  hypervisor_type = params[:hypervisor_type]
    
  begin
    if Sinatra::Application.alert_on_provisioning == "yes"
      Pony.mail(:to => Sinatra::Application.provision_alert_mail, :from => Sinatra::Application.mail_from, 
              :subject => "[spellcaster] #{user} is Provisioning #{host.upcase}... [#{hypervisor_type},#{arch},#{aim_version}]",
              :body => "You heard it, right? :D. It takes ~10 minutes to provision the server in 2010.")
    end
  rescue Exception => e
    logger.error "Error sending provisioning mail alert."
  end
  
  StatusTable.instance[host.to_sym][:aim_version] = aim_version          
  StatusTable.instance[host.to_sym][:arch] = arch
  StatusTable.instance[host.to_sym][:hypervisor] = hypervisor_type
  StatusTable.instance[host.to_sym][:post_stage] = 0
  Resque.enqueue ProvisionSystem, params
  haml :go_thunder
end
