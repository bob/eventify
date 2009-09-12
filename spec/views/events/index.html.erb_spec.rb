require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/index.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:events] = [
      stub_model(Event,
        :user_id => 1,
        :title => "value for title 1", 
        :priority => 1,
        :done => false
      ),
      stub_model(Event,
        :user_id => 1,
        :title => "value for title 2",
        :priority => 1,
        :done => false
      )
    ] 
  end

  it "renders a list of events" do
    render                                  
    response.should have_tag("div[id='quickie_form']")
    response.should have_tag("div[id=?]", "event_#{assigns[:events][0].id}") do 
      with_tag("input[type=checkbox][name=?][onclick*=Ajax.Request]", "cb_#{assigns[:events][0].id}")
      with_tag("font[color=red]", "high")      
    end    
    
  end  
  
  it "should include quickie form" do
    template.should_receive(:render).with(:partial => "/events/quickie_new")    
    render
  end
    
  it "should show periods links" do
    render 
    response.should have_tag("div.period_links", /^Today/)
    response.should have_tag("a[href=?]", period_events_url(:period => "week"))
    response.should have_tag("a[href=?]", period_events_url(:period => "month"))
    response.should have_tag("a[href=?]", period_events_url(:period => "year"))
  end  
    
end
