require 'net/imap'

class IMAP
  def initialize(config)
    @config = config
    @server = Net::IMAP.new(config['host'])
    # Don't use IMAP#capabilities, don't want to cache the
    # authentication capabilities
    @server.starttls({:verify_mode => OpenSSL::SSL::VERIFY_NONE}) if @server.capability.include?("STARTTLS")
    @server.authenticate(config['type'],config['username'],config['password'])
  end

  def get_folders()
    @server.list("","*")
  end

  def disconnect
    @server.disconnect
  end

  def get_messages(folder)
    @server.examine(folder)
    if capabilities.include?("SORT")
      msgs = @server.sort(["DATE"],["ALL"],"UTF-8")
    else
      msgs = @server.search(["ALL"], "UTF-8")
    end
    @server.fetch(msgs,"ENVELOPE")
  end

  def get_message(folder, id)
    @server.examine(folder)
    @server.fetch([id.to_i], "(BODY[HEADER] BODY[TEXT])")
  end

  def capabilities
    @capabilities ||= @server.capability();
  end
  
  def self.config
    @config ||= YAML::load_file('config.yml')
  end
  
  def self.open()
    server = self.new(config['imap'])    
    if (block_given?)
      ret = yield server
      server.disconnect
      ret
    else
      server
    end
  end
end
