require 'json'
require 'rest-client'

require 'terraform_enterprise_api/resources/workspaces'
require 'terraform_enterprise_api/resources/organizations'
require 'terraform_enterprise_api/resources/policies'
require 'terraform_enterprise_api/resource'

module TerraformEnterprise
  class Client
    attr_accessor :base

    def initialize(api_key:, host: 'https://atlas.hashicorp.com/api/v2')
      @base    = host
      @api_key = api_key
      @headers = {
        'Authorization' => "Bearer #{@api_key}",
        'Content-Type' => 'application/vnd.api+json'
      }
    end

    def workspaces
      TerraformEnterprise::Workspaces.new(self)
    end

    def organizations
      TerraformEnterprise::Organizations.new(self)
    end

    def policies
      TerraformEnterprise::Policies.new(self)
    end

    def get(*path)
      data = path.pop if path.last.is_a?(Hash)
      request(:get, path, data)
    end

    def delete(*path)
      data = path.pop if path.last.is_a?(Hash)
      request(:delete, path,data)
    end

    def post(*path)
      data = path.pop if path.last.is_a?(Hash)
      request(:post, path, data)
    end

    def put(*path)
      data = path.pop if path.last.is_a?(Hash)
      request(:put,data,data)
    end

    def patch(*path)
      data = path.pop if path.last.is_a?(Hash)
      request(:patch,path,data)
    end

    def request(method, path, data={}, headers={})
      request = {
        method:  method,
        url:     uri(path),
        headers: @headers.merge(headers || {})
      }
      if method==:get || method==:delete || (request[:headers]['Content-Type'] != 'application/vnd.api+json' && request[:headers]['Content-Type'] != 'application/json')
        request[:headers][:params] = data
      else
        request[:payload] = data.to_json
      end
      puts request if ENV['DEBUG']
      response = RestClient::Request.execute(request)
      puts response if ENV['DEBUG']
      if response.headers[:content_type] && response.headers[:content_type].include?('json')
        data = JSON.parse(response)['data']
        return_data = data.is_a?(Array) ? data.map{|r| Resource.new(data:r, client:self)} : Resource.new(data:data, client:self)
      else
        return_data = respons.body
      end
      return_data
    rescue => ex
      raise ArgumentError, "#{ex.message}: #{request}"
    end

    private

    def uri(path=[])
      "#{@base}/#{path.map{|p| p.to_s}.join('/')}"
    end
  end
end