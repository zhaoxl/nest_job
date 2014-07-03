module DiversityResult
  
  def dr_render
    respond_to do |format|
      format.html{
        yield
      }
      
      if flash[:error].present?
        result = {status: "error", content: flash[:error]}
      elsif flash[:alert].present?
        result = {status: "alert", content: flash[:alert]}
      else
        result = {status: "ok", content: flash[:notice]}
      end
      flash[:error] = flash[:notice] = nil
      
      format.json {
        render json: result.to_json
      }
      format.js {
        render json: result.to_json
      }
    end
  end
end