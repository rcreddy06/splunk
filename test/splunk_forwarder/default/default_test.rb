
describe user('test_user') do
  it { should exist }
end

describe group('test_group') do
  it { should exist }
end

describe file('/opt/splunkforwarder/') do
  it { should exist }
  it { should be_owned_by 'test_user' }
end
