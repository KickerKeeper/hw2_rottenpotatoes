class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   
    @movies = []
    @all_ratings = Movie.all.map(&:rating).uniq
    @rating_hash_container = []

    if (params.has_key?(:ratings))
      @all_ratings.each do |rating|
        @rating_hash_container << {:rating => rating, :rating_selected => params[:ratings].keys.include?(rating)}
      end
      params[:ratings].each do |r|
        @movies += Movie.where("rating = ?", r[0])
      end
    else
      @movies = Movie.all
      @all_ratings.each do |rating|
        @rating_hash_container << {:rating => rating, :rating_selected => false}
      end
    end

    if (params.has_key?(:order))
      if (params[:order] == 'byTitle' )
        @movies = @movies.sort_by!{ |x| x.title }
        @title_header = 'hilite'
      elsif (params[:order] == 'byDate')
        @movies = @movies.sort_by!{ |x| x.release_date }
        @release_header = 'hilite'
      end
    end
    
    @title_path = request.query_parameters.merge({:order=>"byTitle"})
    @release_path = request.query_parameters.merge({:order=>"byDate"})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
