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
        # binding.pry
        doc = Nokogiri::HTML(open(url))
        a = doc.css("td .zero, td .guts div")
        the5th = Theater.new
        the5th.location = "1308 5th Ave, Seattle, WA 98101"
        the5th.name = "The 5th Avenue Theater"
        the5th.save
        
        a.map do |i|
            begin
            ## if i.text isn't words then there is no show there
            next if i.text !~ /\w/
            
            show = Show.new
            show.name = i.css("h2 a").text
            show.dates = i.css(".date").text
            show.theater = the5th
            # desc = i.css("p")[1].text
            # show.description = desc.gsub /\t/, ''
            show.description = parse_description_5th(i)
            show.save
            # binding.pry
            
            # show.theater.
            
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
    
    def self.parse_description_5th(i)
        desc = i.css("p")[1].text
        desc.gsub! /\t/, ''
    end
    
# change this later to 'click' on the top link and parses the info in that so it works next year
    def self.scrape_childrens(url)    
        doc = Nokogiri::HTML(open(url))
        a = doc.css("div.content table.pagelist tr td")
        
        sct = Theater.new
        sct.location = "201 Thomas St, Seattle, WA 98109"
        sct.name = "Seattle Children's Theater"
        sct.save
        
        a.map do |i|
            # binding.pry
            begin
            
            show = Show.new
            show.name = i.css("b a").text
            show.dates = i.css("p b")[1].text
            show.theater = sct
            
            # b = i.css("p").text
            # b.gsub!(/\t|\n|\r/, "")
            # c = b.split(/\s{2,}/)
            # show.description = c[1]
            show.description = parse_description_childrens(i)[1]
  
            show.save

            # :name => i.css("b a").text
            # :date => i.css("p b")[1].text
            
            # b = i.css("p").text
            # b.gsub!(/\t|\n|\r/, "")
            # c = b.split(/\s{2,}/)
            # :description => c[1]
            
            rescue
            binding.pry
        end

        end
        # binding.pry
    end
    
    def self.parse_description_childrens(i)
        i = i.css("p").text
        i.gsub!(/\t|\n|\r/, "")
        i.split(/\s{2,}/)
    end
    
    
    def scraped_shows
        
    end
    
    def create_shows
        
    end
    
    
end
