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
    if params[:sort]
      session[:sort] = params[:sort]
      @hilite = session[:sort]
    end

    if params[:release_date]
      session[:release_date] = params[:release_date]
      @hilite = session[:release_date]
    end
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    @all_ratings = Movie.get_ratings

    @hilite = (session[:sort] if session[:sort]) || (session[:release_date] if session[:release_date])
    @checked_ratings = (session[:ratings].keys if session[:ratings]) || @all_ratings

    @movies = Movie.order(@hilite).where(rating: @checked_ratings)
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
