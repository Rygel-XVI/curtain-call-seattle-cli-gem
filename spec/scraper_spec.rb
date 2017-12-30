describe "Scraper" do
        
    let!(:test_array) {[{:name=>"Hamilton", :theater=>"5th Avenue", :genre=>"Musical"},
                           {:name=>"Chicago", :theater=>"5th Avenue", :genre=>"Musical"},
                           {:name=>"Othello", :theater=>"5th Avenue", :genre=>"Play"}]}
                           
   describe "#scrape_the_5th" do
    it "is a class method that scrapes the theater index page ('5thavenue.org/') and a returns an array of hashes in which each hash represents one show" do
      url = "5thavenue.org/boxoffice#current"
      scraped_shows = Scraper.scrape_the_5th(url)
      expect(scraped_shows).to be_a(Array)
      expect(scraped_shows.first).to have_key(:location)
      expect(scraped_shows.first).to have_key(:name)
      expect(scraped_shows).to include(show_index_array[0], show_index_array[1], show_index_array[2])
    end
  end
    
end