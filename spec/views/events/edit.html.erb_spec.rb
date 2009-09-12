require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/edit.html.erb" do
  include EventsHelper

  before(:each) do
    assigns[:event] = @event = stub_model(Event,
      :new_record? => false,
      :user_id => 1,
      :title => "value for title",
      :priority => 1,
      :done => false
    )
  end

  it "renders the edit event form" do
    render

    response.should have_tag("form[action=#{event_path(@event)}][method=post]") do
      with_tag('input#event_user_id[name=?]', "event[user_id]")
      with_tag('input#event_title[name=?]', "event[title]")
      with_tag('input#event_priority[name=?]', "event[priority]")
      with_tag('input#event_done[name=?]', "event[done]")
    end
  end
end
