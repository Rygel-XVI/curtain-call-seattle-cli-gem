# require "curtain-call-seattle/version"

# choose some of these to start  add the rest later
# https://www.5thavenue.org/
# https://www.seattlerep.org/
# http://www.acttheatre.org
# https://www.sct.org/
# https://www.stgpresents.org/   includes moore, paramount, neptune
# https://www.villagetheatre.org/   everett and issaquah locations


class Scraper
  # Your code goes here...
  
#   1. take each website w/ nokogiri
#   2. parse it into arrays to make objects out of that the cli can return values off of
#   3. objects will be theater, show, genre


# Goes through the website and creates the song
    def self.scrape_the_5th(url)
        doc = Nokogiri::HTML(open(url))
        a = doc.css("td .zero, td .guts")
        a.each do |i|
            show = Show.new
            show.name = i.css("div h2 a").text
            show.dates = i.css("div .date").text
            show.theater = "The 5th Avenue Theater"
            desc = i.css("div p")[1].text
            show.description = desc.gsub /\t/, ''
            
            #:name => i.css("div h2 a").text
            #:dates => i.css("div .date").text
            #:description =>  i.css("div p")[1].text
            #all theaters are the 5th Avenue
           binding.pry 
        end
        binding.pry
    end
    
    def scraped_shows
        
    end
    
    def create_shows
        
    end
    
    
end
