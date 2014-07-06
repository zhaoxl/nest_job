module DiversityResult
  
  def dr_render
    respond_to do |format|
      format.html{
        yield
      }
      
      format.json {
        result = flash.to_hash.compact
        flash.clear
        render json: result.to_json
      }
      format.js {
        render json: result.to_json
      }
    end
  end
end