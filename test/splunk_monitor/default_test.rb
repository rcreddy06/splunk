describe file('/opt/splunkforwarder/etc/apps/00_autogen_inputs__var_log/local') do
  it { should exist }
  it { should be_owned_by 'test_user' }
end

describe file('/opt/splunkforwarder/etc/apps/00_autogen_inputs__var_log/local/inputs.conf') do
  it { should exist }
  it { should be_owned_by 'test_user' }
  its(:content) { should match /monitor\:\/\/\/var\/log/ }
end