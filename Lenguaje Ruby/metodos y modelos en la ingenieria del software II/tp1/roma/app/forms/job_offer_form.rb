class JobOfferForm
  attr_accessor :id, :title, :location, :description, :labels

  def self.from(a_job_offer)
    form = JobOfferForm.new
    form.id = a_job_offer.id
    form.title = a_job_offer.title
    form.location = a_job_offer.location
    form.description = a_job_offer.description
    form.labels = a_job_offer.labels
    form
  end
end
