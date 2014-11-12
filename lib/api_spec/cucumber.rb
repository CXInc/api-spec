require "json_spec/cucumber"

require_relative "../api_spec"

World(ApiSpec::Helpers)

Before do |scenario|
  $test_name = scenario.name.downcase.gsub(" ", "_")
  ApiSpec::State.reset
end

# For json_spec
def last_json
  @response.body
end

When(/^I GET "(.*?)"$/) do |path|
  parameters = ApiSpec::Parameters.new(:get, path)
  @response = http_client.get parameters.url, test_headers
  puts "@response = #{@response}"
end

When(/^I GET "(.*?)" with:$/) do |path, table|
  make_request(:get, path, table)
end

When(/^I DELETE "(.*?)" with:$/) do |path, table|
  make_request(:delete, path, table)
end

Then(/^the status code is (\d+)$/) do |code|
  @response.status.to_s.should == code
end

Then(/^the Content\-Type is (.*)$/) do |content_type|
  unless @response.respond_to?(:headers)
    fail "Headers are not available on 4XX and 5XX responses"
  end

  @response.headers[:content_type].should match(content_type)
end

Then(/^the response contains an authentication cookie$/) do
  @response.headers[:set_cookie].first.should match(/x-cx-auth/)
end

When(/^I POST to "(.*?)" with:$/) do |path, table|
  make_request(:post, path, table)
end

When(/^I PUT to "(.*?)" with:$/) do |path, table|
  make_request(:put, path, table)
end

Then(/^the JSON response at "(.*?)" should be variable "(.*?)"$/) do |path, key|
  step "the JSON response at \"#{path}\" should be \"#{ ApiSpec::State.get(key) }\""
end

Then(/^the JSON response at "(.*?)" should include keys:$/) do |base_path, table|
  table.hashes.each do |hash|
    path = "#{ base_path }/#{ hash[:key] }"
    value = hash[:value]
    step "the JSON response at \"#{ path }\" should be #{ value }"
  end
end
