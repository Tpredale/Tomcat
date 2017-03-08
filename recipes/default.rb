#
# Cookbook:: tomcat_install
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
package "java-1.7.0-openjdk-devel"

group 'chef'

user 'chef' do
  group 'chef'
end

remote_file 'apache-tomcat-8.0.41.tar.gz' do
  source 'http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-8/v8.0.41/bin/apache-tomcat-8.0.41.tar.gz'
end

directory 'opt/tomcat' do

end

execute 'sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'

execute 'sudo chgrp -R chef /opt/tomcat/conf'

directory 'opt/tomcat/conf' do
  mode '0070'
end

execute 'sudo chmod g+r /opt/tomcat/conf/*'

execute 'sudo chown -R chef /opt/tomcat/webapps/* /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/'

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
end

execute 'sudo systemctl daemon-reload'

service "tomcat" do
  action [:start, :enable]
end