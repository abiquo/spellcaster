class ProvisionSystem
  @queue = :default
  
  def self.perform(params)
    @host = params['host']
    logger.debug ">>>>>>>>>>>> provisioning system #{@host}"
    @aim_version = params['aim_version']
    @hypervisor_type = params['hypervisor_type']
    if !Sinatra::Application.mac_addresses[@host]
      logger.error "MAC address for #{@host} not found"
      return ""
    end
    @distro_mirror_url = Sinatra::Application.distro_mirror_url
    @spellcaster_url = Sinatra::Application.spellcaster_url
    @pubkeys_url = Sinatra::Application.pubkeys_url
    @packages_url = Sinatra::Application.packages_url
    @arch=params['arch']
    @drive="sda"
    @pxe_menu_label = "Centos54_#{@hypervisor_type}_#{@arch}"

    StatusTable.instance[@host.to_sym][:arch] = @arch
    StatusTable.instance[@host.to_sym][:hypervisor] = @hypervisor_type
    StatusTable.instance[@host.to_sym][:aim_version] = @aim_version
    StatusTable.instance[@host.to_sym][:post_stage] = 1
    @ks_file = "#{@host}.ks"
    @json_config_url = "http://cookbooks.bcn.abiquo.com/cloud-node-#{@hypervisor_type}.json"
    @chefsolo_config_url = "http://cookbooks.bcn.abiquo.com/cs-config.rb"
    @cookbooks_tarball_url = "http://cookbooks.hq.abiquo.com/cloud-node-#{@aim_version}-cookbooks.tar.gz"
    @post_code = <<-EOH
    # Chef Solo
    pushd /tmp/install
    wget #{@chefsolo_config_url} >> /root/chef-solo.log 2>&1
    wget #{@json_config_url} >> /root/chef-solo.log 2>&1
    /usr/local/bin/chef-solo -c cs-config.rb -j cloud-node-#{@hypervisor_type}.json  -r #{@cookbooks_tarball_url} >> /root/chef-solo.log 2>&1
    popd 
    EOH
    set :tftp_dir, "/srv/pxecentos5_#{@arch}"
    set :pxe_config_dir, "#{Sinatra::Application.tftp_dir}/pxelinux.cfg"
    @repos = [
      "http://apt.sw.be/redhat/el5/en/#{@arch}/dag",
      "http://download.opensuse.org/repositories/Openwsman/RHEL_5/"
    ]
    logger.debug """
      Host: #{@host}
      Aim Version: #{@aim_version}
      Hypervisor Type: #{@hypervisor_type}
      Arch: #{@arch}
      Drive: #{@drive}
      PXE Menu Label: #{@pxe_menu_label}
      KS File: #{@ks_file}
      POST CODE: #{@post_code}
      Repos: #{@repos.inspect}
    """
    logger.debug "Generating KS template"
    tmpl = IO.read(Sinatra::Application.root + "/resources/centos54.ks.erb")
    runner = ERB.new(tmpl)
    File.open Sinatra::Application.kickstart_config_dir + "/#{@host}.ks", "w" do |f|
      generated_ks = runner.result(binding)
      f.puts generated_ks
      #logger.debug "####### GENERATED KS FILE ###########"
      #logger.debug generated_ks
    end
    tmpl = IO.read(Sinatra::Application.root + "/resources/pxeconfig.erb")
    runner = ERB.new(tmpl)
    File.open Sinatra::Application.pxe_config_dir + "/01-#{Sinatra::Application.mac_addresses[@host]}", "w" do |f|
      generated_pxe_file = runner.result(binding)
      f.puts generated_pxe_file
      #logger.debug "####### GENERATED PXE FILE ###########"
      #logger.debug generated_pxe_file
    end
    `sudo /usr/bin/pkill -f in.tftp`
    `sudo /usr/sbin/in.tftpd -l -s #{Sinatra::Application.tftp_dir}`
    `ipmitool -H #{Sinatra::Application.ipmi_addresses[@host]} -U root -P#{Sinatra::Application.ipmi_password} power on`
    `ipmitool -H #{Sinatra::Application.ipmi_addresses[@host]} -U root -P#{Sinatra::Application.ipmi_password} power cycle`
    
    StatusTable.instance.save
    file = "01-#{Sinatra::Application.mac_addresses[@host].dup}"
    logger.debug "Sleeping worker"
    sleep 150
    logger.debug "Removing boot file #{file}"
    `rm -f #{Sinatra::Application.pxe_config_dir}/#{file}`
  end
end
