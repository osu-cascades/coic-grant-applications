module CompaniesHelper

	def get_application(app_ein)
    Application.find_by(ein: app_ein)
  end
end
