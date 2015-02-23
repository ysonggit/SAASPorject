class MeetingsController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @meeting = Meeting.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   @meetings = Meeting.all
  end

  def edit
    @meeting = Meeting.find params[:id]
  end

  def destroy
    @meeting = Meeting.find(params[:id])
    @meeting.destroy
    flash[:notice] = "Meeting '#{@meeting.course}' deleted."
    redirect_to meetings_path
  end

  # replaces the 'create' method in controller:
  def create
    @meeting = Meeting.new(meeting_params)
    if @meeting.save
      flash[:notice] = "#{@meeting.course} was successfully created."
      redirect_to meetings_path
    else
      render 'new' # note, 'new' template can access @meeting's field values!
    end
  end
  # replaces the 'update' method in controller:
  def update
    @meeting = Meeting.find params[:id]
    if @meeting.update_attributes(meeting_params)
      flash[:notice] = "#{@meeting.course} was successfully updated."
      redirect_to meeting_path(@meeting)
    else
      render 'edit' # note, 'edit' template can access @meeting's field values!
    end
  end
  # as a reminder, here is the original 'new' method:
  def new
    @meeting = Meeting.new
  end
  
  private

  def meeting_params
    params.require(:meeting).permit(:course, :section, :start, :end, :day, :instructor)
  end

end
