class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comments_params)

    if logged_in? && params[:comment][:anonymous] == "true"
      @comment.author = "Anônimo" # Define o autor como "Anônimo" se o checkbox estiver marcado
    elsif logged_in?
      @comment.user = current_user # Associa o comentário ao usuário logado
    end

    if @comment.save
      redirect_to @comment.post, notice: "Comentário publicado com sucesso!"
    else
      redirect_to @comment.post, alert: "Erro ao publicar comentário."
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:post_id, :author, :body)
  end
end
