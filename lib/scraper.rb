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
#   3. objects will be theater, show


# Goes through the website and creates the song
##change this to a hash and dynamically add w/ mass assignment later
    def self.scrape_the_5th(url)
        doc = Nokogiri::HTML(open(url))
        a = doc.css("td .zero, td .guts div")
        
        a.map do |i|
            begin
            ## if i.text isn't words then there is no show there
            next if i.text !~ /\w/
            
            show = Show.new
            show.name = i.css("h2 a").text
            show.dates = i.css(".date").text
            show.theater = "The 5th Avenue Theater"
            desc = i.css("p")[1].text
            show.description = desc.gsub /\t/, ''
            show.save
            
            #:name => i.css("div h2 a").text
            #:dates => i.css("div .date").text
            #:description =>  i.css("div p")[1].text
            #all theaters are the 5th Avenue
            rescue
            binding.pry
        end
        end
        # binding.pry

    end
    
# change this later to 'click' on the top link and parses the info in that so it works next year
    def self.scrape_childrens(url)    
        doc = Nokogiri::HTML(open(url))
        a = doc.css("div.content table.pagelist tr td")
        a.map do |i|
            # binding.pry

            # :name => i.css("b a").text
            # :date => i.css("p b")[1].text
            
            # b = i.css("p").text
            # b.gsub!(/\t|\n|\r/, "")
            # c = b.split(/\s{2,}/)
            # :description => c[1]
            begin
            
            show = Show.new
            
            show.name = i.css("b a").text
            show.dates = i.css("p b")[1].text
            
            b = i.css("p").text
            b.gsub!(/\t|\n|\r/, "")
            c = b.split(/\s{2,}/)
            show.description = c[1]
            
            show.theater = "Seattle Children's Theater"
            
            show.save
            
            rescue
            binding.pry
        end

        end
        # binding.pry
    end
    
    
    def scraped_shows
        
    end
    
    def create_shows
        
    end
    
    
end
