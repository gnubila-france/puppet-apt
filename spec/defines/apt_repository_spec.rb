require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt::repository' do

  let(:title) { 'apt::repository' }
  let(:node) { 'rspec.example42.com' }
  let(:params) {
    { 'name'       =>  'sample1',
      'url'        =>  'url1',
      'distro'     =>  'distro1',
      'repository' =>  'repo1',
    }
  }

  describe 'Test apt repository' do
    it 'should create a sample1.list file' do
      should contain_file('apt_repository_sample1').with_ensure('present')
      should contain_file('apt_repository_sample1').with_path('/etc/apt/sources.list.d/sample1.list')
    end
    it 'should populate correctly sample1.list file' do
      content = catalogue.resource('file', 'apt_repository_sample1').send(:parameters)[:content]
      content.should match(/# File managed by Puppet

# sample1 repository
deb url1 distro1 repo1/)
    end
  end

  describe 'Test apt source repository' do
    let(:params) {
      { 'name'       =>  'sample2',
        'url'        =>  'url2',
        'distro'     =>  'distro2',
        'repository' =>  'repo2',
        'source'     => true,
      }
    }

    it 'should create a sample2.list file' do
      should contain_file('apt_repository_sample2').with_ensure('present')
      should contain_file('apt_repository_sample2').with_path('/etc/apt/sources.list.d/sample2.list')
    end
    it 'should populate correctly sample2.list file' do
      content = catalogue.resource('file', 'apt_repository_sample2').send(:parameters)[:content]
      content.should match(/# File managed by Puppet

deb-src url2 distro2 repo2/)
    end
  end

  describe 'Test apt source with specific template' do
    let(:params) {
      { 'name'       =>  'sample3',
        'url'        =>  'url3',
        'distro'     =>  'distro3',
        'repository' =>  'repo3',
        'template'   =>  'apt/spec.erb',
      }
    }
    let(:facts) { { :options => {} } }

    it 'should create a sample3.list file' do
      should contain_file('apt_repository_sample3').with_ensure('present')
      should contain_file('apt_repository_sample3').with_path('/etc/apt/sources.list.d/sample3.list')
    end
    it 'should populate correctly sample3.list file' do
      content = catalogue.resource('file', 'apt_repository_sample3').send(:parameters)[:content]
      content.should match(/name: sample3/)
    end
  end

  describe 'Test apt repository with key by name' do
    let(:params) {
      { 'name'       =>  'sample4',
        'url'        =>  'url4',
        'distro'     =>  'distro4',
        'repository' =>  'repo4',
        'key'        =>  'key4',
      }
    }

    it 'should create a sample4.list file' do
      should contain_file('apt_repository_sample4').with_ensure('present')
      should contain_file('apt_repository_sample4').with_path('/etc/apt/sources.list.d/sample4.list')
    end
    it 'should populate correctly sample4.list file' do
      content = catalogue.resource('file', 'apt_repository_sample4').send(:parameters)[:content]
      content.should match(/# File managed by Puppet

# sample4 repository
deb url4 distro4 repo4/)
    end
    it 'should execute a key add command' do
      should contain_exec('aptkey_add_key4').with_command('gpg --recv-key key4 ; gpg -a --export | apt-key add -')
      should contain_exec('aptkey_add_key4').with_unless('apt-key list | grep -q key4')
    end
  end

  describe 'Test apt repository with key by url' do
    let(:params) {
      { 'name'       =>  'sample5',
        'url'        =>  'url5',
        'distro'     =>  'distro5',
        'repository' =>  'repo5',
        'key'        =>  'key5',
        'key_url'    =>  'key5_url',
      }
    }

    it 'should create a sample5.list file' do
      should contain_file('apt_repository_sample5').with_ensure('present')
      should contain_file('apt_repository_sample5').with_path('/etc/apt/sources.list.d/sample5.list')
    end
    it 'should populate correctly sample5.list file' do
      content = catalogue.resource('file', 'apt_repository_sample5').send(:parameters)[:content]
      content.should match(/# File managed by Puppet

# sample5 repository
deb url5 distro5 repo5/)
    end
    it 'should execute a wget command' do
      should contain_exec('aptkey_add_key5').with_command('wget -O - key5_url | apt-key add -')
      should contain_exec('aptkey_add_key5').with_unless('apt-key list | grep -q key5')
    end
  end

  describe 'Test deleting apt source' do
    let(:params) {
      { 'name'       =>  'sample6',
        'url'        =>  'url6',
        'distro'     =>  'distro6',
        'repository' =>  'repo6',
        'ensure'     =>  'absent',
      }
    }

    it 'should not create a sample6.list file' do
      should contain_file('apt_repository_sample6').with_ensure('absent')
    end
  end

end
