class Admin::ArticlesController < AdminController

  before_filter :set_article, only: [:edit, :update]
  
  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:success] = "Article was saved"
      redirect_to article_path(@article)
    else
      flash.new[:danger] = "There was a problem and the article was not saved"
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

  private

  def set_article
    @article = Article.find_by(slug: params[:id])    
  end

  def article_params
    params.require(:article).permit(:title, :main_image_url, :body, :article_topic_ids, :bootsy_image_gallery_id)
  end

end