module Admin
  class ConfigurationsController < ApplicationController
    def edit
      @organization_configuration = OrganizationConfiguration.get
    end

    def update
      @organization_configuration = OrganizationConfiguration.get
      @organization_configuration.update!(organization_params)

      redirect_to edit_admin_configuration_path, notice: "Filter updated successfully"
    end

    private

    def organization_params
      params.require(:organization_configuration).permit(:conditions_filter)
    end
  end
end
