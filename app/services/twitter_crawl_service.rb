class TwitterCrawlService
  require 'net/http'
  require 'json'
  attr_reader :twitter_url, :api_token

  def initialize(args)
    @twitter_url = args[:twitter_url]
    @api_token = args[:api_token]
  end

  def crawling
    uri = URI('https://api.proxycrawl.com')
    uri.query = URI.encode_www_form({
                                      token: api_token,
                                      format: 'json',
                                      url: twitter_url
                                    })
    response = Net::HTTP.get_response(uri)
    parsing_twitter_profile(response)
  end

  private

  def parsing_twitter_profile(res)
    json = JSON.parse(res.body)
    parsed_data = Nokogiri::HTML.parse(json['body'])
    profile_data(parsed_data)
  end

  def profile_data(parsed_data)
    data = {
      'name' => parsed_data.css('.ProfileHeaderCard-nameLink').text,
      'bio_card' => parsed_data.css('.ProfileHeaderCard-bio').text,
      'join_date' => parsed_data.css('.ProfileHeaderCard-joinDateText').text,
      'birth_date' => parsed_data.css('.ProfileHeaderCard-birthdateText').text,
      'handle' => parsed_data.css('.ProfileHeaderCard-screennameLink span').text
    }
    parsed_data.css('.ProfileNav-list .ProfileNav-stat').each do |d|
      key = d.attributes['data-nav']&.value
      data[key] = d.attributes['title']&.value
    end
    save_data(data)
    data
  end

  def save_data(profile_data)
    File.open("public/#{profile_data['name'].parameterize}-twitter.json", 'w') do |f|
      f.write(profile_data.compact)
    end
  end
end
