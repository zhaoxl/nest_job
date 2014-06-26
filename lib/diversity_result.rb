module DiversityResult
  
  def dr_render
    respond_to do |format|
      format.html{
        yield
      }
      
      if flash[:error].present?
        result = {status: "error", content: flash[:error]}
      else
        result = {status: "ok", content: flash[:ok]}
      end
      flash[:error] = flash[:notice] = flash[:ok] = nil
      
      format.json {
        render json: result.to_json
      }
      format.js {
        render json: result.to_json
      }
    end
  end
end