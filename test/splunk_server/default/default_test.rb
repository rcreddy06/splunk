
describe user('test_user') do
  it { should exist }
end

describe group('test_group') do
  it { should exist }
end

describe file('/opt/splunk/') do
  it { should exist }
  it { should be_owned_by 'test_user' }
end

describe service('splunk') do
  it { should be_enabled }
  it { should be_running }
end