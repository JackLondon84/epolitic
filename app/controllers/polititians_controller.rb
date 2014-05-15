class PolititiansController < ApplicationController

#  before_filter :authenticate_user!,
#    :only => [:new, :create, :edit, :update, :destroy]

	def index
		@polititians = Polititian.where(nil) # creates an anonymous scope
		@polititians = @polititians.filter_by_group_id(params[:group_id]) if params[:group_id].present?
		@polititians = @polititians.filter_by_institution_id(params[:institution_id]) if params[:institution_id].present?
		@polititians = @polititians.search(params[:term]) if params[:term].present?

		respond_to do |format|  
	      format.html # index.html.erb  
	      format.json { render :json => @polititians.map{|p| Hash.new.merge("label" => p.full_name, "value" => p.id)}.to_json}
	    end 

	end

	def show
		@polititian = Polititian.find(params[:id])
		@job = Job.new
		@jobs = @polititian.jobs.order(end_at: :desc)
		@non_political_jobs = @polititian.jobs.non_political_jobs
		@political_jobs = @polititian.jobs.political_jobs
		@education = Education.new
		@educations = @polititian.educations.order(end_at: :desc)
		@trial = Trial.new
		@trials = @polititian.trials.order(end_at: :desc)
		@exam = Exam.new
		@exams = @polititian.exams.order(date: :desc)
		@affiliation = Affiliation.new
		@affiliations = @polititian.affiliations
		@groups = Group.all
#		@polititian_group = @polititian.group
	end

	def new
		@polititian = Polititian.new
		@polititian.affiliations.build
	end

	def create
		@polititian = Polititian.new entry_params
		if @polititian.save
			redirect_to action: 'show', controller: 'polititians', id: @polititian.id
			flash[:success] = "Perfil creado."
		else
			render 'new'
		end
	end

	def edit
		@polititian = Polititian.find params[:id]
	end

	def update
		@polititian = Polititian.find params[:id]
		if @polititian.update_attributes(entry_params)
			redirect_to action: 'show', controller: 'polititians', id: @polititian.id
			flash[:success] = "Perfil editado."
		else
			render 'edit'
		end	
	end

	def destroy
		@polititian = Polititian.find params[:id]
		@polititian.destroy
		redirect_to action: 'index', controller: 'polititians'
		flash[:success] = "Perfil borrado."
	end
	
	def entry_params
		params.require(:polititian).permit(:id, :first_name, :last_name, :avatar, :remote_avatar_url, :group_id,  :affiliations_attributes => [:institution_id, :polititian_id] )
	end

end