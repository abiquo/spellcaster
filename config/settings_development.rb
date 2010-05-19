#set :propone, value
set :logger, Logger.new(Sinatra::Application.root + '/log/development.log')
set :views, File.join(Sinatra::Application.root, 'app/views')
set :pxe_config_dir, Sinatra::Application.root + "/public/generated"
set :kickstart_config_dir, Sinatra::Application.root + "/public/generated"
set :mac_addresses, {
  "thunder06" => "00-26-b9-7c-df-f7",
  "thunder05" => "00-26-b9-7c-df-e8",
  "thunder04" => "00-26-b9-7c-6a-48",
  "thunder03" => "00-26-b9-7c-74-d4",
  "thunder02" => "00-26-b9-7d-5f-dd",
  "thunder01" => "00-26-b9-7b-18-8a",
  "thunder00" => "00-0a-e4-25-65-94"
}

set :ipmi_password, "XXXX"
set :ipmi_addresses, {
  "thunder06" => "10.60.1.110",
  "thunder05" => "10.60.1.111",
  "thunder04" => "10.60.1.112",
  "thunder03" => "10.60.1.113",
  "thunder02" => "10.60.1.114",
  "thunder01" => "10.60.1.114",
  "thunder00" => "10.60.1.109"  
}

set :post_stage_strings, {
  -1 => "Unused",
  0 => "In Queue",
  1 => "Bootstrapping",
  2 => "Cooking with Chef",
  3 => "Ready!"  
}

set :mail_errors_to, "webmaster@netcorex.org"
set :status_table_file, Sinatra::Application.root + "/db/status_table.yml"
set :provision_alert_mail, "srubio@abiquo.com"
set :mail_from, "noreply@abiquo.com"
set :distro_mirror_url, "http://mirror.bcn.abiquo.com/centos/5/os"
set :spellcaster_url, "http://spellcaster.bcn.abiquo.com"
set :packages_url, "http://packages.bcn.abiquo.com/"
set :pubkeys_url, "http://pubkey.bcn.abiquo.com/"
set :alert_on_provisioning, "no"

def logger
  Sinatra::Application.logger
end
