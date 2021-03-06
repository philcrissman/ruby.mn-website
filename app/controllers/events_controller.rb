class EventsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only=>:show

  def index
    if current_user.admin?
      @events = Event.find(:all, :order=>'scheduled_time DESC')
    else
      @user = current_user
      @events = @user.events
    end
  end

  def user_index
    if logged_in? 
      if current_user.admin? && params[:user_id]
        @events = User.find(params[:user_id]).events
      else
        @events = current_user.events
      end
      render :template=>'events/index'
    else
      bounce
    end
  end

  def approve
    if current_user and current_user.admin?
      Event.find(params[:id]).approved=true
    else
      current_user.events.find(params[:id]).approved=true
    end
  end

  def create
    @event = current_user.events.create(params[:event])
    if @event.save
      redirect_to user_index_events_path
      Notifier.deliver_notify_event(@event)
    else
      render :template=>'events/new'
    end
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
    if @event.save
      redirect_to event_path(@event)
    else
      render :template=>'events/edit'
    end
  end

  def new
    @event = Event.new
  end


  def destroy
    if current_user && current_user.admin?
      Event.destroy(params[:id])
    else
      current_user.events.find(params[:id]).destroy
    end
    flash[:info]='Record Deleted'
    redirect_to admin_path
  end


  def edit
    if current_user && current_user.admin?
      @event = Event.find(params[:id])
    else
      @event=current_user.events.find(params[:id])
    end
  end

  def show
    @event= Event.find(params[:id])
  end

end
