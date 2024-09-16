# Helper methods defined here can be accessed in any controller or view in the application

JobVacancy::App.helpers do
  def format_labels(params)
    params[:labels] = params[:labels]&.downcase&.gsub(/\s+/, '')
    params
  end

  def job_offer_params
    format_labels(params[:job_offer_form].to_h.symbolize_keys)
  end
end
