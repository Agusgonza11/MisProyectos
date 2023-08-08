LOGIN_REQUIRED_MESSAGE = 'You need to be logged in to apply to an offer!'.freeze
APPLICATION_SUCCESSFUL_MESSAGE = 'Contact information sent.'.freeze

JobVacancy::App.controllers :job_offers do
  get :my do
    @offers = JobOfferRepository.new.find_by_owner(current_user)
    @job_application_repo = JobApplicationRepository.new
    render 'job_offers/my_offers'
  end

  get :index do
    @offers = JobOfferRepository.new.all_active
    render 'job_offers/list'
  end

  get :new do
    @job_offer = JobOfferForm.new
    render 'job_offers/new'
  end

  get :latest do
    @offers = JobOfferRepository.new.all_active
    render 'job_offers/list'
  end

  get :edit, with: :offer_id do
    @job_offer = JobOfferForm.from(JobOfferRepository.new.find(params[:offer_id]))
    # TODO: validate the current user is the owner of the offer
    render 'job_offers/edit'
  end

  post :search do
    @offers = JobOfferRepository.new.search(params[:q])
    render 'job_offers/list'
  end

  post :apply, with: :offer_id do
    unless signed_in?
      flash[:error] = LOGIN_REQUIRED_MESSAGE
      redirect '/job_offers'
      return
    end
    job_offers_repo = JobOfferRepository.new
    job_application_repo = JobApplicationRepository.new
    @job_offer = job_offers_repo.find(params[:offer_id])
    applicant_email = current_user.email
    @job_application = JobApplication.create_for(applicant_email, @job_offer)
    @job_application.process
    job_offers_repo.save(@job_offer)
    job_application_repo.save(@job_application)
    flash[:success] = APPLICATION_SUCCESSFUL_MESSAGE
    redirect '/job_offers'
  end

  post :create do
    job_offer = JobOffer.new(job_offer_params)
    job_offer.owner = current_user
    if JobOfferRepository.new.save(job_offer)
      TwitterClient.publish(job_offer) if params['create_and_twit']
      flash[:success] = 'Offer created'
      redirect '/job_offers/my'
    end
  rescue ActiveModel::ValidationError => e
    @job_offer = JobOfferForm.new
    @errors = e.model.errors
    flash.now[:error] = 'Please review the errors'
    render 'job_offers/new'
  end

  post :update, with: :offer_id do
    @job_offer = JobOffer.new(job_offer_params.merge(id: params[:offer_id]))
    @job_offer.owner = current_user

    if JobOfferRepository.new.save(@job_offer)
      flash[:success] = 'Offer updated'
      redirect '/job_offers/my'
    end
  rescue ActiveModel::ValidationError => e
    @job_offer = JobOfferForm.new
    @errors = e.model.errors
    flash.now[:error] = 'Please review the errors'
    render 'job_offers/edit'
  end

  put :activate, with: :offer_id do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    @job_offer.activate
    if JobOfferRepository.new.save(@job_offer)
      flash[:success] = 'Offer activated'
    else
      flash.now[:error] = 'Operation failed'
    end

    redirect '/job_offers/my'
  end

  delete :destroy do
    @job_offer = JobOfferRepository.new.find(params[:offer_id])
    if JobOfferRepository.new.destroy(@job_offer)
      flash[:success] = 'Offer deleted'
    else
      flash.now[:error] = 'Title is mandatory'
    end
    redirect 'job_offers/my'
  end
end
