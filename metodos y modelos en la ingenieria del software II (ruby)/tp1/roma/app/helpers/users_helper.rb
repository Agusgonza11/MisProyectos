# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  def format_preferences(preferences)
    preferences.downcase&.gsub(/\s+/, '')
  end
end
