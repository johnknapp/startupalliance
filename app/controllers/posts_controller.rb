class PostsController < InheritedResources::Base

  private

    def post_params
      params.require(:post).permit(:body, :discussion_id, :pid)
    end
end

