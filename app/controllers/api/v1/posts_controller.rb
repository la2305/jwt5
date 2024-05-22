class Api::V1::PostsController < ApiController
  load_and_authorize_resource except: :all_posts
  before_action :set_post, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:all_posts]

  def all_posts
    @posts = Post.includes(:type, :user)
    if params[:post_name].present?
      @posts = @posts.where("posts.name LIKE ?", "%#{params[:post_name]}%")
    end
    if params[:type_id].present?
      @posts = @posts.where("posts.type_id = ?", params[:type_id])
    end
    @posts = @posts.page(params[:current_page]).per(params[:per_page])
    total_pages = @posts.total_pages
    posts_with_user_name = @posts.map do |post|
      {
        post: post,
        user_email: post.user.email
      }
    end
    render json: { posts: posts_with_user_name, total_pages: total_pages }, include: :type, status: :ok
  end

  def index
    @posts = current_user.posts;
    render json: @posts, include: :type, status: :ok
  end

  def show
    render json: @post, include: :type , status: :ok
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :ok
    else
      render json: {data: @post.errors.full_messages, status: "failed"},
      status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: { data: @post.errors.full_messages, status: "failed"},
        status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      render json: 'delete success', status: :ok
    else
      render json: { data: 'something went wrong', status: 'failed'}
    end
  end


  def set_post
    @post = current_user.posts.find_by_id(params[:id])
  rescue ActiveRecord::RecordNotFound => error
    render json: error.message, status: :unauthorized
  end

  def post_params
    params.require(:post).permit(:name, :content, :user_id, :type_id)
  end
end
