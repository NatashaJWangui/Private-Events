class EventsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_event, only: [ :show ]
  before_action :check_creator, only: [ :edit, :update, :destroy ]

  def index
    @upcoming_events = Event.upcoming.order(:date)
    @past_events = Event.past.order(date: :desc)
  end

  def show
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event was successfully deleted."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def check_creator
    redirect_to events_path, alert: "You can only edit your own events." unless @event.creator == current_user
  end

  def event_params
    params.require(:event).permit(:title, :description, :date, :location)
  end
end
