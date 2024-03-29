class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	@all_ratings = Movie.all_ratings
    
    @sort_by = params[:sort_by]
	@selected_ratings = params[:ratings]
    
    if (session[:ratings] == nil) 
      session[:ratings] = {}
      @all_ratings.each { |r| session[:ratings][r] = 1 }
    end

    if (@selected_ratings == nil)
      @selected_ratings = session[:ratings]
      @sort_by = session[:sort_by]
      flash.keep
      redirect_to movies_path(:sort_by => @sort_by, :ratings => @selected_ratings)
    end

    session[:ratings] = @selected_ratings 
    session[:sort_by] = @sort_by

    case @sort_by
	when "title"
     @movies = Movie.order(@sort_by).find(:all,
                :conditions => {:rating => (@selected_ratings.keys) })
     @title_header = "hilite"
	when "release_date"
     @movies = Movie.order(@sort_by).find(:all,
                :conditions => {:rating => (@selected_ratings.keys) })
     @release_date_header = "hilite"
	else 
	 @movies = Movie.find(:all,
                :conditions => {:rating => (@selected_ratings.keys) })
	end
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
