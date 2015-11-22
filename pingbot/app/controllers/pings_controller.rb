class PingsController < ApplicationController
  before_action :set_ping, except: [:index, :create]

  # GET /pings
  # GET /pings.json
  def index
    @pings = @organization.pings
    render json: @pings
  end

  # GET /pings/1
  # GET /pings/1.json
  def show
    render json: @ping
  end

  # POST /pings
  # POST /pings.json
  def create
    @ping = @organization.pings.build(ping_params)

    if @ping.save
      render json: @ping, status: :created, location: @ping
    else
      render json: @ping.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pings/1
  # PATCH/PUT /pings/1.json
  def update
    if @ping.update(ping_params)
      head :no_content
    else
      render json: @ping.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pings/1
  # DELETE /pings/1.json
  def destroy
    @ping.destroy
    head :no_content
  end

  # GET /pings/1/healthy
  # GET /pings/1/healthy.json
  def healthy
    @ping.healthy!
    head :ok
  end

  # GET /pings/1/inactive
  # GET /pings/1/inactive.json
  def inactive
    @ping.inactive!
    head :ok
  end

  private

  def set_ping
    @ping = @organization.pings.find_by_uri(params[:id])
  end

  def ping_params
    params.require(:ping).permit(:name, :description)
  end
end
