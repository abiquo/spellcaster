class StatusTable
  include Singleton

  def initialize
    puts "initializing status table"
    if !File.exist?(Sinatra::Application.status_table_file)
      @table = {}
      0.upto(6) do |i|
        @table["thunder0#{i}".to_sym] = {
          :post_stage => -1,
          :hypervisor => "Unknown",
          :arch => "Unknown",
          :aim_version => "Unknown"
        }
      end
      save
    else
      load
    end
  end

  def hash
    @table
  end

  def []=(key,val)
    @table[key.to_sym] = val
  end

  def [](key)
    @table[key.to_sym]
  end
  
  def save
    File.open(Sinatra::Application.status_table_file, "w") do |f|
      f.puts @table.to_yaml
    end
  end
  
  def load
    @table = YAML.load_file(Sinatra::Application.status_table_file)
  end
end
