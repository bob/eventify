require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "value for title",
      :priority => 1,
      :due => Time.now,
      :done => false,
      :created_at => Time.now,
      :updated_at => Time.now
    }

    @valid_event = Event.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
  
  it "should require title" do
    Event.new(@valid_attributes.except(:title)).should have(1).error_on(:title)
  end               
  
  it "should validate priority" do
    Event.new(@valid_attributes.merge({:priority => 5})).should have(1).error_on(:priority)
  end  
  
  it "should mark and unmark as done" do
    event = Event.new(@valid_attributes.merge({:done => false}))
    event.mark_as_done
    event.done.should be_true
    event.unmark_as_done     
    event.done.should be_false
  end                    
  
end

describe Event, ".fetch_for_period" do      
  fixtures :events
    
  it "should return valid items for periods" do  
    today = Date.today

    Event::fetch_for_period(today, today + 1).should have(1).items.kind_of(Event)
    Event::fetch_for_period(today, today.next_week + 1).should have(2).items.kind_of(Event)
    Event::fetch_for_period(today, today.next_month + 1).should have(3).items.kind_of(Event)
    Event::fetch_for_period(today, today.next_year + 1).should have(4).items.kind_of(Event)
  end
  
  it "list should be sorted by priority" do
    today = Date.today    
    list = Event.fetch_for_period(today, today.next_year)
    list.should have(4).items.kind_of(Event)
    list.map(&:priority).should eql(list.map(&:priority).sort)
  end
end

