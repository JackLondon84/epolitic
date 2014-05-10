class AffiliationsController < ApplicationController

	def create
		polititian = Polititian.find(entry_params[:polititian_id])
		affiliation = polititian.affiliations.build entry_params
		if affiliation.save
			flash[:success] = "Affiliation created successfully."
			redirect_to action: 'show', controller: 'institutions', id: affiliation.institution_id
		else
			redirect_to action: 'show', controller: 'institutions', id: affiliation.institution_id
		end
	end

	def destroy
	end

	def entry_params
		params.require(:affiliation).permit(:polititian_id, :institution_id, :start_at, :end_at)
	end

end
