class JobApplicationRepository < BaseRepository
  self.table_name = :job_applications
  self.model_class = 'JobApplication'

  def applicants_count(offer)
    dataset.where(job_offer_id: offer.id).count
  end

  def save(a_record)
    if dataset.where(
      Sequel[job_offer_id: a_record.job_offer.id] &
      Sequel[email: a_record.applicant_email]
    ).count.positive?
      return
    end

    !insert(a_record).nil?
  end

  def insert(a_record)
    dataset.insert(changeset(a_record)) if a_record.valid?
    a_record
  end

  def update(_a_record)
    0
  end

  protected

  def load_object(a_record)
    job_application = super
    job_application.offer = JobOfferRepository.new.find(a_record[:job_offer_id])
    job_application
  end

  def changeset(job_application)
    {
      job_offer_id: job_application.job_offer.id,
      email: job_application.applicant_email
    }
  end
end
