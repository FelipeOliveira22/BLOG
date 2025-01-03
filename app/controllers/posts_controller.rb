class PostsController < ApplicationController
  before_action :require_login, except: %i[index show search]
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
  end

  def search
    @posts = Post.search(search_params[:q])
  end
  # GET /posts/1 or /posts/1.json
  def show
    @comments = @post.comments.order(created_at: :desc)
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "O Post foi criado com sucesso!" }
        format.json { render :show, status: :created, location: @post }
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "O Post foi atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /posts/1 or /posts/1.json
def destroy
  @post.destroy
  respond_to do |format|
    format.html { redirect_to posts_url, notice: "O post foi removido com sucesso." }
    format.json { head :no_content }
  end
end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_url, alert: "O post solicitado não foi encontrado."
  end

  def post_params
    params.require(:post).permit(:title, :author, :body)
  end

  def search_params
    params.permit(:q)
  end

  def post_params
    params.require(:post).permit(:title, :body, :author)
  end
end
