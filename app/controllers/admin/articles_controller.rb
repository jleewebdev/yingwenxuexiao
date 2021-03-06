class Admin::ArticlesController < AdminController

  before_filter :set_article, only: [:edit, :update, :destroy]
  
  def new
    @article = Article.new
  end

  def index
    @articles = Article.all
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      flash[:success] = "Article was saved"
      redirect_to article_path(@article)
    else
      flash.now[:danger] = "There was a problem and the article was not saved"
      render :new
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = "Article was saved"
      redirect_to article_path(@article)
    else
      flash[:danger] = "Article was not saved"
      render :edit
    end
  end

  def destroy
    if @article.destroy
      flash[:success] = "Article deleted"
      redirect_to blog_path
    else
      flash.now[:danger] = "Article not deleted"
      render :edit
    end
  end

  private

  def set_article
    @article = Article.find_by(slug: params[:id])
  end

  def article_params
    params.require(:article).permit!
  end

end