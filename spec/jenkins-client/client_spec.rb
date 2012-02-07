require "spec_helper"
require "jenkins-client/client"

describe Jenkins::Client do 
  describe "#jobs" do
    subject {
      client = Jenkins::Client.new
      client.username = "testuser"
      client.password = "testpass"
      client.url = "https://jenkinstest.com"
      client
    }
    it "will return a list of jobs" do
      body = '{"assignedLabels":[{}],"mode":"NORMAL","nodeDescription":"the master Jenkins node","nodeName":"","numExecutors":2,"description":null,"jobs":[
      {"name":"foo-bar","url":"https://testjenkins.com/job/foo-bar/","color":"blue"},
      {"name":"woohoo","url":"https://jenkinstest.com/job/woohoo/","color":"red"},
      {"name":"wat","url":"https://jenkinstest.com/job/wat/","color":"red"},
      {"name":"fudge","url":"https://jenkinstest.com/job/fudge/","color":"blue"},
      {"name":"amaze","url":"https://jenkinstest.com/job/amaze/","color":"blue"}]}'
      stub_request(:get, "https://testuser:testpass@jenkinstest.com/api/json").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => body, :headers => {})
      subject.jobs.should include({"name"=>"foo-bar",
        "url"=>"https://testjenkins.com/job/foo-bar/",
        "color"=>"blue"})
      subject.jobs.should have(5).items
    end
  end
end