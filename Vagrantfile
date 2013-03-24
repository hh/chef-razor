#require 'berkshelf/vagrant'

Vagrant.configure('2') do |config|
  
  config.vm.define :default do |box_config|
    # All Vagrant configuration is done here. The most common configuration
    # options are documented and commented below. For a complete reference,
    # please see the online documentation at vagrantup.com.
    
    # The path to the Berksfile to use with Vagrant Berkshelf
    # config.berkshelf.berksfile_path = "./Berksfile"
    
    # An array of symbols representing groups of cookbook described in the Vagrantfile
    # to skip installing and copying to Vagrant's shelf.
    # config.berkshelf.only = []
    
    # An array of symbols representing groups of cookbook described in the Vagrantfile
    # to skip installing and copying to Vagrant's shelf.
    # config.berkshelf.except = []
    
    box_config.vm.hostname = "razor-berkshelf"
    box_config.vm.box = "opscode-ubuntu-12.04"
    box_config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"
    
    config.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
    end                
    

    # Boot with a GUI so you can see the screen. (Default is headless)
    # config.vm.boot_mode = :gui
    
    # Assign this VM to a host-only network IP, allowing you to access it
    # via the IP. Host-only networks can talk to the host machine as well as
    # any other machines on the same network, but cannot be accessed (through this
    # network interface) by any external networks.
    box_config.vm.network :private_network, ip: "10.0.124.9"

    # Assign this VM to a bridged network, allowing you to connect directly to a
    # network using the host's network device. This makes the VM appear as another
    # physical device on your network.
    
    # config.vm.network :bridged

    # Forward a port from the guest to the host, which allows for outside
    # computers to access the VM, whereas host only networking does not.
    # config.vm.forward_port 80, 8080

    # Share an additional folder to the guest VM. The first argument is
    # an identifier, the second is the path on the guest to mount the
    # folder, and the third is the path on the host to the actual folder.
    # config.vm.share_folder "v-data", "/vagrant_data", "../data"
    
    box_config.ssh.max_tries = 40
    box_config.ssh.timeout   = 120
    
    box_config.vm.provision :chef_solo do |chef|
      chef.json = {
        :rbenv => {
          :git_repository => 'https://github.com/sstephenson/rbenv.git'
        },
        :ruby_build => {
          :git_repository => 'https://github.com/sstephenson/ruby-build.git'
        },
        :dhcp => {
          :master => true,
          :slave => false,
          :interfaces => ["eth1"],
          :networks => ["10-0-124-0_24"]
        },
        :razor => {
          :image_host => "10.0.124.9",
          :api_host => "10.0.124.9"
        }
        
      }
      
      chef.data_bags_path = "examples/data_bags"
      
      chef.run_list = [
        "recipe[razor::default]"
      ]
    end
    
  end
  
  1.upto(2).each do |pxe_number|
    name = "pxe-test-#{pxe_number}".to_s 
    config.vm.define name.to_sym do |box_config|
      
      box_config.vm.box = 'pxe-blank'
      box_config.vm.box_url = 'https://github.com/downloads/benburkert/bootstrap-razor/pxe-blank.box'
      
      box_config.vm.provider :virtualbox do |v|
        v.gui = true
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--name", "pxe_test_#{pxe_number}.localdomain"]
        #v.customize ["modifyvm", :id, "--nictype1", 'Am79C973']
        v.customize ["modifyvm", :id, "--hostonlyadapter1", 'vboxnet2']
        v.customize ["modifyvm", :id, "--macaddress1", "c0ffee00000#{pxe_number}"]
      end
      box_config.ssh.port = 22
      box_config.ssh.max_tries = 40
      box_config.ssh.timeout   = 120
      #box_config.vm.network :hostonly, "10.0.124.1#{pxe_number}"
      box_config.vm.network :private_network, ip: "10.0.123.1#{pxe_number}"
    end
  end
  
end
