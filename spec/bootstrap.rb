require "serverspec"
require_relative "lib/ansible_helper"

if ENV.has_key?("CONTINUOUS_INTEGRATION") && ENV["CONTINUOUS_INTEGRATION"] == "true"
  set :backend, :exec
else
  options = AnsibleHelper.instance.sshOptions

  set :backend, :ssh

  set :host,        options[:host_name]
  set :ssh_options, options
end


# Disable sudo
set :disable_sudo, true

# use a login shell so that Phpenv is loaded
set :shell, "/bin/bash"
set :login_shell, true

# Set PATH
set :path, '/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:$PATH'

shared_examples "nginx::config" do
  describe command("nginx -t") do
    let(:disable_sudo) { false }

    it "has no errors" do
      expect(subject.stderr).to match /configuration file \/etc\/nginx\/nginx\.conf syntax is ok/
      expect(subject.stderr).to match /configuration file \/etc\/nginx\/nginx\.conf test is successful/

      expect(subject.exit_status).to eq 0
    end
  end
end

shared_examples "phpenv" do
  describe command("phpenv help") do
    it "has no errors" do
      expect(subject.exit_status).to eq 0
    end
  end
end
