class EventAttendancesController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @attendance = @event.event_attendances.build(user: current_user)

    if @attendance.save
      redirect_to @event, notice: "You are now attending this event!"
    else
      redirect_to @event, alert: "Unable to attend this event."
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @attendance = @event.event_attendances.find_by(user: current_user)

    if @attendance&.destroy
      redirect_to @event, notice: "You are no longer attending this event."
    else
      redirect_to @event, alert: "Unable to remove attendance."
    end
  end
end
