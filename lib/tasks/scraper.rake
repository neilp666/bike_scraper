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
#puts result["postings"].third["annotations"]["source_state"]
#puts result["postings"].second["images"].second["full"]


# store results in database

   result["postings"].each do |posting|

      #Create new Post
      @post = Post.new
      @post.heading = posting["heading"]
      @post.body = posting["body"]
      @post.price = posting["price"]
      @post.state = Location.find_by(code: posting["location"]["state"]).try(:name)
      @post.external_url = posting["external_url"]
      @post.timestamp = posting["timestamp"]


    # Save Post
    @post.save

    # loop over images and save to image database
    posting["images"].each do |image|
      @image = Image.new
      @image.url = image["full"]
      @image.post_id = @post.id
      @image.save
    end
   end
end

  desc "Destroy all posting data"
  task destroy_all_posts: :environment do
    Post.destroy_all
  end


desc "Save neighborhood codes in a reference table"
task scrape_neighborhoods: :environment do
  require 'open-uri' #ruby gem 
  require 'JSON'

# Set API token and URL 
auth_token = "fa9504f4383a477d56f4a23a1cc86e0d"
location_url = "http://reference.3taps.com/locations"

# Specify request parameters
params = {
  auth_token: auth_token,
  country: "USA",
  level: "State"
}

# Prepare API request 
uri = URI.parse(location_url)
uri.query = URI.encode_www_form(params)

# Submit request  -hitting enter
result = JSON.parse(open(uri).read)

# Display results to screen
#puts JSON.pretty_generate result

# Space results in database

result["locations"].each do |location|
  @location = Location.new
  @location.code = location["code"]
  @location.name = location["short_name"]
  @location.save
end
end




end

