require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/events/show.html.erb" do
  include EventsHelper
  before(:each) do
    assigns[:event] = @event = stub_model(Event,
      :user_id => 1,
      :title => "value for title",
      :priority => 1,
      :done => false
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ title/)
    response.should have_text(/1/)
    response.should have_text(/false/)
  end
end
