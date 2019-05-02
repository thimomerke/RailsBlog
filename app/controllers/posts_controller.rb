class PostsController < ApplicationController

    before_action :find_post, only: [:show, :edit, :update, :destroy]
    before_action :authenticate, only: [:admin, :new, :create, :edit, :update, :destroy]

    def index
        if params[:category].blank?
            @category_id = Category.find_by(name: 'Hidden').id
            @posts = Post.where.not(category_id: @category_id).order("created_at DESC")          
        else
            @category_id = Category.find_by(name: params[:category]).id
            if params[:category] == "Hidden"
                @posts = Post.where(category_id: @category_id).order("created_at DESC") if authenticate
            else
                @posts = Post.where(category_id: @category_id).order("created_at DESC")
            end
        end
    end

    def show
		  if request.path != post_path(@post)
		  	redirect_to @post, status: :moved_permanently
	  	end
  	end

    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_params)

        if @post.save
            redirect_to @post, notice: "The post was created!"
        else
            render 'new'
        end
    end

    def edit
    end

    def update
        if @post.update(post_params)
            redirect_to @post, notice: "Update successful"
        else
            render 'edit'
        end
    end

    def destroy
        @post.destroy
        redirect_to root_path, notice: "Post destroyed"
    end

    def admin
        redirect_to root_path if authenticate
    end

private
    def post_params
		params.require(:post).permit(:title, :author, :content, :category_id, :image, :slug)
	end

    def find_post
		@post = Post.friendly.find(params[:id])
	end
end

protected_methods
    def authenticate
        authenticate_or_request_with_http_basic do |username, password|
        admin_username= "thimom"
        admin_password= "Ichinmannheim99!"

        session[:admin] = true if (username == admin_username && password == admin_password)
    end
end
