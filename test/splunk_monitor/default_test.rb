describe file('/opt/splunkforwarder/etc/apps/00_autogen_inputs/') do
  it { should exist }
  it { should be_owned_by 'test_user' }
end

describe file('/opt/splunkforwarder/etc/apps/00_autogen_inputs/local/inputs.conf') do
  it { should exist }
  it { should be_owned_by 'test_user' }
end