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
#puts result["postings"].second["location"]

#store results in database



    # Create new Post
   result["postings"].each do |posting|

      # Create new Post
      @post = Post.new
      @post.heading = posting["heading"]
      @post.body = posting["body"]
      @post.price = posting["price"]
      @post.state = posting["location"]["locality"]
      @post.external_url = posting["external_url"]
      @post.timestamp = posting["timestamp"]

      # Save Post


    # Save Post
    @post.save
    end
  end

  desc "TODO"
  task destroy_all_posts: :environment do
  end
end
