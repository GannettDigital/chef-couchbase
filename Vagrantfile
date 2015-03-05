VAGRANTFILE_API_VERSION = '2'
Vagrant.require_version '>= 1.5.0'

WEB_ADMIN_PORT = '8091'
API_PORT = '8092'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.omnibus.chef_version = :latest
  config.vm.box = 'chef/centos-6.5'

  config.vm.network :forwarded_port, guest: WEB_ADMIN_PORT, host: WEB_ADMIN_PORT, autocorrect: true
  config.vm.network :forwarded_port, guest: API_PORT, host: API_PORT, autocorrect: true
  
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.memory = 4096
    v.cpus = 2
  end

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  config.berkshelf.enabled = true

  config.vm.provision "chef_zero" do |chef|

    chef.add_recipe "couchbase::server"

    chef.json = {
    }

  end
end