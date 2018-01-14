# choose some of these to start  add the rest later. Find the smaller theaters and add those to the list
# https://www.5thavenue.org/
# https://www.seattlerep.org/
# http://www.acttheatre.org
# https://www.sct.org/
# https://www.stgpresents.org/   includes moore, paramount, neptune
# https://www.villagetheatre.org/   everett and issaquah locations

class CurtainCallSeattle::Scraper
    
    def self.scrape_urls
      fifth = self.scrape_the_5th('https://www.5thavenue.org/boxoffice#current')
      CurtainCallSeattle::Show.create_shows_array(fifth)
      
      sct = self.scrape_childrens('http://www.sct.org/shows/')
      CurtainCallSeattle::Show.create_shows_array(sct)
      
      paramount = self.scrape_paramount('https://seattle.broadway.com/shows/tickets/')
      CurtainCallSeattle::Show.create_shows_array(paramount)
    end

### Scraper for The 5th Avenue Theater ###
    def self.scrape_the_5th(url)
        doc = Nokogiri::HTML(open(url))
        a = doc.css("td .zero, td .guts div")
        the5th = CurtainCallSeattle::Theater.new
        the5th.location = "1308 5th Ave, Seattle, WA 98101"
        the5th.name = "The 5th Avenue Theater"

        a.map {|i| i.text !~ /\w/ ? next : {:name => i.css("h2 a").text, :dates => create_dates_5th(i), :theater => the5th, :description => parse_description_5th(i)}}
            
    end
    
    def self.parse_description_5th(i)
        desc = i.css("p")[1].text
        desc.gsub! /\t/, ''
    end
    
    def self.create_dates_5th(i)

        d = i.css(".date").text
        d = d.split(/\W{2,}/)
        dates = [d[0] + " " + d[2], d[1] + " " + d[2]]
        y=dates.map {|x| Date.parse(x)}
        (y[0]...y[1])
    end

###Scraper for Seattle Children's Theater###
    
## add other info from website in the future (ie shows with interpreters, age recommendations)
    def self.scrape_childrens(url)   
        doc = Nokogiri::HTML(open(url))
        a=doc.css("div.left-column ul.left-nav a")[1]['href']
        shows_sct('http://www.sct.org/' + a)
    end
    
    def self.shows_sct(url)
        doc = Nokogiri::HTML(open(url))
        a = doc.css("div.content table.pagelist tr td")
        
        sct = CurtainCallSeattle::Theater.new
        sct.location = "201 Thomas St, Seattle, WA 98109"
        sct.name = "Seattle Children's Theater"

        a.map {|i| i.text !~ /\w/ ? next : {:name => i.css("b a").text, :dates => create_dates_childrens(i), :theater => sct, :description => parse_description_childrens(i)[1]}}
    end
    
    def self.parse_description_childrens(i)
        i = i.css("p").text
        i.gsub!(/\t|\n|\r/, "")
        i.split(/\s{2,}/)
    end
    
    def self.create_dates_childrens(i)
        d = i.css("p b")[1].text
        d = d.split (/–|,\s/)  ##this is a special dash of some sort it is not a hyphen if you delete this copy paste --> –
        dates = [d[0] + " " + d[2], d[1] + " " + d[2]]
        y = dates.map {|x| Date.parse(x)}
        (y[0]...y[1])
    end

###Scraper for Paramount Theater ###
    def self.scrape_paramount(url)
        doc = Nokogiri::HTML(open(url))
        a = doc.css("ul .result")
        
        paramount = CurtainCallSeattle::Theater.new
        paramount.location = "911 Pine St, Seattle, WA 98101"
        paramount.name = "The Paramount Theater"
        
        a.map do |i|
            begin
           {:name => i.css("img").attr("alt").text,
           :dates => create_dates_paramount(i),
           :theater => paramount,
           :description => get_description_paramount("https://seattle.broadway.com" + i.css("a")[1]['href'] )}
           rescue
           binding.pry
       end
        end
        
    end
    
    def self.create_dates_paramount(i)
        begin
        b = i.css("p.dates")
        b.at_css("span").remove if b.at_css("span")
        b = b.text
        c = b.split(/\s|,\s|–/)
        if c.size == 4
            dates = [c[0] + " " + c[1] + ", " + c[-1], c[0] + " " + c[2] + ", " + c[-1]]
        elsif c.size == 5
            dates = [c[0] + " " + c[1] + ", " + c[-1], c[2] + " " + c[3] + ", " + c[-1]]
        elsif c.size == 6
            dates = [c[0] + " " + c[1] + ", " + c[2], c[3] + " " + c[4] + ", " + c[5]]
        end

        y = dates.map {|x| Date.parse(x)}
        (y[0]...y[1])
        rescue
        binding.pry
    end
    end
    
    def self.get_description_paramount(url)
        doc = Nokogiri::HTML(open(url))
        doc.css("div.mod-story p").text
        # a = doc.css("div.mod-story p")
        # binding.pry
    end
end
