include_recipe 'build-essential::default'
include_recipe 'phantomjs::setup'

# Install supporting packages
node['phantomjs']['packages'].each { |name| package name }

version  = node['phantomjs']['version']
src_dir  = node['phantomjs']['src_dir']
bin_dir  = node['phantomjs']['bin_dir']
base_url = node['phantomjs']['base_url']
checksum = node['phantomjs']['checksum']

basename = "phantomjs-#{version}-source"
bin_path = "#{bin_dir}/phantomjs"

remote_file "#{src_dir}/#{basename}.zip" do
  owner     'root'
  group     'root'
  mode      '0644'
  backup    false
  source    "#{base_url}/#{basename}.zip"
  checksum  checksum if checksum
  not_if    { ::File.exists?(bin_path) && `#{bin_path} --version`.chomp == version }
  notifies  :run, 'execute[phantomjs-install]', :immediately
end

execute 'phantomjs-extract' do
  command   "unzip #{src_dir}/#{basename}.zip -d #{src_dir}/#{basename}"
  action    :nothing
  notifies  :run, 'link[phantomjs-link]', :immediately
end

execute 'phantomjs-install' do
  action    :nothing
  notifies  :create, 'link[phantomjs-link]', :immediately
end

link 'phantomjs-link' do
  target_file   bin_path
  to            "/usr/local/#{basename}/bin/phantomjs"
  owner         'root'
  group         'root'
  action        :nothing
end