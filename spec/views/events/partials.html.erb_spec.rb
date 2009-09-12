require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "events/index.html.erb partials" do
  
  it "should have a correct quickie partial" do
    render :partial => "/events/quickie_new"
    
    response.should have_tag("form[action=?][method=post][onsubmit*=Ajax.Updater][onsubmit*=failure:'quickie_form']", create_quickie_events_path ) do
      with_tag("select#event_priority[name=?]", "event[priority]") do
        with_tag("option[value=?]", "1" )
        with_tag("option[value=?]", "2" )
        with_tag("option[value=?]", "3" )
      end
      with_tag("input#event_title[name=?]", "event[title]")
      with_tag("select#event_due_1i[name=?]", "event[due(1i)]")
      with_tag("select#event_due_2i[name=?]", "event[due(2i)]")
      with_tag("select#event_due_3i[name=?]", "event[due(3i)]")
    end
  end        

  it "should show unmarked list item" do                                 
    mock_event = stub_model(Event,
      :id => "37",
      :priority => 1,
      :done => false
    )
    render :partial => "/events/list_item", :locals => {:list_item => mock_event}
    response.should have_tag("input[type=checkbox][name=?][onclick*=Ajax.Request]", "cb_#{mock_event.id}")
    response.should have_tag("a[onclick*=Ajax.Request][onclick*=?]", edit_event_path(mock_event))
    response.should have_tag("a[href=?][title='Delete item']", event_path(mock_event))
  end

  it "should show marked list item" do                                 
    mock_event = stub_model(Event,
      :id => "37",
      :title => "Event title",
      :done => true
    )
    render :partial => "/events/list_item", :locals => {:list_item => mock_event}
    response.should have_tag("input[type=checkbox][checked=checked][name=?][onclick*=Ajax.Request]", "cb_#{mock_event.id}")
    response.should_not have_tag("a[onclick*=Ajax.Request][onclick*=?]", edit_event_path(mock_event))
    response.should have_text(/Event title/)
    response.should_not have_tag("a[href=?][title='Delete item']", event_path(mock_event))
  end
end