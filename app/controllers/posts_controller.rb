class PostsController < ApplicationController
  before_action :require_login, except: %i[index show search]
  before_action :set_post, only: %i[show edit update delete] # Renomeie de destroy para delete

  # GET /posts or /posts.json
  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "Nenhum post encontrado."
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
        process_tags(@post, params[:post][:tag_names])
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
        process_tags(@post, params[:post][:tag_names])
        format.html { redirect_to @post, notice: "O Post foi atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @post }
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /posts/:id/delete
  def delete
    if @post.destroy
      redirect_to posts_path, notice: "O post foi removido com sucesso."
    else
      redirect_to @post, alert: "Erro ao tentar excluir o post. Por favor, tente novamente."
    end
  end

  # POST /posts/upload
  def upload
    if params[:file].present?
      file = params[:file]
      begin
        File.open(file.tempfile, "r").each_line do |line|
          title, author, body, tags = line.strip.split("|")
          post = Post.create(title: title, author: author, body: body)
          if post.persisted? && tags.present?
            tags.split(",").each do |tag_name|
              post.tags.find_or_create_by(name: tag_name.strip)
            end
          end
        end
        redirect_to posts_path, notice: "Posts e tags criados com sucesso!"
      rescue => e
        redirect_to posts_path, alert: "Erro ao processar o arquivo: #{e.message}"
      end
    else
      redirect_to posts_path, alert: "Por favor, selecione um arquivo para upload."
    end
  end

  private

  def set_post
    @post = Post.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_url, alert: "O post solicitado não foi encontrado."
  end

  def post_params
    params.require(:post).permit(:title, :author, :body, :tag_names)
  end

  def search_params
    params.permit(:q)
  end

  def process_tags(post, tag_names)
    return unless tag_names.present?

    post.tags.destroy_all # Remove tags antigas
    tag_names.split(",").map(&:strip).each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      post.tags << tag unless post.tags.include?(tag)
    end
  end
end
