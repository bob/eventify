require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do

  def mock_event(stubs={})
    @mock_event ||= mock_model(Event, stubs)
  end         
  
  def mock_valid_event(stubs={})
    mock_event({:id => "37", :due => Date.today, :priority => 1, :title => "Event", :done => false}.merge!(stubs))
  end

  describe "GET index" do        
    it "populates events for period, default is 'today'" do
      Event.should_receive(:fetch_for_period).with(Date.today, Date.today + 1).and_return([mock_event(:id => 1)])
      get :index
      assigns[:events].should == [mock_event]      
    end

    it "populates events for period, default is 'today' with wrong param" do
      Event.should_receive(:fetch_for_period).with(Date.today, Date.today + 1).and_return([mock_event(:id => 1)])
      get :index, :period => 'foo'
      assigns[:events].should == [mock_event]      
    end
    
    it "populates events for today" do
      Event.should_receive(:fetch_for_period).with(Date.today, Date.today + 1).and_return([mock_event(:id => 1)])
      get :index, :period => 'today'
      assigns[:events].should == [mock_event]      
    end                            

    it "populates event for next week" do
      Event.should_receive(:fetch_for_period).with(Date.today, Date.today.next_week).and_return([mock_event(:id => 1)])
      get :index, :period => 'week'
      assigns[:events].should == [mock_event]
    end
    
    it "populates event for next month" do
      Event.should_receive(:fetch_for_period).with(Date.today, Date.today.next_month).and_return([mock_event(:id => 1)])
      get :index, :period => 'month'
      assigns[:events].should == [mock_event]
    end
    
    it "populates event for next year" do
      Event.should_receive(:fetch_for_period).with(Date.today, Date.today.next_year).and_return([mock_event(:id => 1)])
      get :index, :period => 'year'
      assigns[:events].should == [mock_event]
    end    
  end

  describe "GET show" do
    it "assigns the requested event as @event" do
      Event.stub!(:find).with("37").and_return(mock_event)
      get :show, :id => "37"
      assigns[:event].should equal(mock_event)
    end
  end                   
  
  describe "GET ajax show" do
    it "assigns the requested event as @event" do
      Event.stub!(:find).with("37").and_return(mock_valid_event)
      xhr :get, :show, :id => "37"
      response.should have_rjs(:replace_html, "event_37")
    end    
  end

  describe "GET new" do
    it "assigns a new event as @event" do
      Event.stub!(:new).and_return(mock_event)
      get :new
      assigns[:event].should equal(mock_event)
    end
  end

  describe "GET edit" do
    it "assigns the requested event as @event" do
      Event.stub!(:find).with("37").and_return(mock_event)
      get :edit, :id => "37"
      assigns[:event].should equal(mock_event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created event as @event" do
        Event.stub!(:new).with({'these' => 'params'}).and_return(mock_event(:save => true))
        post :create, :event => {:these => 'params'}
        assigns[:event].should equal(mock_event)
      end

      it "redirects to the created event" do
        Event.stub!(:new).and_return(mock_event(:save => true))
        post :create, :event => {}
        response.should redirect_to(event_url(mock_event))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved event as @event" do
        Event.stub!(:new).with({'these' => 'params'}).and_return(mock_event(:save => false))
        post :create, :event => {:these => 'params'}
        assigns[:event].should equal(mock_event)
      end

      it "re-renders the 'new' template" do
        Event.stub!(:new).and_return(mock_event(:save => false))
        post :create, :event => {}
        response.should render_template('new')
      end
    end

  end     
  
  describe "POST create quickie" do
    describe "with valid params" do
      it "should assign a newly created event to @event and insert into list" do
        Event.stub!(:new).with({'these' => 'params'}).and_return(mock_event(:save => true, :priority => 1, :title => "Event", :due => Date.today, :done => false))

        # Clear quickie form
        @mock_event.should_receive(:priority=).with(1)
        @mock_event.should_receive(:title=).with("")
        @mock_event.should_receive(:due=).with(Date.today)
        
        post :create_quickie, :event => {:these => 'params'}                               
        # assigns[:event].should equal(mock_event)        
        
        response.should have_rjs(:insert_html, "events_list")
        response.should have_rjs(:replace_html, "quickie_form")
      end
    end
    
    describe "with invalid params" do
      it "should assign a newly created event to @event and insert into list" do
        Event.stub!(:new).with({'these' => 'params'}).and_return(mock_event(:save => false))
        controller.should_receive(:render).with(:partial => "events/quickie_new", :status => 444, :layout => false)
                
        post :create_quickie, :event => {:these => 'params'}
        assigns[:event].should equal(mock_event)        
      end
    end    
  end
  
  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested event" do
        Event.should_receive(:find).with("37").and_return(mock_event)
        mock_event.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :event => {:these => 'params'}
      end

      it "assigns the requested event as @event" do
        Event.stub!(:find).and_return(mock_event(:update_attributes => true))
        put :update, :id => "1"
        assigns[:event].should equal(mock_event)
      end

      it "redirects to the event" do
        Event.stub!(:find).and_return(mock_event(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(event_url(mock_event))
      end
    end

    describe "with invalid params" do
      it "updates the requested event" do
        Event.should_receive(:find).with("37").and_return(mock_event)
        mock_event.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :event => {:these => 'params'}
      end

      it "assigns the event as @event" do
        Event.stub!(:find).and_return(mock_event(:update_attributes => false))
        put :update, :id => "1"
        assigns[:event].should equal(mock_event)
      end

      it "re-renders the 'edit' template" do
        Event.stub!(:find).and_return(mock_event(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end   
  
  describe "GET ajax edit" do
    it "assigns the requested event as @event" do
      Event.stub!(:find).with("37").and_return(mock_event(:id => 37, :priority => 1, :title => "Event", :due => Date.today))
      xhr :get, :edit, :id => "37"
      assigns[:event].should equal(mock_event)
      response.should have_rjs(:replace_html, "event_37")
    end
  end     
  
  describe "PUT ajax update" do
    describe "with valid params" do
      it "should update requested event" do
        Event.should_receive(:find).with("37").and_return(mock_valid_event(:update_attributes => true))
        xhr :put, :update, :id => "37", :event => {"title" => 'Event title'}
        response.should have_rjs(:replace_html) 
        response.should be_success       
      end
    end                        
    
    describe "with invalid params" do
      it "should not update requested event" do
        Event.should_receive(:find).with("37").and_return(mock_valid_event(:update_attributes => false))
        xhr :put, :update, :id => "37", :event => {:title => 'params'}   
        response.status.should eql("444")
      end
    end
  end      
  
  describe "POST done update" do
    it "should update requested event - mark as done" do
      Event.should_receive(:find).with("37").and_return(mock_valid_event)
      @mock_event.should_receive(:mark_as_done).and_return(true)
      xhr :post, :done, :id => "37"
      response.should be_success  
      response.should have_rjs(:replace_html)
    end

    it "should handle wrong param" do
      put :done, :id => 'foo'
      response.should be_success             
      response.should_not have_rjs(:replace_html)      
    end

    it "should update requested event - unmark as done" do
      Event.should_receive(:find).with("37").and_return(mock_event(:id => "37", :due => Date.today, :priority => 1, :title => "Event", :done => true))
      @mock_event.should_receive(:unmark_as_done).and_return(true)
      xhr :post, :done, :id => "37"
      response.should be_success  
      response.should have_rjs(:replace_html)           
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested event" do
      Event.should_receive(:find).with("37").and_return(mock_event)
      mock_event.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the events list" do
      Event.stub!(:find).and_return(mock_event(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(events_url)
    end
  end

end
