
# choose some of these to start  add the rest later. Find the smaller theaters and add those to the list
# https://www.5thavenue.org/
# https://www.seattlerep.org/
# http://www.acttheatre.org
# https://www.sct.org/
# https://www.stgpresents.org/   includes moore, paramount, neptune
# https://www.villagetheatre.org/   everett and issaquah locations

##where to createCurtainCallSeattle::Show.new?
class CurtainCallSeattle::Scraper

# Goes through the website and creates the song
##change this to a hash and dynamically add w/ mass assignment later
    def self.scrape_the_5th(url)
        doc = Nokogiri::HTML(open(url))
        a = doc.css("td .zero, td .guts div")
        the5th = CurtainCallSeattle::Theater.new
        the5th.location = "1308 5th Ave, Seattle, WA 98101"
        the5th.name = "The 5th Avenue Theater"
        the5th.save

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
    
# change this later to 'click' on the top link and parses the info in that so it works next year
# in a future version add appropriate age info and info for accomodations (ie interpreters)
    def self.scrape_childrens(url)    
        doc = Nokogiri::HTML(open(url))
        a = doc.css("div.content table.pagelist tr td")
        
        sct = CurtainCallSeattle::Theater.new
        sct.location = "201 Thomas St, Seattle, WA 98109"
        sct.name = "Seattle Children's Theater"
        sct.save

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
        y=dates.map {|x| Date.parse(x)}
        (y[0]...y[1])
    end

end
