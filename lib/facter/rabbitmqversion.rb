def get_debian_rabbitmq_version
  depends = Facter::Util::Resolution.exec('apt-cache show rabbitmq 2>/dev/null |grep "^Depends" |head -n 1')
  if match = /^Depends: rabbitmqql-(.*)$/.match(depends)
    match[1]
  else
    nil
  end
end

def get_redhat_rabbitmq_version
  version = Facter::Util::Resolution.exec('/bin/rpm -qa rabbitmq-server')
  if match = /^rabbitmq-server-(\d+\.\d+\.\d+).*.noarch$/.match(version)
    match[1]
  else
    nil
  end
end

Facter.add("rabbitmqversion") do
  setcode do
    case Facter.value('osfamily')
      when 'RedHat'
        get_redhat_rabbitmq_version()
      when 'Debian'
        get_debian_rabbitmq_version()
      else
        nil
    end
  end
end
