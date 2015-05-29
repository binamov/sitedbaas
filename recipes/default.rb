#
# Cookbook Name:: sitedbaas
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'httpdbaas::install_apache'

template '/etc/apache2/httpd.conf' do
  source 'sitedbaas.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

tarball = "#{Chef::Config[:file_cache_path]}/webfiles.tar.gz"

remote_file tarball do
  owner 'root'
  group 'root'
  mode '0644'
  source 'https://s3.amazonaws.com/binamov-delivery/webfiles.tar.gz'
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end

execute 'extract web files' do
  command "tar -xvf #{tarball} -C /var/www/html/"
  not_if do
    ::File.exist?('/var/www/favicon.ico')
  end
end
