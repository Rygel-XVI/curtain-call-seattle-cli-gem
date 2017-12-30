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

    def self.scrape_the_5th(url)
        doc = Nokogiri::HTML(open(url))
        binding.pry
    end
end
