require 'net/http'
require 'cgi'
require 'timeout'

module Tinyurl

  class TinyurlException < Exception; end
  class InvalidUrlException < TinyurlException; end

  @@lookup_tiny_urls = {}

  def self.get(url)
    @url = url
    if should_lookup?
      @@lookup_tiny_urls[url] = lookup(url)
    else
      @@lookup_tiny_urls[url] || url
    end
    @@lookup_tiny_urls[url]
  end

  private

  def self.endpoint_with(url)
    "#{endpoint}?format=simple&url=#{CGI.escape(url)}"
  end

  def self.endpoint
    "https://is.gd/create.php"
  end

  def self.environment
    ENV['RACK_ENV']
  end

  def self.should_lookup?
    return false unless @@lookup_tiny_urls[@url].nil?
    case environment
    when "production" then return true
    when "staging" then return true
    else return false
    end
    false
  end

  def self.lookup(url)
    begin
      Timeout.timeout(5) do
        uri = URI.parse(endpoint_with(url))
        res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
          http.get("#{uri.path}?#{uri.query}")
        end
        if (200..299).include?(res.code.to_i)
          url = res.body if res
        elsif res.code.to_i == 500
          raise InvalidUrlException
        end
      end
    rescue Timeout::Error
    end
    url
  end
end
