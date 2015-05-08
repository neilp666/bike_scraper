namespace :scraper do
  desc "Fetch Craigslist posts from 3Taps"
  task scrape: :environment do
    require 'open-uri' #ruby gem 
    require 'JSON'

# Set API token and URL 
auth_token = "fa9504f4383a477d56f4a23a1cc86e0d"
polling_url = "http://polling.3taps.com/poll"

# Specify request parameters
params = {
  auth_token: auth_token,
  anchor: 2109915749,
  source: "CRAIG",
  category_group: "SSSS",
  category: "SBIK",
  'location.country' => "USA",
  retvals: "location,external_url,heading,body,timestamp,price,images,annotations"
}

# Prepare API request 
uri = URI.parse(polling_url)
uri.query = URI.encode_www_form(params)

# Submit request  -hitting enter
result = JSON.parse(open(uri).read)

# Display results to screen (put string - display information)
puts JSON.pretty_generate result


  end

  desc "TODO"
  task destroy_all_posts: :environment do
  end

end
