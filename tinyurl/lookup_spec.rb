require_relative 'lookup'

describe Tinyurl do
  before(:each) do
    Tinyurl.class_variable_set :@@lookup_tiny_urls, {}
    Tinyurl.stub(:environment => 'production')
  end

  it "works" do
    Tinyurl.get("http://kytrinyx.com").should eq("https://is.gd/2RNxXq")
  end

  it "caches" do
    Tinyurl.should_receive(:lookup).once.and_return {"http://short.url"}
    Tinyurl.get("http://google.com")
    Tinyurl.get("http://google.com")
  end

  it "just returns the original url on errors" do
    result = stub(:code => 409)
    Net::HTTP.stub(:start => result)
    Tinyurl.get("http://example.com").should eq('http://example.com')
  end

  specify "well, not all errors" do
    result = stub(:code => 500)
    Net::HTTP.stub(:start => result)
    # Not sure what actually causes the API to return 500
    ->{ Tinyurl.get("http://something.com") }.should raise_error Tinyurl::InvalidUrlException
  end

  it "doesn't worry about invalid urls" do
    Tinyurl.get("invalidurl").should eq("invalidurl")
  end

  it "swallows timeouts, returning the unshortened url" do
    Net::HTTP.stub(:start).and_raise(Timeout::Error)
    Tinyurl.get("http://timeout.com").should eq("http://timeout.com")
  end

  it "works in staging, too" do
    Tinyurl.stub(:environment => 'staging')
    Tinyurl.get("http://kytrinyx.com").should == 'https://is.gd/2RNxXq'
  end

  it "doesn't actually work in development" do
    Tinyurl.stub(:environment => 'development')
    Tinyurl.get("http://xkcd.com/1110").should == nil
  end

  it "doesn't work in test, either" do
    Tinyurl.stub(:environment => 'test')
    Tinyurl.get("http://thedailywtf.com").should == nil
  end
end
