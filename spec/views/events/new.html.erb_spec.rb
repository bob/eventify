require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/new.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:event] = stub_model(Event,
      :new_record? => true,
      :user_id => 1,
      :title => "value for title",
      :priority => 1,
      :done => false
    )
  end

  it "renders new event form" do
    render

    response.should have_tag("form[action=?][method=post]", events_path) do
      with_tag("input#event_user_id[name=?]", "event[user_id]")
      with_tag("input#event_title[name=?]", "event[title]")
      with_tag("input#event_priority[name=?]", "event[priority]")
      with_tag("input#event_done[name=?]", "event[done]")
    end
  end
end
