class TacommitmentsController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @tacommitment = Tacommitment.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   @tacommitments = Tacommitment.all
  end

  def edit
    @tacommitment = Tacommitment.find params[:id]
  end

  def destroy
    @tacommitment = Tacommitment.find(params[:id])
    @tacommitment.destroy
    flash[:notice] = "Tacommitment '#{@tacommitment.name}' deleted."
    redirect_to tacommitments_path
  end

  # replaces the 'create' method in controller:
  def create
    @tacommitment = Tacommitment.new(tacommitment_params)
    if @tacommitment.save
      flash[:notice] = "#{@tacommitment.name} was successfully created."
      redirect_to tacommitments_path
    else
      render 'new' # note, 'new' template can access @tacommitment's field values!
    end
  end
  # replaces the 'update' method in controller:
  def update
    @tacommitment = Tacommitment.find params[:id]
    if @tacommitment.update_attributes!(tacommitment_params)
      flash[:notice] = "#{@tacommitment.name} was successfully updated."
      redirect_to tacommitment_path(@tacommitment)
    else
      render 'edit' # note, 'edit' template can access @tacommitment's field values!
    end
  end
  # as a reminder, here is the original 'new' method:
  def new
    @tacommitment = Tacommitment.new
  end

  private

  def tacommitment_params
    params.require(:tacommitment).permit(:name, :commitments)
  end

end
