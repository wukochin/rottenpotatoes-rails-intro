class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @by = params[:by]
    @ratings = params[:ratings]
    
    # remember settings
    session.delete(:some_key)
    by_remembered = @by.blank? && session[:by].present?
    ratings_remembered = @ratings.blank? && session[:ratings].present?
    if by_remembered || ratings_remembered
        @ratings = session[:ratings] if ratings_remembered
        @by = session[:by] if by_remembered
        # RESTful URL
        flash.keep
        redirect_to :ratings => @ratings, :by => @by and return
    end

    # highlight title
    @title_header = 'hilite' if @by == 'title'
    @release_date_header = 'hilite' if @by == 'release_date'

    @all_ratings = Movie.ratings
    @ratings ||= Hash[ @all_ratings.map { |d| [d, 1] }]
    @movies = Movie.order(@by).where( :rating => @ratings.keys)

    # save sessions
    session[:by] = @by
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
