bin_dir  = node['phantomjs']['bin_dir']
bin_url  = node['phantomjs']['bin_url']

bin_path = "#{bin_dir}/phantomjs"

remote_file bin_path do
  owner     'root'
  group     'root'
  mode      '0755'
  backup    false
  source    bin_url
  checksum  checksum if checksum
  not_if    { ::File.exists?(bin_path) && `#{bin_path} --version`.chomp == version }
end