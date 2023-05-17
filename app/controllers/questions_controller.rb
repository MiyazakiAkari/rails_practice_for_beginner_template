class QuestionsController < ApplicationController
    def index
        @questions = Question.all
        @q = Question.ransack(params[:q])
        @questions = @q.result(distinct: true).page(params[:page]).per(5)
        @search_path = questions_path
    end

    def solved
        @q = Question.where(solved: true).ransack(params[:q])
        @questions = @q.result(distinct: true).page(params[:page]).per(5)
        @search_path = solved_questions_path
        render :index
    end

    def unsolved
        @q = Question.where(solved: false).ransack(params[:q])
        @questions = @q.result(distinct: true).page(params[:page]).per(5)
        @search_path = unsolved_questions_path
        render :index
    end

    def show
        @question = Question.find(params[:id])
    end

    def new
        @question = Question.new
    end

    def create
        @question = current_user.questions.build(question_params)
        if @question.save
            flash[:success] = '質問を投稿しました。'
            redirect_to question_path(@question)
        else
            flash.now[:danger] = '質問の投稿に失敗しました。'
            render :new
        end
    end

    def edit
        @question = current_user.questions.find(params[:id])
    end

    def update
        @question = current_user.questions.find(params[:id])
        if @question.update(question_params)
            flash[:success] = '質問を更新しました。'
            redirect_to question_path(@question)
        else
            flash.now[:danger] = '質問の更新に失敗しました。'
            render :edit
        end
    end

    def destroy
        @question = current_user.questions.find(params[:id])
        @question.destroy!
        redirect_to questions_path, success: '質問を削除しました。'
    end

    def solve
        @question = current_user.questions.find(params[:id])
        @question.update!(solved: true)
        redirect_to question_path(@question), success: '解決済みにしました。'
    end

    private

    def question_params
        params.require(:question).permit(:title, :body)
    end
end
