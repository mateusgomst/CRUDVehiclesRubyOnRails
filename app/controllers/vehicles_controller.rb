class VehiclesController < ApplicationController
  def index
    @vehicles = Vehicle.all.order(created_at: :desc)
  end

  def new
    @vehicle = Vehicle.new
  end
  
  def create
    @vehicle = Vehicle.new(vehicle_params)

    # Verifica o formato da placa antes de tentar atualizar
    if invalid_plate_format?(vehicle_params[:plate])
      flash[:error] = "Invalid plate format. Please enter in the format XXX-0000."
      render :edit and return
    end

    if @vehicle.save
      redirect_to vehicle_path(@vehicle)
    else
      render :new
    end
  end

  def show 
    @vehicle = Vehicle.find(params[:id])
  end

  def edit 
    @vehicle = Vehicle.find(params[:id])
  end

  def update
    @vehicle = Vehicle.find(params[:id])

    # Verifica o formato da placa antes de tentar atualizar
    if invalid_plate_format?(vehicle_params[:plate])
      flash[:error] = "Invalid plate format. Please enter in the format XXX-0000."
      render :edit and return
    end

    if @vehicle.update(vehicle_params)
      redirect_to vehicle_path(@vehicle)
    else
      render :edit
    end
  end

  def destroy
    @vehicle = Vehicle.find(params[:id])
    @vehicle.destroy
    redirect_to vehicles_path
  end

  private

  def vehicle_params #strong parameters
    params.require(:vehicle).permit(:brand, :model, :year, :plate, :kind)
  end

  def invalid_plate_format?(plate)
    !plate.match(/\A[A-Z]{3}-\d{4}\z/)
  end
end
