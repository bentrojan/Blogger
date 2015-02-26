class ArticlesController < ApplicationController
	include ArticlesHelper

	before_filter :require_login, except: [ :index, :show ]

	def index
		@articles = Article.all
	end

	def show
		@article = Article.find(params[:id])
		@comment = Comment.new
		@comment.article_id = @article.id
	end

	before_filter :zero_authors_or_authenticated, only: [ :new, :create ]

	def zero_authors_or_authenticated
		unless Author.count == 0 || current_user
			redirect_to root_path
			return false
		end
	end


	def new
		@article = Article.new
	end

	def create 
		@article = Article.new(article_params)
		@article.save

		flash.notice = "'#{@article.title}' Created!"

		redirect_to article_path(@article)
	end

	def destroy
		@article = Article.find(params[:id])
		@article.destroy

		flash.notice = "'#{@article.title}' Deleted!"

		redirect_to articles_path
	end

	def edit
		@article = Article.find(params[:id])
	end

	def update
		@article = Article.find(params[:id])
		@article.update(article_params)

		flash.notice = "Article '#{@article.title}' Updated!"

		redirect_to article_path(@article)
	end

end
