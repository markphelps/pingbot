class OrganizationsController < ApplicationController

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    render json: @organization
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    if @organization.update(organization_params)
      head :no_content
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
