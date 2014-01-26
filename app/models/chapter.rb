class Chapter < ActiveRecord::Base
	belongs_to :course
	validates :number, uniqueness:true

	def index

	end

	def new
		@chapter = chapter.new
	end

	def create
		@chapter = chapter.create(permitted_params.chapter)

		if @chapter.save
			puts "chapter: #{@chapter.name} created successfully."
		else
			puts "chapter: #{@chapter.name} creation failed."
		end

	end

	def edit 
		@chapter = chapter.find(params[:id])
	end

	def update
		@chapter = chapter.find(params[:id])

  		if @chapter.update_attributes(permitted_params.chapter)
  			puts "chapter: #{@chapter.name} updated successfully."
  		else
  			puts "chapter: #{@chapter.name} updated failed."
  		end
    
	end

	def destroy
    	
    	@chapter = chapter.find(params[:id])
    	@chapter.destroy

    	puts "Destroyed: #{@chapter.name} chapter."
  	end


end
