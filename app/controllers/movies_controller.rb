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
    @all_ratings = Movie.all_ratings

    if params[:flag]
      session[:flag] = params[:flag]
    elsif session[:flag]
      params[:flag] = session[:flag]
      flash.keep
      redirect_to movies_path(params) and return
    end
    
    flag_by = session[:flag]


    if params[:ratings]
      session[:ratings] = params[:ratings]
      @checked_ratings = session[:ratings].keys
    elsif session[:ratings]
      params[:ratings] = session[:ratings]
      @checked_ratings = session[:ratings].keys
      flash.keep
      redirect_to movies_path(params) and return
    else
      @checked_ratings = @all_ratings
    end

    @movies = Movie.all.order(flag_by).where(rating: @checked_ratings)
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
