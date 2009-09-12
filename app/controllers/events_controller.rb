class EventsController < ApplicationController

  after_filter :discard_flash_if_xhr
  
  # GET /events
  # GET /events.xml
  def index
    nextday = future_date(params[:period])    
    @events = Event.fetch_for_period(Date.today, nextday)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
      format.js {
        render :update do |page|
          page.replace_html "event_#{@event.id}", :partial => "events/list_item", :locals => {:list_item => @event}
        end        
      }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html {}
      format.js {
        render :update do |page|
          page.replace_html "event_#{@event.id}", :partial => "events/quickie_edit"
        end
      }
    end    
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def create_quickie
    @event = Event.new(params[:event])    
    
    respond_to do |format|
      if @event.save    
        flash[:notice] = 'Event was successfully created.'
        format.html {
          render :update do |page|
            page.insert_html :top, "events_list", :partial => "events/list_item", :locals => {:list_item => @event}
            page.visual_effect :highlight, "event_#{@event.id}"               
            @event.title = ""
            @event.priority = 1
            @event.due = Date.today
            page.replace_html "quickie_form", :partial => "events/quickie_new"
            page["notice"].replace_html flash[:notice]
          end
        }
      else
        format.html { 
          render :partial => "events/quickie_new", :status => 444, :layout => false
        }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end  
    end      
  end

  def done
    @event = Event.find(params[:id])    
    (@event.done) ? @event.unmark_as_done : @event.mark_as_done
    
    respond_to do |format|
      flash[:notice] = 'Event was updated.'
      format.js {
        render :update do |page|
          page.replace_html "event_#{@event.id}", :partial => "/events/list_item", :locals => {:list_item => @event}
          page.replace_html "notice", flash[:notice]
        end        
      }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|             
      flash[:notice] = 'Event was NOT updated.' 
      format.js {
        render :update do |page|
          page["notice"].replace_html flash[:notice]            
        end
      }
    end    
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
        format.js {
          render :update do |page|
            page.replace_html "event_#{@event.id}", :partial => "/events/list_item", :locals => {:list_item => @event}
            page["notice"].replace_html flash[:notice]            
          end          
        }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
        format.js {
          render :partial => "/events/quickie_edit", :status => 444, :layout => false
        }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      flash[:notice] = 'Event was successfully deleted.' 
    end

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def future_date(period)
    today = Date.today
    
    case period
    when 'today'       
      nextday = today + 1      
    when 'week'        
      nextday = today.next_week
    when 'month'             
      nextday = today.next_month
    when 'year'               
      nextday = today.next_year
    else  
      nextday = today + 1
    end    
    
    nextday
  end         

  protected
  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end
  
end
