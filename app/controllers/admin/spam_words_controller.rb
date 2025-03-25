class Admin::SpamWordsController < Admin::BaseController
  before_action :set_spam_word, only: [:edit, :update, :destroy]

  def index
    @spam_words = SpamWord.all.order(created_at: :desc)
  end

  def new
    @spam_word = SpamWord.new
  end

  def create
    @spam_word = SpamWord.new(spam_word_params)

    if @spam_word.save
      redirect_to admin_spam_words_path, notice: 'Spam word was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @spam_word.update(spam_word_params)
      redirect_to admin_spam_words_path, notice: 'Spam word was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @spam_word.destroy
    redirect_to admin_spam_words_path, notice: 'Spam word was successfully destroyed.'
  end

  private

  def set_spam_word
    @spam_word = SpamWord.find(params[:id])
  end

  def spam_word_params
    params.require(:spam_word).permit(:word, :replacement, :active)
  end
end